
  $ pandoc -L task.lua -t native <<EOF
  > ::: task
  > Hello
  > :::
  > EOF
  [ Div
      ( "" , [ "task" ] , [] )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe" , Space , Str "1" ]
      , Para [ Str "Hello" ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="More of Lua"}
  > Hello
  > :::
  > EOF
  [ Div
      ( "" , [ "task" ] , [ ( "title" , "More of Lua" ) ] )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1:"
          , Space
          , Str "More"
          , Space
          , Str "of"
          , Space
          , Str "Lua"
          ]
      , Para [ Str "Hello" ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="The Return of Lua"}
  > Hello
  > :::
  > ::: task
  > World
  > :::
  > EOF
  [ Div
      ( "" , [ "task" ] , [ ( "title" , "The Return of Lua" ) ] )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1:"
          , Space
          , Str "The"
          , Space
          , Str "Return"
          , Space
          , Str "of"
          , Space
          , Str "Lua"
          ]
      , Para [ Str "Hello" ]
      ]
  , Div
      ( "" , [ "task" ] , [] )
      [ Header
          3
          ( "aufgabe-2" , [] , [] )
          [ Str "Aufgabe" , Space , Str "2" ]
      , Para [ Str "World" ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="The Return of [Lua](https://www.lua.org/)"}
  > Hello
  > 
  > ::: subtask
  > Subtask a
  > :::
  > ::: subtask
  > Subtask b
  > :::
  > :::
  > EOF
  [ Div
      ( ""
      , [ "task" ]
      , [ ( "title"
          , "The Return of [Lua](https://www.lua.org/)"
          )
        ]
      )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1:"
          , Space
          , Str "The"
          , Space
          , Str "Return"
          , Space
          , Str "of"
          , Space
          , Link
              ( "" , [] , [] )
              [ Str "Lua" ]
              ( "https://www.lua.org/" , "" )
          ]
      , Para [ Str "Hello" ]
      , OrderedList
          ( 1 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "a" ] ]
            ]
          ]
      , OrderedList
          ( 2 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "b" ] ]
            ]
          ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ---
  > exercise-heading-level: 2
  > ---
  > ::: {.task title="Next level of Lua"}
  > This is not a task
  > :::
  > EOF
  [ Div
      ( "" , [ "task" ] , [ ( "title" , "Next level of Lua" ) ] )
      [ Header
          2
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1:"
          , Space
          , Str "Next"
          , Space
          , Str "level"
          , Space
          , Str "of"
          , Space
          , Str "Lua"
          ]
      , Para
          [ Str "This"
          , Space
          , Str "is"
          , Space
          , Str "not"
          , Space
          , Str "a"
          , Space
          , Str "task"
          ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="The _First_"}
  > fst
  > 
  > ::: subtask
  > Subtask a
  > :::
  > ::: subtask
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The **Second**"}
  > snd
  > 
  > ::: subtask
  > Subtask a
  > :::
  > :::
  > EOF
  [ Div
      ( "" , [ "task" ] , [ ( "title" , "The _First_" ) ] )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1:"
          , Space
          , Str "The"
          , Space
          , Emph [ Str "First" ]
          ]
      , Para [ Str "fst" ]
      , OrderedList
          ( 1 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "a" ] ]
            ]
          ]
      , OrderedList
          ( 2 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "b" ] ]
            ]
          ]
      ]
  , Div
      ( "" , [ "task" ] , [ ( "title" , "The **Second**" ) ] )
      [ Header
          3
          ( "aufgabe-2" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "2:"
          , Space
          , Str "The"
          , Space
          , Strong [ Str "Second" ]
          ]
      , Para [ Str "snd" ]
      , OrderedList
          ( 1 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "a" ] ]
            ]
          ]
      ]
  ]

  $ pandoc -L task.lua -t plain <<EOF
  > ::: {.task title="The First" points=auto}
  > fst
  > 
  > ::: {.subtask points=2}
  > Subtask a
  > :::
  > ::: {.subtask points=5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d
  > :::
  > :::
  > EOF
  [task.lua] points=auto is deprecated, use points=sum instead 
  Aufgabe 1 (7 P.): The First
  
  fst
  
  a)  (2 P.) Subtask a
  
  b)  (5 P.) Subtask b
  
  Aufgabe 2: The Second
  
  snd
  
  iv) Subtask d


  $ pandoc -L task.lua -t plain <<EOF
  > ::: {.task title="The First" points=auto}
  > fst
  > 
  > ::: {.subtask points=2}
  > Subtask a
  > :::
  > ::: {.subtask points=5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d [1]{.p}
  > :::
  > :::
  > EOF
  [task.lua] points=auto is deprecated, use points=sum instead 
  Aufgabe 1 (7 P.): The First
  
  fst
  
  a)  (2 P.) Subtask a
  
  b)  (5 P.) Subtask b
  
  Aufgabe 2: The Second
  
  snd
  
  iv) Subtask d 1 P.

  $ pandoc -L task.lua -t plain --standalone <<EOF
  > ---
  > task:
  >   points: false
  > ---
  > ::: {.task title="The First" points=sum}
  > fst
  > 
  > ::: {.subtask points=2}
  > Subtask a
  > :::
  > ::: {.subtask points=5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d [1]{.p}
  > :::
  > :::
  > EOF
  
  
  Aufgabe 1: The First
  
  fst
  
  a)  Subtask a
  
  b)  Subtask b
  
  Aufgabe 2: The Second
  
  snd
  
  iv) Subtask d


  $ pandoc -L task.lua -t plain <<EOF
  > ::: {.task title="The First" points=sum}
  > fst
  > 
  > ::: {.subtask points=2.5}
  > Subtask a
  > :::
  > ::: {.subtask points=5.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d
  > :::
  > :::
  > EOF
  Aufgabe 1 (8 P.): The First
  
  fst
  
  a)  (2.5 P.) Subtask a
  
  b)  (5.5 P.) Subtask b
  
  Aufgabe 2: The Second
  
  snd
  
  iv) Subtask d


  $ pandoc -L task.lua -t plain <<EOF
  > ---
  > lang: de
  > ---
  > ::: {.task title="The First" points=sum}
  > fst
  > 
  > ::: {.subtask points=2.75}
  > Subtask a
  > :::
  > ::: {.subtask points=5.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d
  > :::
  > :::
  > EOF
  Aufgabe 1 (8,25 P.): The First
  
  fst
  
  a)  (2,75 P.) Subtask a
  
  b)  (5,5 P.) Subtask b
  
  Aufgabe 2: The Second
  
  snd
  
  iv) Subtask d


  $ pandoc -L task.lua -t latex <<EOF
  > ---
  > lang: de
  > ---
  > ::: {.task title="The First" points=sum}
  > fst
  > 
  > ::: {.subtask points=2.75}
  > Subtask a
  > :::
  > ::: {.subtask points=5.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d
  > :::
  > :::
  > EOF
  \hypertarget{aufgabe-1}{%
  \subsubsection{Aufgabe 1: The First}\label{aufgabe-1}}
  
  \marginpar{\sf\vspace*{-0.8em} {~~ 8,25~P.}}
  
  fst
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \item
    Subtask\marginpar{\small\sf {~~/ 2,75}} a
  \end{enumerate}
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \setcounter{enumi}{1}
  \item
    Subtask\marginpar{\small\sf {~~/ 5,5}} b
  \end{enumerate}
  
  \hypertarget{aufgabe-2}{%
  \subsubsection{Aufgabe 2: The Second}\label{aufgabe-2}}
  
  snd
  
  \begin{enumerate}
  \def\labelenumi{\roman{enumi})}
  \setcounter{enumi}{3}
  \item
    Subtask d
  \end{enumerate}

  $ pandoc -L task.lua -t latex <<EOF
  > ::: {.task title="The First" points=sum}
  > fst
  > 
  > ::: {.subtask points=2.5}
  > Subtask a
  > :::
  > ::: {.subtask points=5.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second"}
  > snd
  > 
  > ::: {.subtask setcounter=4 style=LowerRoman}
  > Subtask d
  > :::
  > :::
  > EOF
  \hypertarget{aufgabe-1}{%
  \subsubsection{Aufgabe 1: The First}\label{aufgabe-1}}
  
  \marginpar{\sf\vspace*{-0.8em} {~~ 8~P.}}
  
  fst
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \item
    Subtask\marginpar{\small\sf {~~/ 2.5}} a
  \end{enumerate}
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \setcounter{enumi}{1}
  \item
    Subtask\marginpar{\small\sf {~~/ 5.5}} b
  \end{enumerate}
  
  \hypertarget{aufgabe-2}{%
  \subsubsection{Aufgabe 2: The Second}\label{aufgabe-2}}
  
  snd
  
  \begin{enumerate}
  \def\labelenumi{\roman{enumi})}
  \setcounter{enumi}{3}
  \item
    Subtask d
  \end{enumerate}


  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="The First" points=auto}
  > fst
  > 
  > ::: {.subtask points=2}
  > Subtask a
  > :::
  > ::: {.subtask points=4.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task title="The Second" level=5}
  > snd
  > 
  > ::: subtask
  > Subtask a
  > :::
  > :::
  > EOF
  [task.lua] points=auto is deprecated, use points=sum instead 
  [ Div
      ( ""
      , [ "task" ]
      , [ ( "title" , "The First" ) , ( "points" , "auto" ) ]
      )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "1"
          , Space
          , Str "(6.5"
          , Space
          , Str "P.):"
          , Space
          , Str "The"
          , Space
          , Str "First"
          ]
      , Para [ Str "fst" ]
      , OrderedList
          ( 1 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [ ( "points" , "2" ) ] )
                [ Para
                    [ Emph [ Str "(2" , Space , Str "P.)" , Space ]
                    , Str "Subtask"
                    , Space
                    , Str "a"
                    ]
                ]
            ]
          ]
      , OrderedList
          ( 2 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [ ( "points" , "4.5" ) ] )
                [ Para
                    [ Emph [ Str "(4.5" , Space , Str "P.)" , Space ]
                    , Str "Subtask"
                    , Space
                    , Str "b"
                    ]
                ]
            ]
          ]
      ]
  , Div
      ( ""
      , [ "task" ]
      , [ ( "title" , "The Second" ) , ( "level" , "5" ) ]
      )
      [ Header
          5
          ( "aufgabe-2" , [] , [] )
          [ Str "Aufgabe"
          , Space
          , Str "2:"
          , Space
          , Str "The"
          , Space
          , Str "Second"
          ]
      , Para [ Str "snd" ]
      , OrderedList
          ( 1 , LowerAlpha , OneParen )
          [ [ Div
                ( "" , [ "subtask" ] , [] )
                [ Para [ Str "Subtask" , Space , Str "a" ] ]
            ]
          ]
      ]
  ]

  $ pandoc -L task.lua -t native <<EOF
  > ::: {.task title="The Return of Lua" .nonnumbered}
  > Hello
  > :::
  > ::: task
  > Numbered
  > :::
  > ::: {.task .nonnumbered}
  > World
  > :::
  > EOF
  [ Div
      ( ""
      , [ "task" , "nonnumbered" ]
      , [ ( "title" , "The Return of Lua" ) ]
      )
      [ Header
          3
          ( "aufgabe-nn-1" , [] , [] )
          [ Str "Aufgabe:"
          , Space
          , Str "The"
          , Space
          , Str "Return"
          , Space
          , Str "of"
          , Space
          , Str "Lua"
          ]
      , Para [ Str "Hello" ]
      ]
  , Div
      ( "" , [ "task" ] , [] )
      [ Header
          3
          ( "aufgabe-1" , [] , [] )
          [ Str "Aufgabe" , Space , Str "1" ]
      , Para [ Str "Numbered" ]
      ]
  , Div
      ( "" , [ "task" , "nonnumbered" ] , [] )
      [ Header 3 ( "aufgabe-nn-2" , [] , [] ) [ Str "Aufgabe" ]
      , Para [ Str "World" ]
      ]
  ]


  $ pandoc -L task.lua -t latex <<EOF
  > ::: {.task title="The First" points=auto level=1}
  > fst
  > 
  > ::: {.subtask points=2}
  > Subtask a
  > :::
  > ::: {.subtask points=4.5}
  > Subtask b
  > :::
  > :::
  > ::: {.task .nonnumbered}
  > Hello
  > :::
  > ::: {.task title="The Third" setcounter=3}
  > trd
  > 
  > ::: {.subtask setcounter=5}
  > Subtask e
  > :::
  > :::
  > ::: {.task .nonnumbered}
  > World
  > :::
  > EOF
  [task.lua] points=auto is deprecated, use points=sum instead 
  \hypertarget{aufgabe-1}{%
  \section{Aufgabe 1: The First}\label{aufgabe-1}}
  
  \marginpar{\sf\vspace*{-0.8em} {~~ 6.5~P.}}
  
  fst
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \item
    Subtask\marginpar{\small\sf {~~/ 2}} a
  \end{enumerate}
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \setcounter{enumi}{1}
  \item
    Subtask\marginpar{\small\sf {~~/ 4.5}} b
  \end{enumerate}
  
  \hypertarget{aufgabe-nn-1}{%
  \subsubsection{Aufgabe}\label{aufgabe-nn-1}}
  
  Hello
  
  \hypertarget{aufgabe-3}{%
  \subsubsection{Aufgabe 3: The Third}\label{aufgabe-3}}
  
  trd
  
  \begin{enumerate}
  \def\labelenumi{\alph{enumi})}
  \setcounter{enumi}{4}
  \item
    Subtask e
  \end{enumerate}
  
  \hypertarget{aufgabe-nn-2}{%
  \subsubsection{Aufgabe}\label{aufgabe-nn-2}}
  
  World

  $ pandoc -L task.lua -t plain <<EOF
  > Test [1]{.p}
  > EOF
  Test 1 P.
