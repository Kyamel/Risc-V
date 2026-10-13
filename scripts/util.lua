-- Shared filesystem, path and process helpers (Lua 5.4 + LuaFileSystem).
local lfs = require('lfs')
local M = {}

function M.join(...)
  local parts = {...}
  return table.concat(parts, '/')
end

function M.basename(p)
  return p:match('([^/]+)$') or p
end

function M.stem(p)
  return M.basename(p):gsub('%.[^.]+$', '')
end

function M.mkdir(dir)
  local current = dir:sub(1, 1) == '/' and '/' or ''
  for part in dir:gmatch('[^/]+') do
    current = current == '' and part or (current == '/' and '/' .. part or current .. '/' .. part)
    local mode = lfs.attributes(current, 'mode')
    if mode == nil then assert(lfs.mkdir(current))
    elseif mode ~= 'directory' then error('not a directory: ' .. current) end
  end
end

function M.read(path, mode)
  local f = assert(io.open(path, mode or 'rb'))
  local s = assert(f:read('*a'))
  f:close()
  return s
end

function M.write(path, content)
  local f = assert(io.open(path, 'wb'))
  assert(f:write(content))
  assert(f:close())
end

function M.lines(s)
  local result = {}
  for line in (s .. '\n'):gmatch('(.-)\n') do result[#result+1] = line end
  return result
end

function M.findFiles(dir, ext)
  local result = {}
  local function visit(p)
    for entry in lfs.dir(p) do
      if entry ~= '.' and entry ~= '..' then
        local full = M.join(p, entry)
        local mode = lfs.attributes(full, 'mode')
        if mode == 'directory' then visit(full)
        elseif mode == 'file' and full:sub(-#ext) == ext then result[#result+1] = full end
      end
    end
  end
  visit(dir)
  table.sort(result)
  return result
end

function M.quote(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

-- Capture combined stdout/stderr without io.popen (works with Lua 5.4).
function M.run(cmd, args)
  local parts = {M.quote(cmd)}
  for _, a in ipairs(args or {}) do parts[#parts+1] = M.quote(a) end
  local tmp = os.tmpname()
  local command = table.concat(parts, ' ') .. ' >' .. M.quote(tmp) .. ' 2>&1'
  local ok, _, code = os.execute(command)
  local f = io.open(tmp, 'rb')
  local output = f and f:read('*a') or ''
  if f then f:close() end
  os.remove(tmp)
  if code == 127 then
    output = string.format("'%s' not found. Enter the dev shell with \"nix develop\".", cmd)
  end
  return {ok = ok == true, output = output}
end

-- Conservative rebuild: equal timestamps also count as stale, because
-- LuaFileSystem may report only whole-second mtime resolution.
function M.isStale(output, inputs)
  local built = lfs.attributes(output, 'modification')
  if not built then return true end
  for _, p in ipairs(inputs) do
    local modified = lfs.attributes(p, 'modification')
    if not modified or modified >= built then return true end
  end
  return false
end

return M
