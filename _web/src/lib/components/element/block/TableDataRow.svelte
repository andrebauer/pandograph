<script lang="ts">
	let className: string = '';
	export { className as class };
</script>

<tr
	class={`${className} odd:bg-white-tk even:bg-stone-100-tk border-b-2 last:border-none hover:bg-neutral-100`}
	><slot /></tr
>
