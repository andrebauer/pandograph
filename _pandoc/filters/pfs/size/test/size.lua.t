  $ pandoc -t latex -L size.lua << EOF
  > ::: {text=sm}
  > Small
  > :::
  > EOF
  \begin{small}
  
  Small
  
  \end{small}

  $ pandoc -t latex -L size.lua << EOF
  > ---
  > fontsize:
  >   classes: true
  >   attribute: false
  > ---
  > ::: {text=sm}
  > Small
  > :::
  > ::: 2xl
  > LARGE
  > :::
  > EOF
  Small
  
  \begin{LARGE}
  
  LARGE
  
  \end{LARGE}

  $ pandoc -t latex -L size.lua << EOF
  > ---
  > fontsize:
  >   classes: false
  >   attribute: fontsize
  > ---
  > ::: {fontsize=xs}
  > Footnotesize
  > :::
  > ::: 4xl
  > Huge
  > :::
  > EOF
  \begin{footnotesize}
  
  Footnotesize
  
  \end{footnotesize}
  
  Huge

  $ pandoc -t latex -L size.lua << EOF
  > ---
  > fontsize:
  >   classes: true
  > ---
  > ::: lg
  > Large
  > :::
  > EOF
  \begin{large}
  
  Large
  
  \end{large}


  $ pandoc -t html5 -L size.lua << EOF
  > ::: {text=lg}
  > Large
  > :::
  > EOF
  <div class="text-lg" data-text="lg">
  <p>Large</p>
  </div>


  $ pandoc -t latex -L size.lua << EOF
  > ::: other
  > Other
  > :::
  > 
  > ::: {text=sm}
  > Small
  > :::
  > EOF
  Other
  
  \begin{small}
  
  Small
  
  \end{small}
