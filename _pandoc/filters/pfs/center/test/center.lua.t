  $ pandoc -L center.lua --to latex << EOF
  > ::: center
  > Centered Content
  > :::
  > EOF
  \begin{center}
  
  Centered Content
  
  \end{center}
