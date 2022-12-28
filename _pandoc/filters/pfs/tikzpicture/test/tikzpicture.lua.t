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
  src="_tikzpicture/1f9c34caf60fed252dfd94312b735ee9990ab2b6.svg" /></p>

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
  src="_tikzpicture/5252d63fbd4e63ddb42179260c289441a0426d22.svg" /></p>


  $ pandoc --to html -L tikzpicture.lua << EOF
  > This is an inline
  > \`\usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  > { r -> { a, , ,b -> {c,d}, ,e} };\`{.tikzpicture} picture.
  > EOF
  <p>This is an inline <img
  src="_tikzpicture/de90476a6a568eebf3aa814ec9ffa428be6c9cb0.svg" />
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
  src="_tikzpicture/d228af5099f36dacc9c3db58fa0b91714c7fb204.svg" /></p>

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
  src="_tikzpicture/db4faa6c47d2139fa2a062c2bb89d582430ff11e.svg" /></p>
