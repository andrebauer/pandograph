<script lang="ts">
	export let id: string;
	let className = '';
	export { className as class };
</script>

<div
	{id}
	class={className + ' bg-gray-50 px-4 pt-1 pb-1 rounded-md m-4 border-x-8 -mx-4 border-blue-100'}
>
	<slot />
</div>
