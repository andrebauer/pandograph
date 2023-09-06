Title-to-first-header-Filter

  $ pandoc --to markdown -L title-to-first-heading.lua << EOF
  > ---
  > title: Hello World!
  > ---
  > ## Some Header
  > 
  > This is the main content.
  > EOF
  # Hello World!
  
  ## Some Header
  
  This is the main content.

  $ pandoc --to markdown -L title-to-first-heading.lua << EOF
  > ## Some Header
  > 
  > This is the main content.
  > EOF
  ## Some Header
  
  This is the main content.
