Put small space into abbreviations:

  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to latex <<EOF
  > # D.h. dies z.B.
  > 
  > D.h. foo·bar
  > 
  > keine·Trennung·hier
  > 
  > Dies ist z.B. u.a. eine Abkürzung.
  > EOF
  \hypertarget{d.h.-dies-z.b.}{%
  \section{\texorpdfstring{D.\,h. dies
  z.\,B.}{D.h. dies z.B.}}\label{d.h.-dies-z.b.}}
  
  D.\,h. foo~bar
  
  keine~Trennung~hier
  
  Dies ist z.\,B. u.\,a. eine Abkürzung.


  $ pandoc --filter Text/Pandoc/Filter/slides.hs --to html5 <<EOF
  > # D.h. dies z.B.
  > 
  > D.h. foo·bar
  > 
  > keine·Trennung·hier
  > 
  > Dies ist z.B. u.a. eine Abkürzung.
  > EOF
  <h1 id="d.h.-dies-z.b.">D.&thinsp;h. dies z.&thinsp;B.</h1>
  <p>D.&thinsp;h. foo&nbsp;bar</p>
  <p>keine&nbsp;Trennung&nbsp;hier</p>
  <p>Dies ist z.&thinsp;B. u.&thinsp;a. eine Abkürzung.</p>
