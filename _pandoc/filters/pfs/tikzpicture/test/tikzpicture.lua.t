  $ pandoc --to html -L tikzpicture.lua << EOF
  > \`\`\`tikzpicture
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {circular}
  > \tikz \graph [simple necklace layout, componentwise] {
  >   a -- b -- c -- d -- a,
  >   1 -- 2 -- 3 -- 1
  > };
  > \`\`\`
  > EOF
  <p><img
  src="_tikzpicture/5cc7357a10a63f52d72c66e7bd2c658db8b0456b.svg" /></p>

  $ diff _tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.svg fixtures/01.svg
  diff: _tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.svg: No such file or directory
  [2]


  $ pandoc --to html -L tikzpicture.lua << EOF
  > \`\`\`tikzpicture
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  >  { r -> { a, , ,b -> {c,d}, ,e} };
  > \`\`\`
  > EOF
  <p><img
  src="_tikzpicture/9e5f0558dcc754dc47cc4d464190dabed655095d.svg" /></p>


  $ pandoc --to html -L tikzpicture.lua << EOF
  > This is an inline
  > \`\usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  > { r -> { a, , ,b -> {c,d}, ,e} };\`{.tikzpicture} picture.
  > EOF
  <p>This is an inline <img
  src="_tikzpicture/49e38350daf03189ad7b0f0954b023dd91fb3e4a.svg" />
  picture.</p>


  $ pandoc --to html -L tikzpicture.lua << EOF
  > \`\`\`{.tikzpicture template=default-serif }
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {circular}
  > \tikz \graph [simple necklace layout, componentwise] {
  >   a -- b -- c -- d -- a,
  >   1 -- 2 -- 3 -- 1
  > };
  > \`\`\`
  > EOF
  <p><img
  src="_tikzpicture/06f80322d751f70c903c6fdf3e3854c937504cfd.svg" /></p>

  $ pandoc --to html -L tikzpicture.lua << EOF
  > ---
  > tikzpicture:
  >   cache: false
  >   engine:
  >     template: default-serif
  > ---
  > \`\`\`tikzpicture
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  >  { r -> { a, , ,b -> {c,d}, ,e} };
  > \`\`\`
  > EOF
  <p><img
  src="_tikzpicture/9e5f0558dcc754dc47cc4d464190dabed655095d.svg" /></p>
