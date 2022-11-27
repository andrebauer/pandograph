<script lang="ts">
	import Accordion from '$lib/components/util/Accordion.svelte';
</script>

<Accordion
	class="bg-amber-100"
	activeClasses="bg-amber-200 hover:bg-amber-300"
	inactiveClasses="hover:bg-amber-300"
	header="Lösungen"><slot /></Accordion
>
