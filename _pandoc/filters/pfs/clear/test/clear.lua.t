  $ pandoc --to native -L clear.lua <<EOF
  > ::: notes
  > Test
  > :::
  > EOF
  [clear.lua] Filter clear.lua is deprecated 
  []

  $ pandoc --to native -L clear.lua <<EOF
  > ::: task
  > Test
  > :::
  > EOF
  [ Div ( "" , [ "task" ] , [] ) [ Para [ Str "Test" ] ] ]
