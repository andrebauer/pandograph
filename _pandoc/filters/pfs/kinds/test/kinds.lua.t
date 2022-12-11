Without a kind in the metadata, do nothing

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kinds:
  >   - doc_pdf:
  >       outpaths: c/test
  >       metadata:
  >         title: Hello
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  kinds:
  - doc_pdf:
      metadata:
        date: 10. Dez 2022
        title: Hello
      outpaths: c/test
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > outpath: c/test
  > kinds:
  >   - doc_pdf:
  >       outpaths: c/test
  >       metadata:
  >         title: Hello
  > ---
  > EOF
  ---
  kinds:
  - doc_pdf:
      metadata:
        title: Hello
      outpaths: c/test
  outpath: c/test
  ---
  
When the kind does not match, do nothing

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: beamer
  > outpath: c/test
  > kinds:
  >   - doc_pdf:
  >       outpaths: c/test
  >       metadata:
  >         title: Hello
  > ---
  > EOF
  ---
  kind: beamer
  kinds:
  - doc_pdf:
      metadata:
        title: Hello
      outpaths: c/test
  outpath: c/test
  ---
  
When the outpath does not match, do nothing

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: beamer
  > outpath: a/test
  > kinds:
  >   - doc_pdf:
  >       outpaths: c/test
  >       metadata:
  >         title: Hello
  > ---
  > EOF
  ---
  kind: beamer
  kinds:
  - doc_pdf:
      metadata:
        title: Hello
      outpaths: c/test
  outpath: a/test
  ---
  


When no outpaths are given, copy metadata

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > kinds:
  >   - doc_pdf:
  >       metadata:
  >         title: Hello
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  date: 10. Dez 2022
  kind: doc_pdf
  kinds:
  - doc_pdf:
      metadata:
        date: 10. Dez 2022
        title: Hello
  title: Hello
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: g/a
  > kinds:
  >   - doc_pdf:
  >       metadata:
  >         title: Hello
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  date: 10. Dez 2022
  kind: doc_pdf
  kinds:
  - doc_pdf:
      metadata:
        date: 10. Dez 2022
        title: Hello
  outpath: g/a
  title: Hello
  ---
  




Apply metadata for given kind and outpath

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: c/test
  > kinds:
  >   - doc_pdf:
  >       outpaths: c/test
  >       metadata:
  >         title: Hello
  > ---
  > EOF
  ---
  kind: doc_pdf
  kinds:
  - doc_pdf:
      metadata:
        title: Hello
      outpaths: c/test
  outpath: c/test
  title: Hello
  ---
  
  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: c/test
  > kinds:
  >   doc_pdf:
  >     outpaths: c/test
  >     metadata:
  >       title: Hello
  > ---
  > EOF
  ---
  kind: doc_pdf
  kinds:
    doc_pdf:
      metadata:
        title: Hello
      outpaths: c/test
  outpath: c/test
  title: Hello
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: c/test
  > kinds:
  >   doc_pdf:
  >     outpaths:
  >       - c/test
  >       - d/multi
  >     metadata:
  >       title: Hello
  > ---
  > EOF
  ---
  kind: doc_pdf
  kinds:
    doc_pdf:
      metadata:
        title: Hello
      outpaths:
      - c/test
      - d/multi
  outpath: c/test
  title: Hello
  ---
  


  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: c/test
  > kinds:
  >   doc_pdf:
  >     - outpaths: c/test
  >       metadata:
  >         title: Hello
  > ---
  > EOF
  ---
  kind: doc_pdf
  kinds:
    doc_pdf:
    - metadata:
        title: Hello
      outpaths: c/test
  outpath: c/test
  title: Hello
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: b/test
  > kinds:
  >   - beamer:
  >     - outpaths: b/test
  >       metadata:
  >         title: Beamer Slides
  >         date: 12. Dez 2022
  >   - doc_pdf:
  >     - outpaths: a/test
  >       metadata:
  >         title: Hello 1
  >     - outpaths: b/test
  >       metadata:
  >         title: Hello 2
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  date: 10. Dez 2022
  kind: doc_pdf
  kinds:
  - beamer:
    - metadata:
        date: 12. Dez 2022
        title: Beamer Slides
      outpaths: b/test
  - doc_pdf:
    - metadata:
        title: Hello 1
      outpaths: a/test
    - metadata:
        date: 10. Dez 2022
        title: Hello 2
      outpaths: b/test
  outpath: b/test
  title: Hello 2
  ---
  
  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: b/test
  > kinds:
  >   - beamer:
  >     - outpaths: b/test
  >       metadata:
  >         title: Beamer Slides
  >         date: 12. Dez 2022
  >   - doc_pdf:
  >     - outpaths:
  >         - a/test
  >         - c/test
  >       metadata:
  >         title: Hello 1
  >     - outpaths:
  >         - a/test
  >         - b/test
  >       metadata:
  >         title: Hello 2
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  date: 10. Dez 2022
  kind: doc_pdf
  kinds:
  - beamer:
    - metadata:
        date: 12. Dez 2022
        title: Beamer Slides
      outpaths: b/test
  - doc_pdf:
    - metadata:
        title: Hello 1
      outpaths:
      - a/test
      - c/test
    - metadata:
        date: 10. Dez 2022
        title: Hello 2
      outpaths:
      - a/test
      - b/test
  outpath: b/test
  title: Hello 2
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > outpath: c/test
  > kinds:
  >   - beamer:
  >     - outpaths: b/test
  >       metadata:
  >         title: Beamer Slides
  >         date: 12. Dez 2022
  >   - doc_pdf:
  >     - outpaths:
  >         - a/test
  >         - c/test
  >       metadata:
  >         title: Hello 1
  >     - metadata:
  >         title: Hello 2
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  kind: doc_pdf
  kinds:
  - beamer:
    - metadata:
        date: 12. Dez 2022
        title: Beamer Slides
      outpaths: b/test
  - doc_pdf:
    - metadata:
        title: Hello 1
      outpaths:
      - a/test
      - c/test
    - metadata:
        date: 10. Dez 2022
        title: Hello 2
  outpath: c/test
  title: Hello 1
  ---
  
  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: doc_pdf
  > kinds:
  >   - beamer:
  >     - outpaths: b/test
  >       metadata:
  >         title: Beamer Slides
  >         date: 12. Dez 2022
  >   - doc_pdf:
  >     - outpaths:
  >         - a/test
  >         - c/test
  >       metadata:
  >         title: Hello 1
  >     - metadata:
  >         title: Hello 2
  >         date: 10. Dez 2022
  > ---
  > EOF
  ---
  date: 10. Dez 2022
  kind: doc_pdf
  kinds:
  - beamer:
    - metadata:
        date: 12. Dez 2022
        title: Beamer Slides
      outpaths: b/test
  - doc_pdf:
    - metadata:
        title: Hello 1
      outpaths:
      - a/test
      - c/test
    - metadata:
        date: 10. Dez 2022
        title: Hello 2
  title: Hello 2
  ---
  

  $ pandoc -L kinds.lua -s -t markdown << EOF
  > ---
  > kind: svelte
  > outpath: multiple-3
  > title: Svelte Writer Test Page 2
  > outpaths:
  >   - content/multi
  >   - c/mul
  > kinds:
  >   doc_docx:
  >     - c/a
  >     - d/b
  >   doc_pdf: e/f/g
  >   svelte:
  >     - content/multiple-1
  >     - outpaths:
  >       - multiple-2
  >       - multiple-3
  >       metadata:
  >         title: Multiple Writer Test A
  >   beamer:
  >     outpaths:
  >       - multiple-2.1
  >       - multiple-3.1
  >     metadata:
  >       title: Multiple Writer Test B
  > ---
  > 
  > # Multiple 2
  > EOF
  ---
  kind: svelte
  kinds:
    beamer:
      metadata:
        title: Multiple Writer Test B
      outpaths:
      - multiple-2.1
      - multiple-3.1
    doc_docx:
    - c/a
    - d/b
    doc_pdf: e/f/g
    svelte:
    - content/multiple-1
    - metadata:
        title: Multiple Writer Test A
      outpaths:
      - multiple-2
      - multiple-3
  outpath: multiple-3
  outpaths:
  - content/multi
  - c/mul
  title: Multiple Writer Test A
  ---
  
  # Multiple 2


  $ pandoc -L kinds.lua -M kind=svelte -M outpath=multiple-3 -s -t markdown << EOF
  > ---
  > title: Svelte Writer Test Page 2
  > outpaths:
  >   - content/multi
  >   - c/mul
  > kinds:
  >   doc_docx:
  >     - c/a
  >     - d/b
  >   doc_pdf: e/f/g
  >   svelte:
  >     - content/multiple-1
  >     - outpaths:
  >       - multiple-2
  >       - multiple-3
  >       metadata:
  >         title: Multiple Writer Test A
  >   beamer:
  >     outpaths:
  >       - multiple-2.1
  >       - multiple-3.1
  >     metadata:
  >       title: Multiple Writer Test B
  > ---
  > 
  > # Multiple 2
  > EOF
  ---
  kind: svelte
  kinds:
    beamer:
      metadata:
        title: Multiple Writer Test B
      outpaths:
      - multiple-2.1
      - multiple-3.1
    doc_docx:
    - c/a
    - d/b
    doc_pdf: e/f/g
    svelte:
    - content/multiple-1
    - metadata:
        title: Multiple Writer Test A
      outpaths:
      - multiple-2
      - multiple-3
  outpath: multiple-3
  outpaths:
  - content/multi
  - c/mul
  title: Multiple Writer Test A
  ---
  
  # Multiple 2

  $ pandoc -L kinds.lua -M kind=svelte -M outpath=a/b/multiple-1-3 -s -t markdown << EOF
  > ---
  > title : Svelte Writer Test Page
  > outpaths:
  >   - content/multi-1
  >   - c/mul-1
  > kinds:
  >   - doc_docx:
  >     - c/a
  >     - d/b
  >   - doc_pdf
  >   - svelte:
  >     - content/multiple-1-1
  >     - outpaths:
  >       - multiple-1-2
  >       - a/b/multiple-1-3
  >       metadata:
  >         title: Multiple Writer Test A
  >   - beamer:
  >       outpaths:
  >       - multiple-1-2.1
  >       - multiple-1-3.1
  >       metadata:
  >         title: Multiple Writer Test B
  > ---
  > # Multiple
  > EOF
  ---
  kind: svelte
  kinds:
  - doc_docx:
    - c/a
    - d/b
  - doc_pdf
  - svelte:
    - content/multiple-1-1
    - metadata:
        title: Multiple Writer Test A
      outpaths:
      - multiple-1-2
      - a/b/multiple-1-3
  - beamer:
      metadata:
        title: Multiple Writer Test B
      outpaths:
      - multiple-1-2.1
      - multiple-1-3.1
  outpath: a/b/multiple-1-3
  outpaths:
  - content/multi-1
  - c/mul-1
  title: Multiple Writer Test A
  ---
  
  # Multiple
