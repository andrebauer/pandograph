  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >   div:
  >    - notes
  >    - task
  > ---
  > 
  > ::: notes
  > Test
  > :::
  > EOF
  []

  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >   div:
  >    - notes
  >    - task
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
  > strip-classes:
  >   div: notes
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
  > strip-classes:
  >   div: 
  >    - columns
  >   span:
  >    - notes
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
  [ Div ( "" , [ "notes" ] , [] ) [ Para [ Str "Test" ] ] ]
