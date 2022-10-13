  $ pandoc --to native -L solution.lua <<EOF
  > ::: lsg
  > Test
  > :::
  > EOF
  [ Div
      ( "" , [] , [ ( "custom-style" , "Solution" ) ] )
      [ Div ( "" , [ "lsg" ] , [] ) [ Para [ Str "Test" ] ] ]
  ]

  $ pandoc --to native -L solution.lua <<EOF
  > :::: lsg
  > | Zeichen | Dateityp |
  > |---|------|
  > | d | Directory |
  > | l | Symbolische Links |
  > | b | Blockorientiertes Gerät |
  > | c | Zeichenorientiertes Gerät |
  > | p | Named Pipes |
  > | s | Sockets |
  > ::::
  > EOF
  [ Table
      ( "" , [] , [ ( "custom-style" , "Solution" ) ] )
      (Caption Nothing [])
      [ ( AlignDefault , ColWidthDefault )
      , ( AlignDefault , ColWidthDefault )
      ]
      (TableHead
         ( "" , [] , [] )
         [ Row
             ( "" , [] , [] )
             [ Cell
                 ( "" , [] , [] )
                 AlignDefault
                 (RowSpan 1)
                 (ColSpan 1)
                 [ Plain [ Str "Zeichen" ] ]
             , Cell
                 ( "" , [] , [] )
                 AlignDefault
                 (RowSpan 1)
                 (ColSpan 1)
                 [ Plain [ Str "Dateityp" ] ]
             ]
         ])
      [ TableBody
          ( "" , [] , [] )
          (RowHeadColumns 0)
          []
          [ Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "d" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "Directory" ] ]
              ]
          , Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "l" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "Symbolische" , Space , Str "Links" ] ]
              ]
          , Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "b" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain
                      [ Str "Blockorientiertes" , Space , Str "Ger\228t" ]
                  ]
              ]
          , Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "c" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain
                      [ Str "Zeichenorientiertes"
                      , Space
                      , Str "Ger\228t"
                      ]
                  ]
              ]
          , Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "p" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "Named" , Space , Str "Pipes" ] ]
              ]
          , Row
              ( "" , [] , [] )
              [ Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "s" ] ]
              , Cell
                  ( "" , [] , [] )
                  AlignDefault
                  (RowSpan 1)
                  (ColSpan 1)
                  [ Plain [ Str "Sockets" ] ]
              ]
          ]
      ]
      (TableFoot ( "" , [] , [] ) [])
  ]
