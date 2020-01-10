const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");

const isEnvProduction = process.env.NODE_ENV === "production";
const isEnvDevelopment = !isEnvProduction;

const backendUrl = process.env.BACKEND_URL || "http://localhost:4000";
const frontendPort = process.env.FRONTEND_PORT || 4001;
const devServerHost = process.env.DEV_SERVER_HOST || "localhost";

module.exports = {
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
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.less$/,
        use: ["style-loader", "css-loader", "less-loader"]
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
  devtool: isEnvDevelopment ? "eval-source-map" : "nosources-source-map",
  devServer: {
    host: devServerHost,
    port: frontendPort,
    publicPath: "/",
    historyApiFallback: true,
    hot: true,
    proxy: {
      "/api": backendUrl
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
