local fmt = string.format
local stringify = pandoc.utils.stringify
local type = pandoc.utils.type

local log_level_of_verbosity = {
  ERROR = 1,
  WARNING = 2,
  INFO = 3
}

local verbosity = PANDOC_STATE.verbosity
log_level = log_level_of_verbosity[verbosity]

local log_source = nil

function set_log_source(name)
  log_source = name
end

function plnstderr(l, ...)
  if log_level >= l then
    if log_source then
      io.stderr:write(fmt('[%s] ', log_source))
    end
    for i, w in ipairs({...}) do
      io.stderr:write(fmt('%s ', w))
    end
    io.stderr:write('\n')
  end
end

function pstderr(l, ...)
  if log_level >= l then
    for i, w in ipairs({...}) do
      io.stderr:write(fmt('%s ', w))
    end
  end
end

function perr(...)
  plnstderr(1, ...)
end

function pwarn(...)
  plnstderr(2, ...)
end

function pinfo(...)
  plnstderr(3, ...)
end

function perrf(f, ...)
  plnstderr(1, fmt(f, ...))
end

function pwarnf(f, ...)
  plnstderr(2, fmt(f, ...))
end

function pinfof(f, ...)
  plnstderr(3, fmt(f, ...))
end

local type = pandoc.utils.type

local function ws(depth)
  local ws = ''
  while depth > 0 do
    ws = ws .. ' '
    depth = depth - 1
  end
  return ws
end

function spairs(t)
  local keys = {}
  for key, _ in pairs(t) do
    keys[#keys + 1] = key
  end
  table.sort(keys)

  local n = 0
  local function getKV()
    n = n + 1
    if keys[n] then
      return keys[n], t[keys[n]]
    end
  end

  return getKV
end

function pobj(l, o, depth)
  local depth = depth
  if not(depth) then depth = 0 end
  local function perr(...) pstderr(l, ...) end
  if type(o) == 'nil' then perr('nil', '\n') end
  if type(o) == 'number' then perr(o, '\n') end
  if type(o) == 'string' then perr(o, '\n') end
  if type(o) == 'boolean' then perr(o, '\n') end
  if type(o) == 'Inlines' then perr(stringify(o) .. '\n') end
  if type(o) == 'Blocks' then perr(stringify(o) .. '\n') end
  if type(o) == 'table' then
    perr('\n')
    for k, v in spairs(o) do
      perr(ws(depth), k .. ':')
      pobj(l, v, depth + 2)
    end
  end
end

function perrobj(o)
  pobj(1, o, 0)
end

function pwarnobj(o)
  pobj(2, o, 0)
end

function pinfoobj(o)
  pobj(3, o, 0)
end
