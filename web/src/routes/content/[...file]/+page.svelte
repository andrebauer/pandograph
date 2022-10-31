<script>
        export let data;
</script>

<article>
        <!-- <h1 class="text-6xl font-bold leading-tight">{data.title}</h1> -->
        <svelte:component this={data.content} />
</article>
