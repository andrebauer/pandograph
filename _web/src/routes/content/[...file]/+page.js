import { json } from '@sveltejs/kit';

// import Counter from '$lib/Counter.svelte';
// import { p } from '$lib/components/components';

export async function load({ params }) {
	const segments = params.file.split('/');
	let post;

	switch (segments.length) {
		case 1:
			post = await import(`../../../../../_build/content/${segments[0]}.svelte`);
			break;
		case 2:
			post = await import(`../../../../../_build/content/${segments[0]}/${segments[1]}.svelte`);
			break;
		case 3:
			post = await import(
				`../../../../../_build/content/${segments[0]}/${segments[1]}/${segments[2]}.svelte`
			);
	}
	const content = post.default;

	const breadcrumb = [
		{ href: '/', title: 'Home', home: true },
		{ href: '/content', title: 'Content' }
	];

	/*
	let path = '/content';
	segments.forEach((seg) => {
		path += '/' + seg;
		breadcrumb.push({ href: path, title: post.title });
	});
*/
	return {
		content,
		href: params.file,
		breadcrumb
	};
}
