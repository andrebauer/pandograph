<script lang="ts">
	export let title: string;
	let open = false;
</script>

<div class="bg-yellow-500">
	<h3 on:click={() => (open = !open)}>Lösungen</h3>
	<div class={open ? 'block' : 'hidden'}>
		<slot />
	</div>
</div>
