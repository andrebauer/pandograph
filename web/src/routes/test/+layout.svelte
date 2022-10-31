<script>
	export let data;
	// const title = data.title
	const title = 'Title'
</script>

<header>
	<div>
		<pre>{JSON.stringify(data, null, 2)}</pre>
		<h1>{title}</h1>
	</div>
</header>

<slot />
