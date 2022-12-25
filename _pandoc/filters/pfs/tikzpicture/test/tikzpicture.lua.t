  $ pandoc --to html -L tikzpicture.lua << EOF
  > \`\`\`tikzpicture
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {circular}
  > \tikz \graph [simple necklace layout, componentwise] {
  >   a -- b -- c -- d -- a,
  >   1 -- 2 -- 3 -- 1
  > };
  > \`\`\`
  > EOF
  lualatex --halt-on-error --output-format=pdf  --output-directory=_tikzpicture _tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.tex > /dev/null
  inkscape --export-type=svg --export-plain-svg _tikzpicture/f7010684ee0279c079c430b24850875c9577f1be.pdf
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
  lualatex --halt-on-error --output-format=pdf  --output-directory=_tikzpicture _tikzpicture/2fee8323516d920f25922a2c8bcae89055646251.tex > /dev/null
  inkscape --export-type=svg --export-plain-svg _tikzpicture/2fee8323516d920f25922a2c8bcae89055646251.pdf
  <p><img
  src="_tikzpicture/2fee8323516d920f25922a2c8bcae89055646251.svg" /></p>


  $ pandoc --to html -L tikzpicture.lua << EOF
  > This is an inline
  > \`\usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  > { r -> { a, , ,b -> {c,d}, ,e} };\`{.tikzpicture} picture.
  > EOF
  lualatex --halt-on-error --output-format=pdf  --output-directory=_tikzpicture _tikzpicture/d5550b342149f5724eacdcacd52ea771d864c624.tex > /dev/null
  inkscape --export-type=svg --export-plain-svg _tikzpicture/d5550b342149f5724eacdcacd52ea771d864c624.pdf
  <p>This is an inline <img
  src="_tikzpicture/d5550b342149f5724eacdcacd52ea771d864c624.svg" />
  picture.</p>
