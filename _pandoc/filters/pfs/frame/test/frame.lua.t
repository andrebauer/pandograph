  $ pandoc --to latex -L frame.lua <<EOF
  > ::: frame
  > Framed content
  > :::
  > EOF
  \begin{filebox}{}
  
  Framed content
  
  \end{filebox}

  $ pandoc --to gfm -L frame.lua <<EOF
  > ::: frame
  > Framed content
  > :::
  > EOF
  <details>
  
  Framed content
  
  </details>

  $ pandoc --to latex -L frame.lua <<EOF
  > ::: {.frame title="My Frame"}
  > Framed content
  > :::
  > EOF
  \begin{filebox}{My Frame}
  
  Framed content
  
  \end{filebox}

  $ pandoc --to gfm -L frame.lua <<EOF
  > ::: {.frame title="My Frame"}
  > Framed content
  > :::
  > EOF
  <details>
  <summary>
  **My Frame**
  </summary>
  
  Framed content
  
  </details>

  $ pandoc --to latex -L frame.lua <<EOF
  > ::: {.file}
  > File content
  > :::
  > EOF
  \begin{filebox}{}
  
  File content
  
  \end{filebox}

  $ pandoc --to gfm -L frame.lua <<EOF
  > ::: {.file}
  > File content
  > :::
  > EOF
  <details>
  
  File content
  
  </details>


  $ pandoc --to latex -L frame.lua <<EOF
  > ::: {.file title=\`/usr/local/share/lua/lib.lua\`}
  > File content
  > :::
  > EOF
  \begin{filebox}{`/usr/local/share/lua/lib.lua`}
  
  File content
  
  \end{filebox}

  $ pandoc --to gfm -L frame.lua <<EOF
  > ::: {.file title=\`/usr/local/share/lua/lib.lua\`}
  > File content
  > :::
  > EOF
  <details>
  <summary>
  **\`/usr/local/share/lua/lib.lua\`**
  </summary>
  
  File content
  
  </details>


  $ pandoc --to native -L frame.lua <<EOF
  > ::: {.file title=\`/usr/local/share/lua/lib.lua\`}
  > File content
  > :::
  > EOF
  [ Para
      [ Str "Die"
      , Space
      , Str "Datei"
      , Space
      , Code ( "" , [] , [] ) "/usr/local/share/lua/lib.lua"
      , Str ":"
      ]
  , Para [ Str "File" , Space , Str "content" ]
  ]

  $ pandoc --to plain -L frame.lua <<EOF
  > ::: {.file title=\`/usr/local/share/lua/lib.lua\`}
  > File content
  > :::
  > EOF
  Die Datei /usr/local/share/lua/lib.lua:
  
  File content
