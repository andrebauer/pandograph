  $ pandoc -L center.lua --to latex << EOF
  > ::: center
  > Centered Content
  > :::
  > EOF
  \begin{center}
  
  Centered Content
  
  \end{center}

  $ pandoc -L center.lua --to beamer << EOF
  > ::: center
  > Centered Content
  > :::
  > EOF
  \begin{frame}
  \begin{center}
  
  Centered Content
  
  \end{center}
  \end{frame}

  $ pandoc -L center.lua --to latex << EOF
  > ::: {.foo .center}
  > Centered Content
  > :::
  > EOF
  Centered Content


  $ pandoc -L center.lua --to html << EOF
  > ::: {.foo .center}
  > Centered Content
  > :::
  > EOF
  <div class="foo center">
  <p>Centered Content</p>
  </div>
