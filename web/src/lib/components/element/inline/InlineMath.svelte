<script lang="ts">
	import { math } from 'mathlifier';

	export let latex: string;
</script>

<span>{@html math(latex)}</span>
