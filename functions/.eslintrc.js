module.exports = {
	"parser": "@typescript-eslint/parser",
	"extends": [
		"plugin:@typescript-eslint/recommended"
	],
	"parserOptions": {
		"ecmaVersion": 2020,
		"sourceType": "module"
	},
	"env": {
		"es6": true
	},
	rules: {
		"quotes": ["error", "double"],
		"import/no-unresolved": 0,
		"indent": ["error", "tab"],
	},
};
