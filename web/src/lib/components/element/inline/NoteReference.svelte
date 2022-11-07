<script lang="ts">
	export let id: string;
	export let href: string;
</script>

<a {id} {href} role="doc-noteref"><sup class="text-blue-500"><slot /></sup></a>
