<script lang="ts">
	export let className: string = '';
	export { className as class };
</script>

<code class={className}><slot /></code>
