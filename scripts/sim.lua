-- Icarus Verilog and Verilator backends.
local util = require('scripts.util')
local M = {SRC_DIR = 'src', INCLUDE_DIR = 'src/core', BUILD_DIR = 'build'}
M.findFiles = util.findFiles

local function sources(testbench)
  local files = util.findFiles(M.SRC_DIR, '.v')
  files[#files+1] = testbench
  return files
end

local icarus = {name = 'icarus'}
function icarus.build(top, testbench)
  local dir = util.join(M.BUILD_DIR, 'icarus')
  local exe = util.join(dir, top .. '.vvp')
  util.mkdir(dir)
  local args = {'-g2012', '-DSIMULATION', '-I', M.INCLUDE_DIR, '-s', top, '-o', exe}
  for _, p in ipairs(sources(testbench)) do args[#args+1] = p end
  -- Always compile; .vvp files depend on the producing vvp version.
  local result = util.run('iverilog', args)
  if not result.ok then return {ok=false, log=result.output} end
  return {ok=true, run=function(plusargs)
    local argv = {'-n', exe}
    for _, a in ipairs(plusargs) do argv[#argv+1] = a end
    return util.run('vvp', argv)
  end}
end

local verilator = {name = 'verilator'}
function verilator.build(top, testbench)
  local dir = util.join(M.BUILD_DIR, 'verilator', top)
  local exe = util.join(dir, 'V' .. top)
  util.mkdir(dir)
  local files = sources(testbench)
  local inputs = {}
  for _, p in ipairs(files) do inputs[#inputs+1] = p end
  for _, p in ipairs(util.findFiles(M.INCLUDE_DIR, '.vh')) do inputs[#inputs+1] = p end
  if util.isStale(exe, inputs) then
    local args = {'--binary', '--timing', '--trace', '-j', '0',
      '-Wno-fatal', '-Wno-lint', '-Wno-style', '-DSIMULATION',
      '-I' .. M.INCLUDE_DIR, '--top-module', top, '--Mdir', dir}
    for _, p in ipairs(files) do args[#args+1] = p end
    local result = util.run('verilator', args)
    if not result.ok then return {ok=false, log=result.output} end
  end
  return {ok=true, run=function(plusargs) return util.run(exe, plusargs) end}
end

M.SIMULATORS = {icarus=icarus, verilator=verilator}
return M
