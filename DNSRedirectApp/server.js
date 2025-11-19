const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const port = process.env.PORT || 8080;

// Load redirect configuration
let config = { hostRedirects: {}, pathRedirects: {} };
const configPath = path.join(__dirname, 'redirects.json');

function loadRedirects() {
  try {
    const data = fs.readFileSync(configPath, 'utf8');
    const loadedConfig = JSON.parse(data);
    
    // Support both new format and legacy format
    if (loadedConfig.hostRedirects || loadedConfig.pathRedirects) {
      config = {
        hostRedirects: loadedConfig.hostRedirects || {},
        pathRedirects: loadedConfig.pathRedirects || {}
      };
    } else {
      // Legacy format - treat as path redirects
      config = {
        hostRedirects: {},
        pathRedirects: loadedConfig
      };
    }
    
    const hostCount = Object.keys(config.hostRedirects).length;
    const pathCount = Object.keys(config.pathRedirects).length;
    console.log('Redirect configuration loaded successfully');
    console.log(`Loaded ${hostCount} host redirect rules, ${pathCount} path redirect rules`);
  } catch (error) {
    console.error('Error loading redirect configuration:', error.message);
    config = { hostRedirects: {}, pathRedirects: {} };
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
  const hostCount = Object.keys(config.hostRedirects).length;
  const pathCount = Object.keys(config.pathRedirects).length;
  res.status(200).json({ 
    status: 'healthy', 
    hostRedirectCount: hostCount,
    pathRedirectCount: pathCount,
    totalRedirectCount: hostCount + pathCount
  });
});

// Admin endpoint to reload configuration
app.get('/admin/reload', (req, res) => {
  loadRedirects();
  const hostCount = Object.keys(config.hostRedirects).length;
  const pathCount = Object.keys(config.pathRedirects).length;
  res.json({ 
    message: 'Configuration reloaded', 
    hostRedirectCount: hostCount,
    pathRedirectCount: pathCount,
    totalRedirectCount: hostCount + pathCount
  });
});

// Handle all redirect routes
app.get('*', (req, res) => {
  const requestPath = req.path;
  const hostname = req.hostname || req.get('host')?.split(':')[0] || '';
  
  // 1. Check for host-based redirects (exact match)
  if (config.hostRedirects[hostname]) {
    const destination = config.hostRedirects[hostname];
    console.log(`Redirecting ${hostname}${requestPath} -> ${destination} (host match)`);
    return res.redirect(301, destination);
  }
  
  // 2. Check for host-based redirects (wildcard match)
  for (const [pattern, destination] of Object.entries(config.hostRedirects)) {
    if (pattern.includes('*')) {
      const regex = new RegExp('^' + pattern.replace(/\./g, '\\.').replace(/\*/g, '.*') + '$');
      if (regex.test(hostname)) {
        console.log(`Redirecting ${hostname}${requestPath} -> ${destination} (host pattern: ${pattern})`);
        return res.redirect(301, destination);
      }
    }
  }
  
  // 3. Check for path-based redirects (exact match)
  if (config.pathRedirects[requestPath]) {
    const destination = config.pathRedirects[requestPath];
    console.log(`Redirecting ${requestPath} -> ${destination} (path match)`);
    return res.redirect(301, destination);
  }
  
  // 4. Check for path-based redirects (wildcard match)
  for (const [pattern, destination] of Object.entries(config.pathRedirects)) {
    if (pattern.includes('*')) {
      const regex = new RegExp('^' + pattern.replace(/\*/g, '.*') + '$');
      if (regex.test(requestPath)) {
        console.log(`Redirecting ${requestPath} -> ${destination} (path pattern: ${pattern})`);
        return res.redirect(301, destination);
      }
    }
  }
  
  // No redirect found
  console.log(`No redirect found for ${hostname}${requestPath}`);
  res.status(404).json({ 
    error: 'Not Found', 
    message: 'No redirect configured for this host or path',
    host: hostname,
    path: requestPath
  });
});

app.listen(port, () => {
  console.log(`DNS Redirect App listening on port ${port}`);
  console.log(`Node version: ${process.version}`);
  console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
});
