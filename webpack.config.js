const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

module.exports = env => {
  isEnvProduction = env === "production";
  isEnvDevelopment = !isEnvProduction;

  var devtool = isEnvDevelopment ? "eval-source-map" : "nosources-source-map";

  return {
    mode: isEnvProduction ? "production" : "development",
    entry: "./src/index.tsx",
    module: {
      rules: [
        {
          test: /\.ts(x?)$/,
          use: "ts-loader",
          exclude: /node_modules/
        },
        {
          enforce: "pre",
          test: /\.js$/,
          loader: "source-map-loader"
        },
        {
          test: /\.css$/,
          use: [
            "style-loader",
            {
              loader: "css-loader",
              options: {
                importLoaders: 1,
                modules: true
              }
            }
          ]
        },
        {
          test: /\.(woff|woff2|eot|ttf|otf)$/,
          loader: "file-loader",
          options: {
            outputPath: "fonts"
          }
        }
      ]
    },
    output: {
      filename: isEnvProduction
        ? "[name].[contenthash].bundle.js"
        : "[name].bundle.js",
      path: path.resolve(__dirname, "dist"),
      publicPath: "/"
    },
    plugins: [
      new CleanWebpackPlugin(),
      new HtmlWebpackPlugin({
        template: "public/index.html"
      })
    ],
    resolve: {
      extensions: [".js", ".ts", ".tsx"]
    },
    devtool: devtool,
    devServer: {
      contentBase: "./dist",
      port: 3000,
      proxy: {
        "/api": "http://localhost:4000"
      }
    },
    optimization: {
      moduleIds: "hashed",
      runtimeChunk: "single",
      splitChunks: {
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: "vendors",
            chunks: "all"
          }
        }
      }
    }
  };
};
