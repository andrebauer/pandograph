<script lang="ts">
	let open = false;
</script>

<div
	on:mouseleave={() => (open = false)}
	on:mouseover={() => (open = true)}
	class="relative inline-block"
>
	<slot name="notereference" />
	<div
		class={'absolute -top-2 left-2 bg-neutral-100 px-4 -my-4 w-32 ' + (open ? 'block' : 'hidden')}
	>
		<slot name="inlinenote" class="-my-4" />
	</div>
</div>
