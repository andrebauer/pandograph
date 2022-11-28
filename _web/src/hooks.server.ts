import type { Handle } from '@sveltejs/kit';
import fs from 'fs/promises';

const staticPathExtensions = ['jpg', 'png', 'jpeg', 'pdf', 'svg'];

const isStaticContent = (pathname: string): boolean =>
	staticPathExtensions.find((ext) => pathname.endsWith('.' + ext)) != undefined;

export const handle: Handle = async ({ event, resolve }) => {
	if (isStaticContent(event.url.pathname)) {
		const pathname = '../_build' + event.url.pathname;
		const data = await fs.readFile(pathname);
		return new Response(data);
	}

	const response = await resolve(event);
	return response;
};
