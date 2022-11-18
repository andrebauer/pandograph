<script lang="ts">
	export let id: string;
	export let src: string;
	export let title: string;
	export let caption: string;
</script>

<figure>
	<img {id} {src} alt={caption} class="rounded-lg" />
	<figcaption class="font-semibold text-sm mt-2 mb-6">{caption}</figcaption>
</figure>
