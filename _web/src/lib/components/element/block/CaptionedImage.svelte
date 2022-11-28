<script lang="ts">
	export let id: string;
	export let src: string;
	export let title: string;
	export let height: string;
	export let width: string;
	// export let caption: string;
</script>

<figure>
	<!-- alt={caption} -->
	<img {id} {src} {height} {width} class="rounded-lg" />
	<figcaption class="font-semibold text-sm mt-2 mb-6"><slot /></figcaption>
</figure>
