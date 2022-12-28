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

  $ cat media/_ditaa/28c12b6e72de739c47e2fcc1a8035bc139be0167.svg
  <?xml version='1.0' encoding='UTF-8' standalone='no'?>
  <svg 
      xmlns='http://www.w3.org/2000/svg'
      width='390'
      height='182'
      shape-rendering='geometricPrecision'
      version='1.0'>
    <defs>
      <filter id='f2' x='0' y='0' width='200%' height='200%'>
        <feOffset result='offOut' in='SourceGraphic' dx='5' dy='5' />
        <feGaussianBlur result='blurOut' in='offOut' stdDeviation='3' />
        <feBlend in='SourceGraphic' in2='blurOut' mode='normal' />
      </filter>
    </defs>
    <g stroke-width='1' stroke-linecap='square' stroke-linejoin='round'>
      <rect x='0' y='0' width='390' height='182' style='fill: #ffffff'/>
      <path stroke='gray' fill='gray' filter='url(#f2)' d='M25.0 35.0 L115.0 35.0 L115.0 105.0 Q85.0 97.0 70.0 105.0 Q55.0 113.0 25.0 105.0 z' />
      <path stroke='gray' fill='gray' filter='url(#f2)' d='M285.0 105.0 L365.0 105.0 L365.0 35.0 L285.0 35.0 z' />
      <path stroke='gray' fill='gray' filter='url(#f2)' d='M155.0 105.0 L235.0 105.0 L235.0 65.0 L155.0 65.0 z' />
      <path stroke='gray' fill='gray' filter='url(#f2)' d='M155.0 61.0 L235.0 61.0 L235.0 35.0 L155.0 35.0 z' />
      <path stroke='#000000' stroke-width='1.000000' stroke-dasharray='5.000000,5.000000' stroke-miterlimit='0' stroke-linecap='butt' stroke-linejoin='round' fill='white' d='M65.0 105.0 L65.0 147.0 L325.0 147.0 L325.0 119.0 ' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='white' d='M25.0 35.0 L115.0 35.0 L115.0 105.0 Q85.0 97.0 70.0 105.0 Q55.0 113.0 25.0 105.0 z' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='white' d='M285.0 105.0 L365.0 105.0 L365.0 35.0 L285.0 35.0 z' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='white' d='M155.0 105.0 L235.0 105.0 L235.0 65.0 L155.0 65.0 z' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='white' d='M155.0 61.0 L235.0 61.0 L235.0 35.0 L155.0 35.0 z' />
      <path stroke='none' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='#000000' d='M260.0 42.0 L270.0 49.0 L260.0 56.0 z' />
      <path stroke='none' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='#000000' d='M325.0 112.0 L320.0 126.0 L330.0 126.0 z' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='none' d='M155.0 49.0 L135.0 49.0 ' />
      <path stroke='#000000' stroke-width='1.000000' stroke-linecap='round' stroke-linejoin='round' fill='none' d='M265.0 49.0 L235.0 49.0 ' />
      <text x='55' y='68' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[Text]]></text>
      <text x='35' y='82' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[Document]]></text>
      <text x='161' y='138' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[Lots of work]]></text>
      <text x='178' y='54' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[ditaa]]></text>
      <text x='171' y='82' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[!magic!]]></text>
      <text x='298' y='68' font-family='Courier' font-size='13' stroke='none' fill='#000000' ><![CDATA[diagram]]></text>
    </g>
  </svg>

  $ PRINT_DITAA_STDOUT=1 pandoc --to html -L ditaa.lua --extract-media=media << EOF
  > \`\`\` Hello
  > +--------+
  > | ditaa  |
  > +--------+
  > \`\`\`
  > EOF
  <pre class="hello"><code>+--------+
  | ditaa  |
  +--------+</code></pre>


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
  > \`\`\`ditaa
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
  ditaa _ditaa/f53c3e56aecc7dc4e5e876cfbfcc353a8bf48f3d.ditaa _ditaa/f53c3e56aecc7dc4e5e876cfbfcc353a8bf48f3d.svg  --debug    --svg   --overwrite    
  
  ditaa version 0.11, Copyright (C) 2004--2017  Efstathios (Stathis) Sideris
  
  Running with options:
  debug
  svg
  overwrite
  Reading file: _ditaa/f53c3e56aecc7dc4e5e876cfbfcc353a8bf48f3d.ditaa
  Using grid:
      012345678901234567890123456789012345678901234567890123456789
   0 (                                                       )
   1 (                                                       )
   2 (  +-------------------------------------------+        )
   3 (  | +-----------+ +-----------+ +-----------+ |        )
   4 (  | | Anwendung | | Anwendung | | Anwendung | |        )
   5 (  | +-----------+ +-----------+ +-----------+ |        )
   6 (  | | Gast???BS   | | Gast???BS   | | Gast???BS   | |  )
   7 (  | | (Windows) | | (Linux)   | | (Solaris) | |        )
   8 (  | +-----------+ +-----------+ +-----------+ |        )
   9 (  | | Virtuelle | | Virtuelle | | Virtuelle | |        )
  10 (  | | Maschine  | | Maschine  | | Maschine  | |        )
  11 (  | +-----------+ +-----------+ +-----------+ |        )
  12 (  +-------------------------------------------+        )
  13 (  | +---------------------------------------+ |        )
  14 (  | |       Virtualiserungsoftware          | |        )
  15 (  | +---------------------------------------+ |        )
  16 (  | |         Host???Betriebssystem           | |      )
  17 (  | +---------------------------------------+ |        )
  18 (  | |         Physische Maschine            | |        )
  19 (  | +---------------------------------------+ |        )
  20 (  +-------------------------------------------+        )
  21 (                                                       )
  22 (                                                       )
  Rendering to file: _ditaa/f53c3e56aecc7dc4e5e876cfbfcc353a8bf48f3d.svg
  <p><img
  src="media/_ditaa/f53c3e56aecc7dc4e5e876cfbfcc353a8bf48f3d.svg" /></p>
