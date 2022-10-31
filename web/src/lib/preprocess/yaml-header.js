import matter from 'gray-matter';
// const matter = require('gray-matter');

export const yamlHeader = (options) => {
	const { extensions = '.md' } = options;
	return {
		markup: ({ content, filename }) => {
			const extensionsParts = extensions.map((ext) => ext.split('.').pop());
			if (!extensionsParts.includes(filename.split('.').pop())) return;

			const doc = matter(content);
			const data = doc.data;
			// console.log('markup: ' + filename);

			return {
				code: doc.content,
				data: data
			};
		},
		script: ({ content, markup, attributes, filename }) => {
			// console.log('script:', filename);
			const extensionsParts = extensions.map((ext) => ext.split('.').pop());
			if (!extensionsParts.includes(filename.split('.').pop())) return;

			const doc = matter(content);
			const data = doc.data;
			// console.log('script - data:', data);

			return {
				code: 'const data = ' + YAML.stringfiy(doc.data)
			};
		}
	};
};
