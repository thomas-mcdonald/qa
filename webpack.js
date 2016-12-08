module.exports = {
  entry: './ui/App.js',
  output: {
    path: __dirname + "/app/assets/javascripts",
    filename: "build.js"
  },
  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: 'babel-loader'
    }]
  }
}
