  $ pandoc --to html -L diagram.lua --extract-media=media <<EOF
  > \`\`\` {.ditaa .svg}
  > +--------+   +-------+    +-------+
  > |        | --+ ditaa +--> |       |
  > |  Text  |   +-------+    |diagram|
  > |Document|   |!magic!|    |       |
  > |     {d}|   |       |    |       |
  > +---+----+   +-------+    +-------+
  >     :                         ^
  >     |       Lots of work      |
  >     +-------------------------+
  > \`\`\`
  > EOF
  ditaa 32546ef00cbbef32.ditaa 32546ef00cbbef32.svg      --svg      > /dev/null
  <p><img src="media/32546ef00cbbef32.svg" /></p>

  $ cat media/8a8cfe3a8fa2e0ba927d3cbf634a0ebb7d7493d1.svg
  cat: media/8a8cfe3a8fa2e0ba927d3cbf634a0ebb7d7493d1.svg: No such file or directory
  [1]

  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media <<EOF | grep --invert -E "^Done in .*sec"
  > \`\`\` ditaa
  > +--------+
  > | Hello  |
  > +--------+
  > \`\`\`
  > EOF
  ditaa b14e2edd0a6e0c1b.ditaa b14e2edd0a6e0c1b.svg           
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  Reading file: b14e2edd0a6e0c1b.ditaa
  Rendering to file: b14e2edd0a6e0c1b.svg
  <p><img src="media/b14e2edd0a6e0c1b.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
  > ---
  > ditaa:
  >   no-separation: true
  > ---
  > \`\`\` {.ditaa .transparent .debug}
  > +--------+
  > | Hello  |
  > +--------+
  > \`\`\`
  > EOF
  ditaa 543a99a6c4a34aa2.ditaa 543a99a6c4a34aa2.svg  --debug --no-separation   --svg --transparent    
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  no-separation
  svg
  transparent
  Reading file: 543a99a6c4a34aa2.ditaa
  Using grid:
      01234567890123456789
   0 (              )
   1 (              )
   2 (  +--------+  )
   3 (  | Hello  |  )
   4 (  +--------+  )
   5 (              )
   6 (              )
  Rendering to file: 543a99a6c4a34aa2.svg
  <p><img src="media/543a99a6c4a34aa2.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
  > ---
  > ditaa:
  >   debug: true
  >   no-separation: true
  >   fixed-slope: true
  >   background: FF0044
  > ---
  > \`\`\` {.ditaa .round-corners .no-shadows scale=1.4 tabs=4 }
  > +--------+
  >   Hello  | World
  >          +--------+
  > \`\`\`
  > EOF
  ditaa 38ae108329dee4d7.ditaa 38ae108329dee4d7.svg  --debug --no-separation --round-corners --no-shadows --svg  --fixed-slope --background FF0044 --scale 1.4 --tabs 4
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  no-separation
  round-corners
  no-shadows
  svg
  fixed-slope
  background = FF0044
  scale = 1.4
  tabs = 4
  Reading file: 38ae108329dee4d7.ditaa
  Using grid:
      012345678901234567890123456789
   0 (                       )
   1 (                       )
   2 (  +--------+           )
   3 (    Hello  | World     )
   4 (           +--------+  )
   5 (                       )
   6 (                       )
  Rendering to file: 38ae108329dee4d7.svg
  <p><img src="media/38ae108329dee4d7.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
  > ---
  > ditaa:
  >   debug: true
  >   no-separation: true
  >   fixed-slope: true
  >   background: FF0044
  >   no-shadows: true
  >   scale: 2.5
  >   tabs: 8
  > ---
  > \`\`\` {.ditaa .round-corners .no-shadows no-separation=false scale=1.4 tabs=4 }
  >          +-------+
  >   Pandoc | Ditaa
  > +--------+
  > \`\`\`
  > EOF
  ditaa da9f5f98fe6324f3.ditaa da9f5f98fe6324f3.svg  --debug  --round-corners --no-shadows --svg  --fixed-slope --background FF0044 --scale 1.4 --tabs 4
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  round-corners
  no-shadows
  svg
  fixed-slope
  background = FF0044
  scale = 1.4
  tabs = 4
  Reading file: da9f5f98fe6324f3.ditaa
  Using grid:
      012345678901234567890123456789
   0 (                      )
   1 (                      )
   2 (           +-------+  )
   3 (    Pandoc | Ditaa    )
   4 (  +--------+          )
   5 (                      )
   6 (                      )
  Rendering to file: da9f5f98fe6324f3.svg
  <p><img src="media/da9f5f98fe6324f3.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
  > ---
  > ditaa:
  >   debug: true
  > ---
  > \`\`\` {.ditaa round-corners=true no-shadows=true filename=File-Name}
  > +------+------+
  > | File | Name |
  > +------+------+
  > \`\`\`
  > EOF
  ditaa 576b8506c5576ed8.ditaa 576b8506c5576ed8.svg  --debug  --round-corners --no-shadows --svg     
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  round-corners
  no-shadows
  svg
  Reading file: 576b8506c5576ed8.ditaa
  Using grid:
      01234567890123456789
   0 (                   )
   1 (                   )
   2 (  +------+------+  )
   3 (  | File | Name |  )
   4 (  +------+------+  )
   5 (                   )
   6 (                   )
  Rendering to file: 576b8506c5576ed8.svg
  <p><img src="media/File-Name-576b8506c5576ed8.svg" /></p>

  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L diagram.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
  > ---
  > ditaa:
  >   debug: true
  > ---
  > \`\`\`
  > +-------------------------------------------+
  > | +-----------+ +-----------+ +-----------+ |
  > | | Anwendung | | Anwendung | | Anwendung | |
  > | +-----------+ +-----------+ +-----------+ |
  > | | Gast–BS   | | Gast–BS   | | Gast–BS   | |
  > | | (Windows) | | (Linux)   | | (Solaris) | |
  > | +-----------+ +-----------+ +-----------+ |
  > | | Virtuelle | | Virtuelle | | Virtuelle | |
  > | | Maschine  | | Maschine  | | Maschine  | |
  > | +-----------+ +-----------+ +-----------+ |
  > +-------------------------------------------+
  > | +---------------------------------------+ |
  > | |       Virtualiserungsoftware          | |
  > | +---------------------------------------+ |
  > | |         Host–Betriebssystem           | |
  > | +---------------------------------------+ |
  > | |         Physische Maschine            | |
  > | +---------------------------------------+ |
  > +-------------------------------------------+
  > \`\`\`
  > EOF
  <pre><code>+-------------------------------------------+
  | +-----------+ +-----------+ +-----------+ |
  | | Anwendung | | Anwendung | | Anwendung | |
  | +-----------+ +-----------+ +-----------+ |
  | | Gast–BS   | | Gast–BS   | | Gast–BS   | |
  | | (Windows) | | (Linux)   | | (Solaris) | |
  | +-----------+ +-----------+ +-----------+ |
  | | Virtuelle | | Virtuelle | | Virtuelle | |
  | | Maschine  | | Maschine  | | Maschine  | |
  | +-----------+ +-----------+ +-----------+ |
  +-------------------------------------------+
  | +---------------------------------------+ |
  | |       Virtualiserungsoftware          | |
  | +---------------------------------------+ |
  | |         Host–Betriebssystem           | |
  | +---------------------------------------+ |
  | |         Physische Maschine            | |
  | +---------------------------------------+ |
  +-------------------------------------------+</code></pre>


