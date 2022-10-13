Non-breaking Space Filter

  $ echo "1.·place" | pandoc -t latex -L nbspace.lua
  1.~place

  $ echo "Hello·World!" | pandoc -t html5 -L nbspace.lua
  <p>Hello World!</p>

  $ echo "1th·place" | pandoc -t beamer -L nbspace.lua
  \begin{frame}
  1th~place
  \end{frame}

  $ echo "2nd·place" | pandoc -t docx -L nbspace.lua -o nbspace.docx

  $ pandoc -t latex nbspace.docx
  2nd~place

  $ echo "2nd·place" | pandoc -t odt -L nbspace.lua -o nbspace.odt

  $ pandoc -t latex nbspace.odt
  2nd~place
