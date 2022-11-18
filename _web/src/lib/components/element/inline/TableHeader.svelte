<script lang="ts">
	export let align: string;
</script>

<th {align} class="py-4 font-bold text-gray-800 tracking-wider-tk">
	<p class="mr-6">
		<slot />
	</p>
</th>

<style>
	th:last-child > p {
		margin-right: 0em;
	}
</style>
