<script lang="ts" context="module">
	/*import Prism from 'prismjs';
	import 'prismjs/themes/prism.css';
	import 'prismjs/plugins/line-highlight/prism-line-highlight.css';
	import 'prismjs/plugins/line-numbers/prism-line-numbers.css';*/
	/* import 'prismjs/plugins/line-highlight/prism-line-highlight';
	import 'prismjs/plugins/line-numbers/prism-line-numbers'; */
	// Prism.manual = true;
	// import loadLanguages from 'prismjs/components/';
	import hljs from 'highlight.js';
	import 'highlight.js/styles/github.css';

	import { onMount } from 'svelte';
	// import 'prismjs/plugins/'
</script>

<script lang="ts">
	let className: string = '';
	export { className as class };

	export let id: string;
	export let source: string;
	export let language: string;
	id = id || '';
	let pre: any;
	// let highlightRanges = pre.get('data-line');
	// loadLanguages([language]);

	/*
	onMount(async () => {
		await import('prismjs/plugins/line-highlight/prism-line-highlight');
		await import('prismjs/plugins/line-numbers/prism-line-numbers');
		// Prism = await import('prismjs');
		// const Prism = document.Prism;
		// loadLanguages([language]);
	});
*/

	let hll: any;

	const onClick = async () => {
		console.log('pre', pre);
		// hll = Prism.plugins.lineHighlight.highlightLines(pre);
		// console.log('pre', pre);
		// hll();
		// Prism.plugins.li;
	};
</script>

<button on:click={onClick}>highlight</button>

<div class="line-numbers bg-slate-50 p-4 rounded rounded-lg">
	<pre bind:this={pre} {id} data-line="2" data-start="1" class="line-numbers language-{language}">
<code class="language-{language}"
			>{@html hljs.highlight(source, { language })
				.value}<!--{@html Prism.highlight(
				source,
				Prism.languages[language],
				language
			)}-->
</code></pre>
</div>

<style>
</style>
