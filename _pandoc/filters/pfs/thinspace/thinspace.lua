local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/../?.lua", package.path, pandoc_script_dir)

require 'lib.number'
require 'lib.list'
require 'lib.log'

set_log_source 'thinspace.lua'

local thinsp = "\xe2\x80\xaf"

local function is_uri(e)
  return next({e.text:match '%a+://.+'})
end

local function is_mail_address(e)
  return next({e.text:match '[^@]+@[^@]+'})
end

local function split_after_each_dot(s)
  return s:gmatch '([^%.]+%.?)'
end

local exceptions = {'«', '‹', '“' ,'"', ','}

function utf8.first(s)
  local second = utf8.offset(s, 2)
  return s:sub(1, second - 1)
end

local function concat(i, sep)
  local s = i()
  if not(s) then return "" end
  for e in i do
    -- print(s, e, utf8.first(e))
    if contains(exceptions, utf8.first(e)) then
      pinfof('Skip thinspace before substring %s', e)
      s = s .. e
    else
      s = s .. sep .. e
    end
  end
  return s
end

local thinspace = {
  Str = function(e)
    if is_numeric(e) then
      pinfof('Skip %s as numeric', e.text)
      return nil
    end

    if is_uri(e) then
      pinfof('Skip %s as URI', e.text)
      return nil
    end

    if is_mail_address(e) then
      pinfof('Skip %s as email-address', e.text)
      return nil
    end

    local a = split_after_each_dot(e.text)
    local s = concat(a, thinsp)

    return pandoc.Str(s)
  end
}

function Pandoc(doc) 
  -- Only apply thinspace on the content, not the metadata
  doc.blocks = doc.blocks:walk(thinspace)
  return doc
end
