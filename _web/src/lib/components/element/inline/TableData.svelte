<script lang="ts">
	export let align: string;
</script>

<td {align} class="py-4">
	<p class="text-gray-900 whitespace-no-wrap mr-6">
		<slot />
	</p>
</td>

<style>
	td:last-child > p {
		margin-right: 0em;
	}
</style>
