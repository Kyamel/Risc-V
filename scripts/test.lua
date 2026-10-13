-- RV32E processor tests.
-- Usage: lua scripts/test.lua [unit|prog|all] [--sim=icarus|verilator] [--trace] [--wave] [name ...]
local util = require('scripts.util')
local simmod = require('scripts.sim')
local assemble = require('scripts.assemble').assemble
local SIMULATORS, BUILD_DIR = simmod.SIMULATORS, simmod.BUILD_DIR
local TB_DIR, CPU_TB, PROGRAMS_DIR, REG_COUNT = 'tb', 'tb/core/tb_cpu.v', 'tests/programs', 16
local function u32(n) return n & 0xffffffff end
local function hex32(n) return string.format('0x%08x', u32(n)) end
local function signed(n) n=u32(n); return n >= 0x80000000 and n-0x100000000 or n end
local function parseNum(s)
  local sign, body = s:match('^([%-+]?)(.+)$')
  if not body then return nil end
  local base, digits = 10, body
  if body:match('^0[xX]') then base, digits = 16, body:sub(3)
  elseif body:match('^0[bB]') then base, digits = 2, body:sub(3)
  elseif body:match('^0[oO]') then base, digits = 8, body:sub(3) end
  local value = tonumber(digits, base)
  if not value then return nil end
  return u32(sign == '-' and -value or value)
end
local function stripAnsi(s) return s:gsub('\27%[[%d;]*m', '') end
local function color(code, s) return (os.getenv('NO_COLOR') or os.getenv('TERM') == 'dumb') and s or ('\27['..code..'m'..s..'\27[0m') end
local function unitTests()
  local tests = {}
  for _, file in ipairs(util.findFiles(TB_DIR, '.v')) do
    if file ~= CPU_TB and util.basename(file):match('^tb_') then
      tests[#tests+1] = {name=util.stem(file):gsub('^tb_', ''), file=file}
    end
  end
  return tests
end
local function programTests()
  local tests = {}
  for _, file in ipairs(util.findFiles(PROGRAMS_DIR, '.s')) do
    tests[#tests+1] = {name=util.stem(file), file=file}
  end
  return tests
end
local function runUnit(test, sim)
  local build = sim.build(util.stem(test.file), test.file)
  if not build.ok then return {failures={'compilation error:', build.log}} end
  local result = build.run({})
  local logfile = util.join(BUILD_DIR, sim.name, 'logs', test.name .. '.log')
  util.mkdir(util.join(BUILD_DIR, sim.name, 'logs'))
  util.write(logfile, result.output)
  local passes, failures = 0, {}
  for _, line in ipairs(util.lines(stripAnsi(result.output))) do
    if line:find('[PASS]', 1, true) then passes=passes+1 end
    if line:find('[FAIL]', 1, true) then failures[#failures+1]=line:match('^%s*(.-)%s*$') end
  end
  if not result.ok then failures[#failures+1]='the simulation exited with an error (see '..logfile..')' end
  if passes + #failures == 0 then failures[#failures+1]='no [PASS]/[FAIL] checks in the output (see '..logfile..')' end
  return {failures=failures, info=passes..' checks'}
end
local function parseAnnotations(source, file)
  local spec = {regs={}, mem={}, init={}, cycles=1000, regCount=0, memCount=0}
  for _, line in ipairs(util.lines(source)) do
    local kind, content = line:match('#%s*(%a+)%s*:%s*(.*)$')
    if kind then
      kind=kind:lower()
      if kind=='cycles' then
        local cycles=tonumber(content)
        if not cycles or cycles < 1 or cycles % 1 ~= 0 then error(file..': invalid cycles annotation') end
        spec.cycles=cycles
      elseif kind=='expect' or kind=='init' then
        for token in content:gmatch('[^%s,]+') do
          local r, value = token:match('^x(%d+)=(.+)$')
          local addr, memvalue = token:match('^mem%[(.-)%]=(.+)$')
          if r and kind=='expect' then
            local reg=tonumber(r)
            if reg>=REG_COUNT then error(file..': x'..r..' does not exist in RV32E (only x0-x15)') end
            local n=parseNum(value)
            if not n then error(file..': invalid number '..value) end
            if spec.regs[reg]==nil then spec.regCount=spec.regCount+1 end
            spec.regs[reg]=n
          elseif addr then
            local a, n = parseNum(addr), parseNum(memvalue)
            if not a or not n then error(file..': invalid annotation '..token) end
            if a % 4 ~= 0 then error(file..': unaligned memory address '..addr) end
            local target = kind=='expect' and spec.mem or spec.init
            if target[a]==nil and kind=='expect' then spec.memCount=spec.memCount+1 end
            target[a]=n
          else error(file..': invalid annotation "'..token..'" in "'..line..'"') end
        end
      end
    end
  end
  return spec
end
local function describe(pc, instr, listing)
  if instr=='00000000' then return '(bubble)' end
  if instr:find('[xzXZ]') then return '?? '..instr end
  if instr=='00000013' then return 'nop' end
  local item=listing[tonumber(pc,16)]
  return item and item.hex==instr and item.asm or instr
end
local function printTrace(lines, listing)
  local W=22
  local function cell(s)
    s=stripAnsi(s)
    if #s>W then return s:sub(1,W-1)..'~' end
    return s..string.rep(' ', W-#s)
  end
  print(table.concat({'cycle',cell('IF'),cell('ID'),cell('EX'),cell('MEM'),cell('WB'),'events'}, ' | '))
  local fwdName={['01']='WB',['10']='MEM'}
  for _, line in ipairs(lines) do
    local f={}
    for field in line:gmatch('%S+') do f[#f+1]=field end
    -- TRACE cycle IF_PC IF_INSTR ID_PC ID_INSTR EX_PC EX_INSTR MEM_PC MEM_INSTR WB_PC WB_INSTR ...
    local stages={}
    for i=3,11,2 do stages[#stages+1]=cell(describe(f[i],f[i+1],listing)) end
    local flush,stall,fwdA,fwdB,wbWe,wbRd,wbData,memWe,memAddr,memData,illegal=table.unpack(f,13,23)
    local events={}
    local function add(s) events[#events+1]=s end
    if illegal=='1' then add('ILLEGAL') end
    if flush=='1' then add('FLUSH') end
    if stall=='1' then add('STALL') end
    if fwdName[fwdA] then add('fwdA<-'..fwdName[fwdA]) end
    if fwdName[fwdB] then add('fwdB<-'..fwdName[fwdB]) end
    if wbWe=='1' and wbRd~='0' then add('x'..wbRd..'<-0x'..wbData) end
    if memWe=='1' then add('mem[0x'..memAddr..']<-0x'..memData) end
    local row={string.format('%5s',f[2])}
    for _,stage in ipairs(stages) do row[#row+1]=stage end
    row[#row+1]=table.concat(events,' ')
    print(table.concat(row,' | '))
  end
end
local function runProgram(test, sim, cpu, options)
  local source=util.read(test.file)
  local ok,spec=pcall(parseAnnotations,source,test.file)
  if not ok then return {failures={tostring(spec)}} end
  local failures={}
  local dir=util.join(BUILD_DIR,'programs',test.name)
  local program=assemble(test.file,dir)
  if not program.ok then return {failures={'assembler error:',program.error}} end
  local progFile=util.join(dir,'prog.hex')
  util.write(progFile,table.concat(program.words,'\n')..'\n')
  local plusargs={'+PROG='..progFile,'+END='..string.format('%x',#program.words*4),'+MAX_CYCLES='..spec.cycles}
  if next(spec.init) then
    local max=0
    for addr in pairs(spec.init) do if addr>max then max=addr end end
    local words={}
    for addr=0,max,4 do words[#words+1]=string.format('%08x',spec.init[addr] or 0) end
    local dataFile=util.join(dir,'data.hex')
    util.write(dataFile,table.concat(words,'\n')..'\n')
    plusargs[#plusargs+1]='+DATA='..dataFile
  end
  if options.trace then plusargs[#plusargs+1]='+TRACE' end
  if options.wave then plusargs[#plusargs+1]='+VCD='..util.join(dir,sim.name..'.vcd') end
  local result=cpu.run(plusargs)
  local regs,mem,cycles,timeout={}, {},nil,false
  local trace={}
  for _, line in ipairs(util.lines(result.output)) do
    local pc, instr=line:match('^ILLEGAL ([%da-fA-F]+) ([%da-fA-F]+)$')
    if pc then failures[#failures+1]='illegal instruction 0x'..instr..' at pc 0x'..pc..' (names a register above x15)' end
    local reg,value=line:match('^REG (%d+) (%S+)$')
    if reg then regs[tonumber(reg)]=value end
    local addr,data=line:match('^MEM ([%da-fA-F]+) (%S+)$')
    if addr then mem[tonumber(addr,16)]=data end
    local kind,count=line:match('^(HALT) (%d+)$')
    if not kind then kind,count=line:match('^(TIMEOUT) (%d+)$') end
    if kind then cycles=tonumber(count); timeout=kind=='TIMEOUT' end
    if line:sub(1,6)=='TRACE ' then trace[#trace+1]=line end
  end
  if options.trace then print('\n=== '..test.name..' ==='); printTrace(trace,program.listing) end
  if not cycles then return {failures={'the simulation did not finish normally:',result.output}} end
  if timeout then failures[#failures+1]='did not reach the end of the program in '..cycles..' cycles (infinite loop?)' end
  local function check(label,expected,actual)
    local expectedHex=string.format('%08x',expected)
    actual=actual or '00000000'
    if actual:lower()~=expectedHex then
      local n=tonumber(actual,16)
      local shown=n and (hex32(n)..' ('..signed(n)..')') or actual
      failures[#failures+1]=label..': expected '..hex32(expected)..' ('..signed(expected)..'), got '..shown
    end
  end
  for reg,expected in pairs(spec.regs) do check('x'..reg,expected,regs[reg]) end
  for addr,expected in pairs(spec.mem) do check('mem['..hex32(addr)..']',expected,mem[addr]) end
  if spec.regCount+spec.memCount==0 then failures[#failures+1]='no "# expect:" in the program' end
  local info=cycles..' cycles'
  if options.wave then info=info..', gtkwave '..util.join(dir,sim.name..'.vcd') end
  return {failures=failures,info=info}
end
local function report(kind,test,result)
  local status=#result.failures==0 and color('32','PASS') or color('31','FAIL')
  print(status..' '..kind..'/'..test.name..(result.info and ' ('..result.info..')' or ''))
  for _, failure in ipairs(result.failures) do print('     '..failure) end
  return #result.failures==0
end
local function main()
  local positional,flags={},{}
  for i=1,#arg do
    local a=arg[i]
    if a:sub(1,2)=='--' then flags[a]=true else positional[#positional+1]=a end
  end
  local mode='all'
  if positional[1]=='unit' or positional[1]=='prog' or positional[1]=='all' then mode=table.remove(positional,1) end
  local simName='icarus'
  for flag in pairs(flags) do if flag:sub(1,6)=='--sim=' then simName=flag:sub(7) end end
  local sim=SIMULATORS[simName]
  if not sim then io.stderr:write('Unknown simulator: '..simName..' (use icarus or verilator)\n'); os.exit(2) end
  local options={trace=flags['--trace'],wave=flags['--wave']}
  local units=mode=='prog' and {} or unitTests()
  local programs=mode=='unit' and {} or programTests()
  local available={}
  for _,t in ipairs(units) do available[t.name]=true end
  for _,t in ipairs(programs) do available[t.name]=true end
  for _,name in ipairs(positional) do
    if not available[name] then
      io.stderr:write('Test not found: '..name..'\n')
      os.exit(2)
    end
  end
  local selected={}
  for _,name in ipairs(positional) do selected[name]=true end
  local function pick(tests)
    if #positional==0 then return tests end
    local result={}
    for _,test in ipairs(tests) do if selected[test.name] then result[#result+1]=test end end
    return result
  end
  units,programs=pick(units),pick(programs)
  print('simulator: '..sim.name)
  local passed,total=0,0
  for _,test in ipairs(units) do
    total=total+1
    if report('unit',test,runUnit(test,sim)) then passed=passed+1 end
  end
  if #programs>0 then
    local cpu=sim.build('tb_cpu',CPU_TB)
    if not cpu.ok then io.stderr:write('Failed to compile the processor:\n'..cpu.log..'\n'); os.exit(2) end
    for _,test in ipairs(programs) do
      total=total+1
      if report('prog',test,runProgram(test,sim,cpu,options)) then passed=passed+1 end
    end
  end
  print(string.format('\n%d/%d tests passed',passed,total))
  os.exit(passed==total and 0 or 1)
end
main()
