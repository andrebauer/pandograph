import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';
import { yamlHeader } from './src/lib/preprocess/yaml-header.js';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [
		preprocess({
			postcss: true
		})
		// yamlHeader({ extensions: ['.md'] })
	],
	extensions: ['.svelte', '.md'],
	kit: {
		adapter: adapter()
	}
};

export default config;
