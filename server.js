const express = require('express');
const path = require('path');
const app = express();

// The port the app will run on. 3000 is a common one.
const port = 3000;

// This line tells Express to serve all the files from your 'public' folder
app.use(express.static(path.join(__dirname, 'public')));

// This starts the server
app.listen(port, () => {
  console.log(`Web app is live at http://localhost:${port}`);
});