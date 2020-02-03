require("dotenv").config();
const chalk = require("chalk");
const handler = require("serve-handler");
const http = require("http");

const port = parseInt(process.env.PORT);

const server = http.createServer((request, response) => {
  return handler(request, response, {
    public: "dist",
    rewrites: [{ source: "**", destination: "/index.html" }]
  });
});

server.listen(port, () => {
  const url = `http://localhost:${port}`;
  console.log(`Running frontend at ${chalk.yellow(url)}`);
});
