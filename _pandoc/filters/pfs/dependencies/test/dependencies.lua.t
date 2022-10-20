  $ pandoc -L dependencies.lua -t plain <<EOF
  > ![](images/deps.png)
  > EOF
  image images/deps.png

  $ pandoc -L dependencies.lua -t plain <<EOF
  > ![](images/deps.png)
  > ![](images/deps.svg)
  > EOF
  image images/deps.png
  image images/deps.svg

  $ pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies: sourcecode src/lua/demo.lua
  > ---
  > ![](images/deps.png)
  > EOF
  sourcecode src/lua/demo.lua
  image images/deps.png


  $ pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - sourcecode src/lua/demo.lua
  >   - sourcecode src/tex/diagram.tex
  > ---
  > ![](images/deps.png)
  > EOF
  sourcecode src/lua/demo.lua
  sourcecode src/tex/diagram.tex
  image images/deps.png

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ include="src/Test.java" }
  > \`\`\`
  > EOF
  sourcecode src/Test.java

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ include="src/Test.java" }
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  image images/deps.png
  sourcecode src/Test.java

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ .include }
  > content/lua/lua.md
  > \`\`\`
  > EOF
  markup content/lua/lua.md

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > EOF
  markup content/lua/lua.md
  markup more_content/java/Test.md


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  image images/deps.png
  markup content/lua/lua.md
  markup more_content/java/Test.md


  $ pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - src/lua/demo.lua
  >   - src/tex/diagram.tex
  > ---
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  src/lua/demo.lua
  src/tex/diagram.tex
  image images/deps.png
  markup content/lua/lua.md
  markup more_content/java/Test.md

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r test-main, child = 'knitr-child.Rmd'}
  > \`\`\`
  > EOF
  markup knitr-child.Rmd

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r test-main, child = "knitr-child.Rmd"}
  > \`\`\`
  > EOF
  markup knitr-child.Rmd

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{ test-main, child = "knitr-child.Rmd"}
  > \`\`\`
  > EOF
  


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r child = c('one.Rmd', 'two.Rmd')}
  > \`\`\`
  > EOF
  markup one.Rmd
  markup two.Rmd


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r child = c("one.Rmd", "two.Rmd")}
  > \`\`\`
  > EOF
  markup one.Rmd
  markup two.Rmd

  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r child = c('one.Rmd', "two.Rmd")}
  > \`\`\`
  > EOF
  markup one.Rmd
  markup two.Rmd


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r child = c('one.Rmd', "two.Rmd")}
  > \`\`\`
  > EOF
  markup one.Rmd
  markup two.Rmd


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r test-main, child="knitr-child.Rmd"}
  > \`\`\`
  > EOF
  markup knitr-child.Rmd


  $ pandoc -L dependencies.lua -t plain <<EOF
  > \`\`\`{r test-main, chil="knitr-child.Rmd"}
  > \`\`\`
  > EOF
  

  $ pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - src/lua/demo.lua
  >   - src/tex/diagram.tex
  > ---
  > 
  > \`\`\`{r test-main, child='knitr-child.Rmd'}
  > \`\`\`
  > 
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  src/lua/demo.lua
  src/tex/diagram.tex
  markup knitr-child.Rmd
  image images/deps.png
  markup content/lua/lua.md
  markup more_content/java/Test.md

  $ CATEGORIES="pandoc knitr" pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - src/lua/demo.lua
  >   - src/tex/diagram.tex
  > ---
  > 
  > \`\`\`{r test-main, child='knitr-child.Rmd'}
  > \`\`\`
  > 
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  src/lua/demo.lua
  src/tex/diagram.tex
  markup knitr-child.Rmd
  image images/deps.png
  markup content/lua/lua.md
  markup more_content/java/Test.md

  $ CATEGORIES="pandoc" pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - src/lua/demo.lua
  >   - src/tex/diagram.tex
  > ---
  > 
  > \`\`\`{r test-main, child='knitr-child.Rmd'}
  > \`\`\`
  > 
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  src/lua/demo.lua
  src/tex/diagram.tex
  image images/deps.png
  markup content/lua/lua.md
  markup more_content/java/Test.md

  $ CATEGORIES="knitr" pandoc -L dependencies.lua -t plain <<EOF
  > ---
  > dependencies:
  >   - src/lua/demo.lua
  >   - src/tex/diagram.tex
  > ---
  > 
  > \`\`\`{r test-main, child='knitr-child.Rmd'}
  > \`\`\`
  > 
  > \`\`\`{ .include }
  > content/lua/lua.md
  > more_content/java/Test.md
  > \`\`\`
  > ![](images/deps.png)
  > EOF
  src/lua/demo.lua
  src/tex/diagram.tex
  markup knitr-child.Rmd
