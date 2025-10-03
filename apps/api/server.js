const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/healthz', (req, res) => res.status(200).send('ok'));
app.get('/api', (req, res) => res.json({ message: 'Hello from Platform API' }));

app.listen(port, () => console.log(`API listening on ${port}`));
