<script lang="ts">
	export let dataCitationIds: string = $$props['data-citation-ids'];
</script>

<span class="cite" data-citation-ids={dataCitationIds}><slot /></span>
