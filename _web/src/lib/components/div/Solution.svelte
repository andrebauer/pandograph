<script lang="ts">
	import GoChevronDown from 'svelte-icons/go/GoChevronDown.svelte'
	import GoChevronLeft from 'svelte-icons/go/GoChevronLeft.svelte'
	export let title: string;
	let open = false;
</script>

<div class="bg-amber-100 rounded-lg">
	<div on:click={() => (open = !open)} class={`flex font-semibold text-sm bg-amber-200 p-2 cursor-pointer ` + (open ? 'rounded-t-lg' : 'rounded-lg')}>
		<h3 class="flex-auto">Lösungen</h3>
		<span class="mt-0.5 w-4 h-4 text-sm">
			{#if open}
				<GoChevronDown />
			{:else}
				<GoChevronLeft />
			{/if}
			
		</span>
	</div>
	<div class={(open ? 'block' : 'hidden') + " p-2"}>
		<slot />
	</div>
</div>
