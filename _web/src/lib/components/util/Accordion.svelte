<script lang="ts">
	import { AccordionItem, Accordion } from 'flowbite-svelte';

	let class_: string;
	export { class_ as class };
	export let activeClasses: string;
	export let inactiveClasses: string;
</script>

<Accordion
	class={class_ + ' rounded-b-lg'}
	{activeClasses}
	inactiveClasses={inactiveClasses + ' hover:rounded-b-lg'}
>
	<AccordionItem>
		<span slot="header" class="font-semibold">Lösungen</span>
		<div><slot /></div>
	</AccordionItem>
</Accordion>
