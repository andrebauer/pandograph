<script lang="ts">
	import { display } from 'mathlifier';

	export let latex: string;
</script>

<span>{@html display(latex)}</span>
