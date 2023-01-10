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
   
