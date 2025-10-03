const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/healthz', (req, res) => res.status(200).send('ok'));
app.get('/', (req, res) => res.send('<h1>Platform Web</h1><p>Deployed via Helm on EKS</p>'));

app.listen(port, () => console.log(`Web listening on ${port}`));
