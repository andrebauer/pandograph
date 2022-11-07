<script lang="ts">
	export let href: string;
	export let title: string;
</script>

<span class="text-blue-500 underline"><a {href} {title}><slot /></a> </span>
