<script lang="ts">
	export let level: number;
	export let id: string;
</script>

{#if level == 1}
	<h1 {id} class="text-5xl mb-6 font-bold leading-tight"><slot /></h1>
{:else if level == 2}
	<h2 {id} class="text-4xl mt-12 mb-3 font-bold"><slot /></h2>
{:else if level == 3}
	<h3 {id} class="text-3xl mt-10 mb-2 font-bold"><slot /></h3>
{:else if level == 4}
	<h4 {id} class="text-2xl mt-8 mb-2 font-semibold"><slot /></h4>
{:else if level == 5}
	<h5 {id} class="text-xl mt-7 mb-1 font-semibold"><slot /></h5>
{:else}
	<h6 {id} class="text-lg mt-6 mb-1 font-semibold"><slot /></h6>
{/if}
