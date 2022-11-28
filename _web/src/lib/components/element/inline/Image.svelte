<script lang="ts">
	export let id: string;
	export let src: string;
	export let title: string;
	export let height: string;
	export let width: string;
</script>

<p><img {id} {src} {title} {height} {width} class="rounded-lg" /></p>
