Custom readers can be built such that their behavior is controllable through
format extensions, such as smart, citations, or hard-line-breaks. Supported
extensions are those that are present as a key in the global Extensions table.
Fields of extensions that are enabled default have the value true or enable,
while those that are supported but disabled have value false or disable.

Example: A writer with the following global table supports the extensions smart,
citations, and foobar, with smart enabled and the other two disabled by default:

```lua
Extensions = {
 smart = 'enable',
 citations = 'disable',
 foobar = true
}
```

  $ pandoc -t latex -L fontsize.lua << EOF
  > ::: {text=sm}
  > Small
  > :::
  > EOF
  \begin{small}
  
  Small
  
  \end{small}

  $ pandoc -t latex -L fontsize.lua << EOF
  > ---
  > fontsize.lua:
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

  $ pandoc -t latex -L fontsize.lua << EOF
  > ---
  > fontsize.lua:
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

  $ pandoc -t latex -L fontsize.lua << EOF
  > ---
  > fontsize.lua:
  >   classes: true
  > ---
  > ::: lg
  > Large
  > :::
  > EOF
  \begin{large}
  
  Large
  
  \end{large}


  $ pandoc -t html5 -L fontsize.lua << EOF
  > ::: {text=lg}
  > Large
  > :::
  > EOF
  <div class="text-lg" data-text="lg">
  <p>Large</p>
  </div>


  $ pandoc -t latex -L fontsize.lua << EOF
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



  $ pandoc -t html5 -L fontsize.lua << EOF
  > ---
  > fontsize.lua:
  >   html-prefix: font-
  > ---
  > ::: {text=lg}
  > Large
  > :::
  > EOF
  <div class="font-lg" data-text="lg">
  <p>Large</p>
  </div>
