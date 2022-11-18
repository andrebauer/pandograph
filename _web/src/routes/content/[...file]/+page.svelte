<script>
	import 'katex/dist/katex.css';

	import './styles.postcss';

	export let data;
</script>

<article class="max-w-2xl break-words p-4">
	<!-- <h1 class="text-6xl font-bold leading-tight">{data.title}</h1> -->
	<svelte:component this={data.content} />
</article>

<style>
</style>
