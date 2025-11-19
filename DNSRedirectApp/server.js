const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 8080;

// Load redirect configuration
let redirects = {};
const configPath = path.join(__dirname, 'redirects.json');

function loadRedirects() {
  try {
    const data = fs.readFileSync(configPath, 'utf8');
    redirects = JSON.parse(data);
    console.log('Redirect configuration loaded successfully');
    console.log(`Loaded ${Object.keys(redirects).length} redirect rules`);
  } catch (error) {
    console.error('Error loading redirect configuration:', error.message);
    redirects = {};
  }
}

// Load redirects on startup
loadRedirects();

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// Health check endpoint for Azure
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', redirectCount: Object.keys(redirects).length });
});

// Admin endpoint to reload configuration
app.get('/admin/reload', (req, res) => {
  loadRedirects();
  res.json({ message: 'Configuration reloaded', redirectCount: Object.keys(redirects).length });
});

// Handle all redirect routes
app.get('*', (req, res) => {
  const requestPath = req.path;
  
  // Check for exact match
  if (redirects[requestPath]) {
    const destination = redirects[requestPath];
    console.log(`Redirecting ${requestPath} -> ${destination}`);
    return res.redirect(301, destination);
  }
  
  // Check for pattern match (wildcard support)
  for (const [pattern, destination] of Object.entries(redirects)) {
    if (pattern.includes('*')) {
      const regex = new RegExp('^' + pattern.replace(/\*/g, '.*') + '$');
      if (regex.test(requestPath)) {
        console.log(`Redirecting ${requestPath} -> ${destination} (pattern: ${pattern})`);
        return res.redirect(301, destination);
      }
    }
  }
  
  // No redirect found
  console.log(`No redirect found for ${requestPath}`);
  res.status(404).json({ 
    error: 'Not Found', 
    message: 'No redirect configured for this path',
    path: requestPath
  });
});

app.listen(port, () => {
  console.log(`DNS Redirect App listening on port ${port}`);
  console.log(`Node version: ${process.version}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
