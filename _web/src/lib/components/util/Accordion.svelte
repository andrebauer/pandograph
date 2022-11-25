<script lang="ts">
	import GoChevronDown from 'svelte-icons/go/GoChevronDown.svelte'
	import GoChevronLeft from 'svelte-icons/go/GoChevronLeft.svelte'
	import { scale } from 'svelte/transition';
	let open = false;
</script>

<div class="">
	<button on:click={() => (open = !open)} on:keydown={()=> open = !open} class={`flex font-semibold text-sm bg-amber-200 p-2 block cursor-pointer ` + (open ? 'rounded-t-lg' : 'rounded-lg')}>
		<slot class="flex-auto" name="header" />
		<span class="mt-0.5 w-4 h-4 text-sm">
			{#if open}
				<GoChevronDown />
			{:else}
				<GoChevronLeft />
			{/if}			
		</span>
	</button>
    {#key open}
	<div transition:scale={{ duration: 300 }}
    class={(open ? 'block' : 'hidden') + " p-2 bg-amber-100 rounded-lg rounded-tl-none"}>
		<slot />
	</div>
    {/key}
</div>