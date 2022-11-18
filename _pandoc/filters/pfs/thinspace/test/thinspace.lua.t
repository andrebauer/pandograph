Thinspace-Filter

  $ echo hello | pandoc -t native -L thinspace.lua
  [ Para [ Str "hello" ] ]

  $ echo z.B. | pandoc -t native -L thinspace.lua
  [ Para [ Str "z.\8239B." ] ]

  $ echo "a.a.O." | pandoc -t html5 -L thinspace.lua
  <p>a. a. O.</p>

  $ echo Prof.Dr. | pandoc -t latex -L thinspace.lua
  Prof.\,Dr.

  $ echo "a.a.O." | pandoc -t latex -L thinspace.lua
  a.\,a.\,O.

  $ echo "O.B.d.A." | pandoc -t latex -L thinspace.lua
  O.\,B.\,d.\,A.

  $ echo "n.Chr." | pandoc -t latex -L thinspace.lua
  n.\,Chr.

  $ echo "3.5" | pandoc -t latex -L thinspace.lua
  3.5

  $ echo "2.Platz" | pandoc -t latex -L thinspace.lua
  2.\,Platz

  $ echo "Hallo Welt." | pandoc -t native -L thinspace.lua
  [ Para [ Str "Hallo" , Space , Str "Welt." ] ]

  $ echo "z.B. u.a. usw." | pandoc -t beamer -L thinspace.lua
  \begin{frame}
  z.\,B. u.\,a. usw.
  \end{frame}

  $ echo "a.a.O." | pandoc -t docx -L thinspace.lua -o thinspace.docx

  $ pandoc -t latex thinspace.docx
  a.\,a.\,O.

  $ echo "a.a.O. u.a. usw." | pandoc -t odt -L thinspace.lua -o thinspace.odt

  $ pandoc -t latex thinspace.odt
  a.\,a.\,O. u.\,a. usw.

  $ echo 203.0.113.195 | pandoc -t latex -L thinspace.lua
  203.0.113.195

  $ echo 203.0.113.195/27 | pandoc -t latex -L thinspace.lua
  203.0.113.195/27

  $ echo 1.120.113.195,27 | pandoc -t latex -L thinspace.lua
  1.120.113.195,27

  $ pandoc --to gfm -L thinspace.lua -s <<EOF
  > ---
  > logo: assets/images/ars-logo-2015.pdf
  > ---
  > EOF
  ---
  logo: assets/images/ars-logo-2015.pdf
  ---
  
  $ pandoc --from native --to native -L thinspace.lua <<EOF
  > [ Plain [ Str "" ] ]
  > EOF
  [ Plain [ Str "" ] ]

  $ pandoc --to native -L thinspace.lua << EOF
  > <https://example.org/>
  > EOF
  [ Para
      [ Link
          ( "" , [ "uri" ] , [] )
          [ Str "https://example.org/" ]
          ( "https://example.org/" , "" )
      ]
  ]
