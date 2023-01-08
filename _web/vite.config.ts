import { sveltekit } from '@sveltejs/kit/vite';
import type { UserConfig } from 'vite';

const config: UserConfig = {
	plugins: [
		sveltekit()
		/* [
			'prismjs',
			{
				languages: ['javascript', 'css', 'markup'],
				plugins: ['line-numbers'],
				theme: 'twilight',
				css: true
			}
		] */
	],
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}']
	},
	server: {
		fs: {
			allow: ['../_build']
		}
	}
};

export default config;
