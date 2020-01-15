// This scripts allows me to access environment variables to configure Parcel, which I need for Docker
require("dotenv").config();
const Bundler = require("parcel-bundler");
const Path = require("path");

const port = process.env.PORT;
const hmrPort = process.env.HMR_PORT;

const entryFiles = Path.join(__dirname, "../src/index.html");
const options = {
  hmrPort: hmrPort
};

const bundler = new Bundler(entryFiles, options);
bundler.serve(parseInt(port));
