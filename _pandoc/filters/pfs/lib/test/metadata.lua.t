  $ pandoc -L metadata-test.lua --to markdown << EOF
  > ---
  > test:
  >   a: 'H'
  >   a1: false
  >   a2: 42
  >   n:
  >     m:
  >       o: 2
  >   a3: true
  >   list:
  >    - a
  >    - c
  >    - f
  >   nested:
  >     c: 24
  >     h: 13
  >     join: false
  > ---
  > EOF
  
    a: H
    a1: false 
    a2: 42
    a3: true 
    b: d 
    cl: 
      1: hallo 
      2: 
        name: John 
    list: 
      1: a
      2: c
      3: f
    n: 
      m: 
        o: 2
    name: test 
    nested: 
      __sealed__: 
        1: h 
      c: 24
      d: Hallo *Welt* 
      e: false 
      f: 
        1: 1 
        2: 2 
        3: 3 
      g: 
        1: a 
        2: b 
        3: c 
      h: 12 
      join: false 
   

  $ pandoc -L metadata-test.lua --to markdown << EOF
  > ---
  > test:
  >   cl:
  >     - 'Hi'
  >     - name: 'Mia'
  > ---
  > EOF
  
    a: G 
    a1: true 
    a2: 41 
    a3: false 
    b: d 
    cl: 
      1: Hi
      2: 
        name: Mia
    list: 
      1: a 
      2: b 
      3: h 
      4: f 
      5: g 
    n: 
      m: 
        o: 1 
    name: test 
    nested: 
      __sealed__: 
        1: h 
      c: 12 
      d: Hallo *Welt* 
      e: false 
      f: 
        1: 1 
        2: 2 
        3: 3 
      g: 
        1: a 
        2: b 
        3: c 
      h: 12 
      join: true 
   
  $ pandoc -L metadata-test.lua --to markdown << EOF
  > ---
  > test:
  >   cl:
  >     2:
  >       name: 'Mia'
  > ---
  > EOF
  
    a: G 
    a1: true 
    a2: 41 
    a3: false 
    b: d 
    cl: 
      1: hallo 
      2: 
        name: John 
    list: 
      1: a 
      2: b 
      3: h 
      4: f 
      5: g 
    n: 
      m: 
        o: 1 
    name: test 
    nested: 
      __sealed__: 
        1: h 
      c: 12 
      d: Hallo *Welt* 
      e: false 
      f: 
        1: 1 
        2: 2 
        3: 3 
      g: 
        1: a 
        2: b 
        3: c 
      h: 12 
      join: true 
   

  $ pandoc -L metadata-test.lua --to markdown << EOF
  > ---
  > test:
  >   cl:
  >     - name: 'Mia'
  > ---
  > EOF
  [lib/log.lua] Mismatch between options and metadata: 
  [lib/log.lua] Options: 
  hallo 
   [lib/log.lua] 
  Metadata: 
  
    name: Mia
   Error running filter metadata-test.lua:
  ./lib/metadata.lua:62: bad argument #1 to 'for iterator' (table expected, got string)
  stack traceback:
  	./lib/metadata.lua:62: in function 'parse_meta'
  	./lib/metadata.lua:49: in function 'parse_meta'
  	./lib/metadata.lua:68: in function 'parse_meta'
  	metadata-test.lua:27: in function 'Meta'
  [83]
