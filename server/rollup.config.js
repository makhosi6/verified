const pkg = require("./package.json");
const { builtinModules } = require("module");
const commonjs = require('@rollup/plugin-commonjs');
const { obfuscator } = require('rollup-obfuscator');
const transform = require("./transform.config.json")

module.exports = {
	input: "nonce.source.js",
	output: [
		{
			file: 'nonce.js',
			format: 'cjs',
		},

	],
	plugins: [
		commonjs(),
		obfuscator(transform)

	],
	external: [
		...builtinModules,
		...(pkg.dependencies == null ? [] : Object.keys(pkg.dependencies)),
		...(pkg.devDependencies == null ? [] : Object.keys(pkg.devDependencies)),
		...(pkg.peerDependencies == null ? [] : Object.keys(pkg.peerDependencies))
	]
};