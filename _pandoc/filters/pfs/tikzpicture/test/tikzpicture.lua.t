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
  src="_tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.svg" /></p>

  $ diff _tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.svg fixtures/01.svg


  $ pandoc --to html -L tikzpicture.lua << EOF
  > \`\`\`tikzpicture
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  >  { r -> { a, , ,b -> {c,d}, ,e} };
  > \`\`\`
  > EOF
  <p><img
  src="_tikzpicture/2fee8323516d920f25922a2c8bcae89055646251.svg" /></p>


  $ pandoc --to html -L tikzpicture.lua << EOF
  > This is an inline
  > \`\usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  > { r -> { a, , ,b -> {c,d}, ,e} };\`{.tikzpicture} picture.
  > EOF
  <p>This is an inline <img
  src="_tikzpicture/d5550b342149f5724eacdcacd52ea771d864c624.svg" />
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
  src="_tikzpicture/88c6c4571a6df7f917872d3ccb753c6384a5a13a.svg" /></p>
