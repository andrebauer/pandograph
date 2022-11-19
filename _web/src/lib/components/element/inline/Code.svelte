<script lang="ts" context="module">
  import hljs from 'highlight.js';
  import 'highlight.js/styles/github.css';
</script>

<script lang="ts">
 export let className: string = '';
 export { className as class };

 export let id: string;
 export let source: string;
 export let language: string;
 id = id || '';

</script>

<span class="bg-neutral-50 px-2 py-0.5 rounded rounded-lg">
  {#if language}

    <code class="language-{language}">{@html hljs.highlight(source, { language }).value}</code>

  {:else}
    <code>{source}</code>
  {/if}
</span>
