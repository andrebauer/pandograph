<script lang="ts">
	import { AccordionItem, Accordion } from 'flowbite-svelte';
</script>

<Accordion class="bg-amber-100 rounded-b-lg" activeClasses="bg-amber-200 hover:bg-amber-300" 
inactiveClasses="hover:bg-amber-300 hover:rounded-b-lg">
  <AccordionItem>
	<span slot="header" class="font-semibold">Lösungen</span>
	<div><slot /></div>
  </AccordionItem>
</Accordion>


