  $ pandoc -L attr-test.lua --to native -o /dev/null << EOF 
  > ---
  > tikzpicture:
  >   cache: false
  >   engine:
  >     template:
  >       name: default-serif
  > ---
  > \`\`\`{.tikzpicture #tree1 additions-packages="adjustbox" width="6cm" height="4cm" name="Tree Name" caption="This is a tree"}
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {trees}
  > \tikz \graph [tree layout, nodes={draw,circle}, sibling sep=0pt]
  >  { r -> { a, , ,b -> {c,d}, ,e} };
  > \`\`\`
  > 
  > \`\`\`{.tikzpicture template=default-serif test=false}
  > \usetikzlibrary {graphs,graphdrawing} \usegdlibrary {circular}
  > \tikz \graph [simple necklace layout, componentwise] {
  >   a -- b -- c -- d -- a,
  >   1 -- 2 -- 3 -- 1
  > };
  > \`\`\`
  > EOF
  
    __sealed__: 
      1: name 
    image: 
      __sealed__: 
      caption: This is a tree 
      height: 4cm 
      id: tree1 
      name: Tree Name 
      width: 6cm 
    name: tikzpicture 
    rootdir: scriptdir 
    template: 
      name: default 
    test: true 
   
    __sealed__: 
      1: name 
    image: 
      __sealed__: 
      id:  
    name: tikzpicture 
    rootdir: scriptdir 
    template: 
      name: default-serif 
    test: false 
   
