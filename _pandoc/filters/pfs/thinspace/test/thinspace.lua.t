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

  $ echo »Hello.« | pandoc -t latex -L thinspace.lua
  »Hello.«

  $ echo ›Hello.‹ | pandoc -t latex -L thinspace.lua --verbose 2>&1 | grep --invert -E "Completed filter thinspace.lua"
  [INFO] Running filter thinspace.lua
  [thinspace.lua] Skip thinspace before substring ‹ 
  ›Hello.‹


  $ echo „Hello.“ | pandoc -t latex -L thinspace.lua
  „Hello.``


  $ echo '"Hello."' | pandoc -t latex -L thinspace.lua
  ``Hello.''


  $ echo »Hello.« | pandoc -t latex -L thinspace.lua
  »Hello.«

  $ echo d.h., | pandoc -t latex -L thinspace.lua
  d.\,h.,

  $ echo »d.h.,« | pandoc -t latex -L thinspace.lua
  »d.\,h.,«

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


Preserve URIs

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


Preserve email-addresses

  $ pandoc --to native -L thinspace.lua << EOF
  > <send.me.mail@example.org>
  > EOF
  [ Para
      [ Link
          ( "" , [ "email" ] , [] )
          [ Str "send.me.mail@example.org" ]
          ( "mailto:send.me.mail@example.org" , "" )
      ]
  ]

Verbose log messages
  $ pandoc --to html5 -L thinspace.lua --verbose << EOF 2>&1 | grep --invert -E "Completed filter thinspace.lua"
  > <send.me.mail@example.org>  
  > <https://example.org/>  
  > 203.0.113.195/27  
  > 203.0.113.195  
  > O.B.d.A.  
  > 2.5  
  > EOF
  [INFO] Running filter thinspace.lua
  [thinspace.lua] Skip send.me.mail@example.org as email-address 
  [thinspace.lua] Skip https://example.org/ as URI 
  [thinspace.lua] Skip 203.0.113.195/27 as numeric 
  [thinspace.lua] Skip 203.0.113.195 as numeric 
  [thinspace.lua] Skip 2.5 as numeric 
  <p><a href="mailto:send.me.mail@example.org"
  class="email">send.me.mail@example.org</a><br />
  <a href="https://example.org/"
  class="uri">https://example.org/</a><br />
  203.0.113.195/27<br />
  203.0.113.195<br />
  O. B. d. A.<br />
  2.5</p>
