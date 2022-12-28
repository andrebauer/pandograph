require 'lib.tools'

function get_opts(known_options, chosen_options)
  known_args = known_options.args or {}
  known_opts = known_options.opts or {}
  local opts = append(known_opts, known_args)

  for i, v in ipairs(opts) do
      local is_arg = includes(known_args, v)
      local is_opt = includes(known_opts, v)
      if is_opt and (chosen_options[v] == true or chosen_options[v] == 'true') then
          opts[i] = fmt("--%s", v)
      elseif is_arg and type(chosen_options[v]) ~= 'boolean' then
          opts[i] = fmt("--%s %s", v, chosen_options[v])
      else
          opts[i] = ""
      end
  end
  return opts
end
