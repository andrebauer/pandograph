local fmt = string.format

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

function pstderr(l, ...)
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

function perr(...)
  pstderr(1, ...)
end

function pwarn(...)
  pstderr(2, ...)
end

function pinfo(...)
  pstderr(3, ...)
end

function perrf(f, ...)
  pstderr(1, fmt(f, ...))
end

function pwarnf(f, ...)
  pstderr(2, fmt(f, ...))
end

function pinfof(f, ...)
  pstderr(3, fmt(f, ...))
end
