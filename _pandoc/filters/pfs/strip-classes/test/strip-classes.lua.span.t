  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >   span:
  >    - notes
  >    - task
  > ---
  > 
  > [Test]{.notes}
  > 
  > EOF
  [ Para [] ]

  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >   span:
  >    - notes
  >    - task
  > ---
  > 
  > [Test]{.notes}
  > 
  > [Cols]{.columns}
  > 
  > EOF
  [ Para []
  , Para [ Span ( "" , [ "columns" ] , [] ) [ Str "Cols" ] ]
  ]


  $ pandoc --to native -L strip-classes.lua <<EOF
  > ---
  > strip-classes:
  >   span: notes
  > ---
  > 
  > [Test]{.notes}
  > 
  > [Cols]{.columns}
  > EOF
  [ Para []
  , Para [ Span ( "" , [ "columns" ] , [] ) [ Str "Cols" ] ]
  ]


  $ pandoc --to native -L strip-classes.lua <<EOF
  > 
  > [Test]{.notes}
  > 
  > [Cols]{.columns}
  > 
  > EOF
  [ Para [ Span ( "" , [ "notes" ] , [] ) [ Str "Test" ] ]
  , Para [ Span ( "" , [ "columns" ] , [] ) [ Str "Cols" ] ]
  ]
