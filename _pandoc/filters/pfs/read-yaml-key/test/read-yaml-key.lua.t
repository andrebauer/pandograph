  $ YAML_KEY=kinds pandoc -L read-yaml-key.lua -t plain << EOF
  > # Hello
  > EOF
  
  $ YAML_KEY=kinds pandoc -L read-yaml-key.lua -t plain << EOF
  > ---
  > kinds: doc
  > ---
  > EOF
  doc

  $ YAML_KEY=kinds pandoc -L read-yaml-key.lua -t plain << EOF
  > ---
  > kinds:
  > - doc
  > - exercise
  > - solution
  > ---
  > EOF
  doc
  exercise
  solution

  $ YAML_KEY=output pandoc -L read-yaml-key.lua -t plain << EOF
  > # Hello
  > EOF
  

  $ YAML_KEY=output pandoc -L read-yaml-key.lua -t plain << EOF
  > ---
  > output: lua/filters.html
  > ---
  > EOF
  lua/filters.html

  $ YAML_KEY=output pandoc -L read-yaml-key.lua -t plain << EOF
  > ---
  > output:
  > - lua/filters.html
  > ---
  > EOF
  lua/filters.html


  $ YAML_KEY=output pandoc -L read-yaml-key.lua -t plain << EOF
  > ---
  > output:
  > - lua/filters.html
  > - pandoc/lua-filters.pdf
  > ---
  > EOF
  lua/filters.html
  pandoc/lua-filters.pdf
