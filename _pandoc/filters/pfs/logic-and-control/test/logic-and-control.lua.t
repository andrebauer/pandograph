  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > content: all
  > ---
  > [My Content]{.if content="all"}
  > EOF
  [ Para
      [ Span
          ( "" , [ "if" ] , [ ( "content" , "all" ) ] )
          [ Str "My" , Space , Str "Content" ]
      ]
  ]

  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > content: none
  > ---
  > [My Content]{.if content="all"}
  > EOF
  [ Para [ Space ] ]

  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > fruits:
  >   - lemon
  >   - apple
  >   - banana
  > ---
  > ::: {.for .elem in=meta.fruits}
  > - \`elem\`{.var}
  > :::
  > EOF
  [ BulletList [ [ Plain [ Str "lemon" ] ] ]
  , BulletList [ [ Plain [ Str "apple" ] ] ]
  , BulletList [ [ Plain [ Str "banana" ] ] ]
  ]

  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > fruits:
  >   - lemon
  >   - apple
  >   - banana
  > ---
  > ::: {.for var=elem in=meta.fruits}
  > - \`elem\`{.var}
  > :::
  > EOF
  [ BulletList [ [ Plain [ Str "lemon" ] ] ]
  , BulletList [ [ Plain [ Str "apple" ] ] ]
  , BulletList [ [ Plain [ Str "banana" ] ] ]
  ]

$ pandoc -L logic-and-control.lua --to native <<EOF
> ---
> content: none
> ---
> ::: {.if-def content}
> The content ist `content`{.var}.
> :::
> ::: {.if-not-def content}
> Sorry, no content.
> :::
> EOF

  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > fruits:
  >   - lemon
  >   - apple
  >   - banana
  > ---
  > ::: {.for index=i var=elem in=meta.fruits}
  > 
  > Das \`i\`{.var}. Element ist \`elem\`{.var}.
  > 
  > :::
  > EOF
  [ Para
      [ Str "Das"
      , Space
      , Str "1"
      , Str "."
      , Space
      , Str "Element"
      , Space
      , Str "ist"
      , Space
      , Str "lemon"
      , Str "."
      ]
  , Para
      [ Str "Das"
      , Space
      , Str "2"
      , Str "."
      , Space
      , Str "Element"
      , Space
      , Str "ist"
      , Space
      , Str "apple"
      , Str "."
      ]
  , Para
      [ Str "Das"
      , Space
      , Str "3"
      , Str "."
      , Space
      , Str "Element"
      , Space
      , Str "ist"
      , Space
      , Str "banana"
      , Str "."
      ]
  ]

  $ pandoc -L logic-and-control.lua --to native <<EOF
  > ---
  > fruits:
  >   - lemon
  >   - apple
  >   - banana
  > ---
  > ::: {.for index=j .elem in=meta.fruits}
  > 
  > \`j\`{.var}. \`elem\`{.var}
  > 
  > :::
  > EOF
  [ Para [ Str "1" , Str "." , Space , Str "lemon" ]
  , Para [ Str "2" , Str "." , Space , Str "apple" ]
  , Para [ Str "3" , Str "." , Space , Str "banana" ]
  ]
