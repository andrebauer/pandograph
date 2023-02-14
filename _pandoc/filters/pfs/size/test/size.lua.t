  $ pandoc -t latex -L size.lua << EOF
  > ::: {text=sm}
  > Small
  > :::
  > EOF
  \begin{small}
  
  Small
  
  \end{small}

  $ pandoc -t html5 -L size.lua << EOF
  > ::: {text=lg}
  > Large
  > :::
  > EOF
  <div class="text-lg" data-text="lg">
  <p>Large</p>
  </div>
