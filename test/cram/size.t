Regocnize test size:

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: text-sm
  > Latex backend: text-sm to small
  > :::
  > EOF
  \begin{small}
  
  Latex backend: text-sm to small
  
  \end{small}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: large
  > Latex backend: large
  > :::
  > EOF
  \begin{large}
  
  Latex backend: large
  
  \end{large}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: {.large .small}
  > Latex backend: large
  > :::
  > EOF
  \begin{large}
  
  Latex backend: large
  
  \end{large}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: text-lg
  > Latex backend: text-lg to large
  > :::
  > EOF
  \begin{large}
  
  Latex backend: text-lg to large
  
  \end{large}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: text-9xl
  > Latex backend: Huge
  > :::
  > EOF
  \begin{Huge}
  
  Latex backend: Huge
  
  \end{Huge}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > ::: {.text-sm .Large}
  > Latex backend: Large
  > :::
  > EOF
  \begin{Large}
  
  Latex backend: Large
  
  \end{Large}

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > ::: text-sm
  > HTML5 backend: text-sm
  > :::
  > EOF
  <div class="text-sm">
  <p>HTML5 backend: text-sm</p>
  </div>

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > ::: large
  > HTML5 backend: large to text-lg
  > :::
  > EOF
  <div class="text-lg">
  <p>HTML5 backend: large to text-lg</p>
  </div>

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > ::: text-lg
  > HTML5 backend: text-lg
  > :::
  > EOF
  <div class="text-lg">
  <p>HTML5 backend: text-lg</p>
  </div>

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > ::: Huge
  > HTML5 backend: Huge to text-4xl
  > :::
  > EOF
  <div class="text-4xl">
  <p>HTML5 backend: Huge to text-4xl</p>
  </div>

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > ::: {.small .text-xl .text-sm .myClass}
  > HTML5 backend: text-xl
  > :::
  > EOF
  <div class="text-xl text-sm myClass">
  <p>HTML5 backend: text-xl</p>
  </div>
