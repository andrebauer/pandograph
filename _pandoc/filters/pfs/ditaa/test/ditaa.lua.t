  $ pandoc --to html -L ditaa.lua --extract-media=media <<EOF
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
  ditaa _ditaa/28c12b6e72de739c47e2fcc1a8035bc139be0167.ditaa _ditaa/28c12b6e72de739c47e2fcc1a8035bc139be0167.svg      --svg   --overwrite     > /dev/null
  <p><img
  src="media/_ditaa/28c12b6e72de739c47e2fcc1a8035bc139be0167.svg" /></p>

  $ cat media/8a8cfe3a8fa2e0ba927d3cbf634a0ebb7d7493d1.svg
  cat: media/8a8cfe3a8fa2e0ba927d3cbf634a0ebb7d7493d1.svg: No such file or directory
  [1]

  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media <<EOF
  > \`\`\` ditaa
  > +--------+
  > | Hello  |
  > +--------+
  > \`\`\`
  > EOF
  ditaa _ditaa/183256d6ed5b132f81df07f17ef773619dc0cd30.ditaa _ditaa/183256d6ed5b132f81df07f17ef773619dc0cd30.svg      --svg   --overwrite    
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  svg
  overwrite
  Reading file: _ditaa/183256d6ed5b132f81df07f17ef773619dc0cd30.ditaa
  Rendering to file: _ditaa/183256d6ed5b132f81df07f17ef773619dc0cd30.svg
  Done in 1sec
  <p><img
  src="media/_ditaa/183256d6ed5b132f81df07f17ef773619dc0cd30.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
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
  ditaa _ditaa/865b28699ef6585666664c183f766f4df0306f7a.ditaa _ditaa/865b28699ef6585666664c183f766f4df0306f7a.svg  --debug --no-separation   --svg --transparent  --overwrite    
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  no-separation
  svg
  transparent
  overwrite
  Reading file: _ditaa/865b28699ef6585666664c183f766f4df0306f7a.ditaa
  Using grid:
      01234567890123456789
   0 (              )
   1 (              )
   2 (  +--------+  )
   3 (  | Hello  |  )
   4 (  +--------+  )
   5 (              )
   6 (              )
  Rendering to file: _ditaa/865b28699ef6585666664c183f766f4df0306f7a.svg
  <p><img
  src="media/_ditaa/865b28699ef6585666664c183f766f4df0306f7a.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
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
  ditaa _ditaa/aa3cba4bb3e020a028e0a892a4d4cd24632f8d6a.ditaa _ditaa/aa3cba4bb3e020a028e0a892a4d4cd24632f8d6a.svg  --debug --no-separation --round-corners --no-shadows --svg  --fixed-slope --overwrite --background FF0044 --scale 1.4 --tabs 4 
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  no-separation
  round-corners
  no-shadows
  svg
  fixed-slope
  overwrite
  background = FF0044
  scale = 1.4
  tabs = 4
  Reading file: _ditaa/aa3cba4bb3e020a028e0a892a4d4cd24632f8d6a.ditaa
  Using grid:
      012345678901234567890123456789
   0 (                       )
   1 (                       )
   2 (  +--------+           )
   3 (    Hello  | World     )
   4 (           +--------+  )
   5 (                       )
   6 (                       )
  Rendering to file: _ditaa/aa3cba4bb3e020a028e0a892a4d4cd24632f8d6a.svg
  <p><img
  src="media/_ditaa/aa3cba4bb3e020a028e0a892a4d4cd24632f8d6a.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
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
  ditaa _ditaa/b1a76957d6b38b1245672527af5bc7fe74e9bc70.ditaa _ditaa/b1a76957d6b38b1245672527af5bc7fe74e9bc70.svg  --debug  --round-corners --no-shadows --svg  --fixed-slope --overwrite --background FF0044 --scale 1.4 --tabs 4 
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  round-corners
  no-shadows
  svg
  fixed-slope
  overwrite
  background = FF0044
  scale = 1.4
  tabs = 4
  Reading file: _ditaa/b1a76957d6b38b1245672527af5bc7fe74e9bc70.ditaa
  Using grid:
      012345678901234567890123456789
   0 (                      )
   1 (                      )
   2 (           +-------+  )
   3 (    Pandoc | Ditaa    )
   4 (  +--------+          )
   5 (                      )
   6 (                      )
  Rendering to file: _ditaa/b1a76957d6b38b1245672527af5bc7fe74e9bc70.svg
  <p><img
  src="media/_ditaa/b1a76957d6b38b1245672527af5bc7fe74e9bc70.svg" /></p>


  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
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
  ditaa _ditaa/9cb54df019c00816ed675e161b3c02b1dd2bc686.ditaa _ditaa/9cb54df019c00816ed675e161b3c02b1dd2bc686.svg  --debug  --round-corners --no-shadows --svg   --overwrite    
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  round-corners
  no-shadows
  svg
  overwrite
  Reading file: _ditaa/9cb54df019c00816ed675e161b3c02b1dd2bc686.ditaa
  Using grid:
      01234567890123456789
   0 (                   )
   1 (                   )
   2 (  +------+------+  )
   3 (  | File | Name |  )
   4 (  +------+------+  )
   5 (                   )
   6 (                   )
  Rendering to file: _ditaa/9cb54df019c00816ed675e161b3c02b1dd2bc686.svg
  <p><img
  src="media/_ditaa/9cb54df019c00816ed675e161b3c02b1dd2bc686.svg" /></p>

  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF | grep --invert -E "^Done in .*sec"
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
