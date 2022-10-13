  $ URL_PREFIX='https://example.com' pandoc -L relativize.lua --from markdown --to markdown << EOF
  > [Example](https://example.com/example/file.pdf)
  > EOF
  [Example](/example/file.pdf)


  $ URL_PREFIX='https://example.com' pandoc -L relativize.lua --from markdown --to markdown << EOF
  > <https://other.com/example/file.pdf>
  > <https://example.com/example/file.pdf>
  > EOF
  <https://other.com/example/file.pdf>
  [/example/file.pdf](/example/file.pdf){.uri}


  $ URL_PREFIX='https://example.com' pandoc -L relativize.lua --from markdown --to native << EOF
  > <https://example.com/example/file.pdf>
  > EOF
  [ Para
      [ Link
          ( "" , [ "uri" ] , [] )
          [ Str "/example/file.pdf" ]
          ( "/example/file.pdf" , "" )
      ]
  ]


  $ URL_PREFIX='https://myexample.com' pandoc -L relativize.lua --from markdown --to markdown << EOF
  > [Example](https://example.com/example/file.pdf)
  > EOF
  [Example](https://example.com/example/file.pdf)
