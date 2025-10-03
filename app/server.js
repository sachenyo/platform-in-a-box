const http = require("http");
const port = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  if (req.url === "/healthz" || req.url === "/") {
    res.writeHead(200, {"Content-Type": "text/plain"});
    return res.end("platform-in-a-box OK\n");
  }
  res.writeHead(404, {"Content-Type": "text/plain"});
  res.end("not found\n");
});

server.listen(port, () => {
  console.log(`listening on :${port}`);
});
