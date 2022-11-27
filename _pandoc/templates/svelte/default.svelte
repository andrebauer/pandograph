$if(imports)$
<script>
 $for(imports)$
 $imports$
 $endfor$
 $if(title)$
 export const title = '$title$'
 $endif$ $if(author)$
 export const author = [$for(author)$'$author$', $endfor$]
 $endif$
</script>
$endif$

$for(include-before)$ $include-before$ $endfor$ $if(title)$
<header id="title-block-header">
  <h1 class="title">$title$</h1>
  $if(subtitle)$
  <p class="subtitle">$subtitle$</p>
  $endif$ $for(author)$
  <p class="author">$author$</p>
  $endfor$ $if(date)$
  <p class="date">$date$</p>
  $endif$ $if(abstract)$
  <div class="abstract">
    <div class="abstract-title">$abstract-title$</div>
    $abstract$
  </div>
  $endif$
</header>
$endif$ $if(toc)$
<nav id="$idprefix$TOC" role="doc-toc">
  $if(toc-title)$
  <h2 id="$idprefix$toc-title">$toc-title$</h2>
  $endif$ $table-of-contents$
</nav>
$endif$ $body$ $for(include-after)$ $include-after$ $endfor$
