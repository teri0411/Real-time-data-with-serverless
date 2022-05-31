const path = require('path');
const slsw = require('serverless-webpack');
const webpack = require('webpack');

function srcPath(subdir) {
  return path.join(__dirname, subdir);
}

module.exports = {
  context: __dirname,
  plugins: [
    new webpack.DefinePlugin({
      'process.env.ENDPOINT_URL': JSON.stringify(process.env.ENDPOINT_URL),
    }),
  ],
  entry: slsw.lib.entries,
  externals: ['ws', 'encoding', { 'aws-sdk': 'commonjs aws-sdk' }],
  mode: 'development',
  devtool: 'source-map',
  resolve: {
    extensions: ['.mjs', '.js', '.jsx', '.json'],
    alias: {
      'node-fetch$': 'node-fetch/lib/index.js',
    },
    enforceExtension: false,
  },
  output: {
    libraryTarget: 'commonjs',
    path: srcPath('.webpack'),
    filename: 'lambda/websocket.js',
  },
  target: 'node',
  module: {
    rules: [
      {
      test: /\.m?js$/,
      exclude: /(node_modules|bower_components)/,
      use: {
        loader: 'babel-loader',
        options: {
          presets: [['@babel/preset-env',{ "targets": { "esmodules": true }}]]
        }
      }
    },
    ],
  },
};
