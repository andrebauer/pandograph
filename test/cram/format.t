Regocnize latex format:

  $ pandoc --filter Text/Pandoc/Filter/format.hs --to beamer <<EOF
  > Hello
  > EOF
  \begin{frame}
  beamer
  \end{frame}

Regocnize beamer format:

  $ pandoc --filter Text/Pandoc/Filter/format.hs --to latex <<EOF
  > Hello
  > EOF
  latex

Regocnize html5 format

  $ pandoc --filter Text/Pandoc/Filter/format.hs --to html5 <<EOF
  > Hello
  > EOF
  <p>html5</p>

Regocnize html format

  $ pandoc --filter Text/Pandoc/Filter/format.hs --to html <<EOF
  > Hello
  > EOF
  <p>html</p>

Regocnize native format

  $ pandoc --filter Text/Pandoc/Filter/format.hs --to native <<EOF
  > Hello
  > EOF
  [Para [Str "native"]]

Regocnize default format

  $ pandoc --filter Text/Pandoc/Filter/format.hs <<EOF
  > Hello
  > EOF
  <p>html</p>
