  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >  - notes
  >  - task
  > ---
  > 
  > ::: notes
  > Test
  > :::
  > EOF
  []

  $ pandoc --to native -L strip-classes.lua -M strip-classes=notes -M strip=task <<EOF
  > ::: notes
  > Test
  > :::
  > EOF
  []

  $ pandoc --to native -L strip-classes.lua -M strip-classes=notes <<EOF
  > ::: notes
  > Test
  > :::
  > EOF
  []

  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >  - notes
  >  - task
  > ---
  > 
  > ::: notes
  > Test
  > :::
  > 
  > ::: columns
  > Cols
  > :::
  > EOF
  [ Div ( "" , [ "columns" ] , [] ) [ Para [ Str "Cols" ] ] ]


  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes: notes
  > ---
  > 
  > ::: notes
  > Test
  > :::
  > 
  > ::: columns
  > Cols
  > :::
  > EOF
  [ Div ( "" , [ "columns" ] , [] ) [ Para [ Str "Cols" ] ] ]


  $ pandoc --to native -L strip-classes.lua <<EOF
  > ::: notes
  > Test
  > :::
  > 
  > ::: columns
  > Cols
  > :::
  > EOF
  [ Div ( "" , [ "notes" ] , [] ) [ Para [ Str "Test" ] ]
  , Div ( "" , [ "columns" ] , [] ) [ Para [ Str "Cols" ] ]
  ]
