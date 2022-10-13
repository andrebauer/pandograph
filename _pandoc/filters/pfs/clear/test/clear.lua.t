

  $ pandoc --to native -L clear.lua <<EOF
  > ::: notes
  > Test
  > :::
  > EOF
  []

  $ pandoc --to native -L clear.lua <<EOF
  > ::: task
  > Test
  > :::
  > EOF
  [ Div ( "" , [ "task" ] , [] ) [ Para [ Str "Test" ] ] ]
