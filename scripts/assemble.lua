-- RV32E GNU assembler: lua scripts/assemble.lua <input.s> [output]
local util = require('scripts.util')
local M = {}
local PREFIX = 'riscv32-none-elf-'
local ARCH = {'-march=rv32e', '-mabi=ilp32e'}
local function run(tool, args)
  return util.run(PREFIX .. tool, args)
end

function M.assemble(source, outDir)
  util.mkdir(outDir)
  local obj = util.join(outDir, 'prog.o')
  local elf = util.join(outDir, 'prog.elf')
  local bin = util.join(outDir, 'prog.bin')
  local steps = {
    {'as', {ARCH[1], ARCH[2], '-o', obj, source}},
    {'ld', {'-m', 'elf32lriscv', '-Ttext=0', '-e', '0', '-o', elf, obj}},
    {'objcopy', {'-O', 'binary', '-j', '.text', elf, bin}},
  }
  for _, step in ipairs(steps) do
    local result = run(step[1], step[2])
    if not result.ok then return {ok=false, error=result.output:match('^%s*(.-)%s*$')} end
  end
  local bytes = util.read(bin)
  if #bytes % 4 ~= 0 then return {ok=false, error='Binary size is not a multiple of 4 bytes'} end
  local words = {}
  for i=1,#bytes,4 do words[#words+1] = string.format('%08x', string.unpack('<I4', bytes, i)) end
  local listing = {}
  local dump = run('objdump', {'-d', '-M', 'numeric', elf})
  if not dump.ok then return {ok=false, error=dump.output} end
  for _, line in ipairs(util.lines(dump.output)) do
    local addr, hex, mnemonic, operands = line:match('^%s*([%da-fA-F]+):%s+([%da-fA-F]+)%s+(%S+)%s*(.*)$')
    if addr and #hex == 8 then
      operands = operands:gsub('%s*#.*$', ''):gsub(',', ', ')
      listing[tonumber(addr, 16)] = {hex=hex:lower(), asm=(mnemonic .. ' ' .. operands):match('^%s*(.-)%s*$')}
    end
  end
  return {ok=true, words=words, listing=listing}
end

local function main()
  local input = arg[1]
  local output = arg[2] or 'output'
  if not input then io.stderr:write('Usage: lua scripts/assemble.lua <input.s> [output]\n'); os.exit(1) end
  local temp = os.tmpname()
  os.remove(temp)
  assert(require('lfs').mkdir(temp))
  local result = M.assemble(input, temp)
  if not result.ok then io.stderr:write(result.error .. '\n'); os.exit(1) end
  local addresses = {}
  for addr in pairs(result.listing) do addresses[#addresses+1] = addr end
  table.sort(addresses)
  for _, addr in ipairs(addresses) do
    local entry = result.listing[addr]
    print(string.format('%04x: %s  %s', addr, entry.hex, entry.asm))
  end
  util.write(output .. '.hex', table.concat(result.words, '\n') .. '\n')
  print('\nWrote ' .. output .. '.hex')
end

if arg and arg[0] and arg[0]:match('assemble%.lua$') then main() end
return M
