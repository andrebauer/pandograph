  $ pandoc -L kinds.lua -t plain << EOF
  > # Hello
  > EOF
  

  $ pandoc -L kinds.lua -t plain << EOF
  > ---
  > kinds: doc
  > ---
  > EOF
  doc

  $ pandoc -L kinds.lua -t plain << EOF
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
