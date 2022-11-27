<script lang="ts">
	import Bash from '$lib/components/codeblock/Bash.svelte';
	import {
		Breadcrumb,
		BreadcrumbItem,
		Navbar,
		NavBrand,
		NavHamburger,
		NavLi,
		NavUl
	} from 'flowbite-svelte';
	import 'katex/dist/katex.css';

	import './styles.postcss';

	export let data;

	const breadcrumb = data.breadcrumb;
	const href = data.href;

	let title: string;
	let author: string[] = [];
</script>

<article class="max-w-2xl break-words p-4">
	<Breadcrumb>
		{#each breadcrumb as { href, title, home }}
			<BreadcrumbItem {href} {home}>{title}</BreadcrumbItem>
		{/each}
		<BreadcrumbItem {href}>{title}</BreadcrumbItem>
	</Breadcrumb>
	<h1>{title}</h1>
	von
	{#each author as a}
		{a},&nbsp;
	{/each}
	<!-- <h1 class="text-6xl font-bold leading-tight">{data.title}</h1> -->
	<svelte:component this={data.content} bind:title bind:author />
</article>

<style>
</style>
