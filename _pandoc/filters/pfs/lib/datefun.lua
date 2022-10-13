local fmt = string.format

local pandoc_script_dir = pandoc.path.directory(PANDOC_SCRIPT_FILE)
package.path = fmt("%s;%s/lib/?.lua", package.path, pandoc_script_dir)

local stringify = pandoc.utils.stringify

date = require 'date'

function parse(s)
  local day, month, year = string.match(stringify(s),'(%d+). *(%d+). *(%d+)')
  return date(year, month, day)
end

function spanmonths(s1, s2)
  local d1 = parse(s1)
  local d2 = parse(s2)
  local diff = d2 - d1
  local years = diff:getyear() - 1
  local months = diff:getmonth() - 1
  local days = diff:getday()
  if days <= 31 and days >= 25 then
    months = months + 1
  elseif days < 25 and days > 13 then
    months = months + 0.5
  end
  return years * 12 + months
end

function first_day_of_month(s)
  local d = parse(s)
  return d:fmt('1.%m.%Y')
end
