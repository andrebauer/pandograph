# Pandograph

Pandograph is a build system for documents using [Pandoc].

You can run 

# Prerequisites

You need

- [Pandoc](https://pandoc.org/installing.html)
- [Waf](https://waf.io/)


Optionally you need 

- [R](https://www.r-project.org/) if you opt to use
  [knitr](https://yihui.org/knitr/) as a preprocessor.
  
- [Node.js](https://nodejs.org/en/) if you opt to use [SvelteKit]
  as the UI-Framework for the Website-Generation.

# Installation

Clone this repository and run

```bash
waf configure build_svelte build_pdf
```


If you opt to use [SvelteKit], then run

```bash
cd _web
npm install_
npm run dev
```


[Pandoc]: https://pandoc.org/
[SvelteKit]: https://kit.svelte.dev/
