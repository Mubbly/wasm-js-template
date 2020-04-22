/* eslint-env node */

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WasmPackPlugin = require('@wasm-tool/wasm-pack-plugin');

// Where to stick the wasm, js shims and ts signatures generated from rust
const wasmOut = path.resolve(__dirname, 'pkg');

// Where to stick the entire thing when it is all bundled up
const bundleOut = path.resolve(__dirname, 'dist');

const MODE = 'development';

module.exports = {
    mode: MODE,

    // Build a dependency graph of modules starting from entry and bundle into one js file in output
    entry: './js/index.tsx',
    output: {
        path: bundleOut,
        filename: 'bundle.js',
    },

    // Webpack will resolve files with these extensions to modules
    resolve: {
        extensions: ['.js', '.ts', '.tsx'],
    },

    // Dev server configuration
    devServer: {
        contentBase: bundleOut,
        compress: false,
        host: '0.0.0.0',
        port: 8080,
    },

    // How to treat different kinds of modules
    module: {
        rules: [{
            // Files with .ts and .tsx extension ..
            test: /\.(ts|tsx)$/,
            // .. except what is in node_modules ..
            exclude: /node_modules/,
            // .. is passed through eslint-loader and the ts-loader. (lint first, compile second)
            use: ['ts-loader', 'eslint-loader'],
        }, ],
    },

    plugins: [
        // Create a index.html file that includes the bundled js.
        new HtmlWebpackPlugin({
            template: 'index_template.html',
        }),

        // Use webpack to handle triggering rust to wasm builds and bundling the results
        new WasmPackPlugin({
            forceMode: MODE,
            outDir: wasmOut,
            outName: 'main_crate',

            // Similar logic to "entry" above if this crate uses crates in watchDirectories below
            crateDirectory: path.resolve(__dirname, 'rust/main_crate'),

            // Changes in these crates will also trigger re-compiling
            watchDirectories: [path.resolve(__dirname, 'rust/sub_crate')],
        }),
    ],
};