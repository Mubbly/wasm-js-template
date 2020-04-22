module.exports = {
    // Parse files into eslint's internal representation using this parser
    parser: "@typescript-eslint/parser",
    parserOptions: {
        ecmaVersion: 2018,
        sourceType: "module",
        ecmaFeatures: {
            jsx: true
        }
    },

    // Use predefined rules as a basis for eslint
    extends: [
        // Recommended eslint rules for react
        "plugin:react/recommended",
        // Recommended eslint rules for ts
        "plugin:@typescript-eslint/recommended",
        // Disable eslint rules from typescript-eslint/recommended that would conflict with prettier
        "prettier/@typescript-eslint",
        // Enables eslint errors in a way that prettier errors are displayed as eslint errors
        "plugin:prettier/recommended",
    ],

    // Can overwrite ESLint rules manually here
    rules: {},

    // What environment in the parsed js / ts / tsx etc. running in?
    env: {
        // This marks document and other browser APIs as available
        // Used by application code
        "browser": true,

        // This marks require and other Node APIs as available
        // Used by config files for tools in the js toolchain
        "node": true
    },

    // Setting for various plugins
    settings: {
        react: {
            version: "detect",
        }
    }
};