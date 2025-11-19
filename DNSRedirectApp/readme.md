# DNS Redirect App

A simple Node.js application for HTTP redirects, designed to run on Azure App Service with Node 22 LTS.

## Features

- HTTP 301 redirects based on **hostname** (base URI) or **path** patterns
- Wildcard pattern support for flexible routing on both hosts and paths
- Easy configuration via JSON file
- Health check endpoint for monitoring
- Configuration reload without restart
- Optimized for Azure App Service

## Prerequisites

- Node.js 22.x LTS
- npm or yarn

## Installation

1. Clone or navigate to the repository
2. Install dependencies:
   ```bash
   npm install
   ```

## Configuration

Edit `redirects.json` to define your redirect rules:

```json
{
  "hostRedirects": {
    "old-domain.com": "https://www.new-domain.com",
    "legacy.example.com": "https://www.example.com",
    "*.staging.example.com": "https://staging.example.com",
    "blog.oldsite.com": "https://newsite.com/blog"
  },
  "pathRedirects": {
    "/old-page": "https://www.example.com/new-page",
    "/blog": "https://blog.example.com",
    "/docs": "https://docs.example.com",
    "/support": "https://support.example.com/help",
    "/products/*": "https://www.example.com/catalog"
  }
}
```

### Redirect Types

#### Host-Based Redirects
Redirects based on the hostname (domain) of the incoming request:
- **Exact matches**: `"old-domain.com"` will redirect all requests to that domain
- **Wildcard patterns**: `"*.staging.example.com"` matches any subdomain like `app.staging.example.com`
- Host redirects are checked **first** and will redirect regardless of the path

#### Path-Based Redirects
Redirects based on the URL path:
- **Exact matches**: `"/old-page"` will redirect only that specific path
- **Wildcard patterns**: `"/products/*"` will redirect any path starting with `/products/`
- Path redirects are checked **after** host redirects

### Priority Order
1. Host exact match
2. Host wildcard match
3. Path exact match
4. Path wildcard match

## Running Locally

```bash
npm start
```

The server will start on port 8080 (or the PORT environment variable if set).

## Testing

Visit these endpoints to test:
- `http://localhost:8080/health` - Health check (shows counts for both redirect types)
- `http://localhost:8080/old-page` - Test path-based redirect
- `http://localhost:8080/admin/reload` - Reload configuration

To test host-based redirects locally, you can:
1. Edit your `hosts` file to point test domains to `127.0.0.1`
2. Use curl with the Host header: `curl -H "Host: old-domain.com" http://localhost:8080/`
3. Use browser extensions to modify request headers

## Deployment to Azure App Service

### Option 1: Azure CLI

```bash
# Login to Azure
az login

# Create a resource group (if needed)
az group create --name MyResourceGroup --location eastus

# Create an App Service Plan with Node 22
az appservice plan create --name MyAppServicePlan --resource-group MyResourceGroup --sku B1 --is-linux

# Create the Web App
az webapp create --resource-group MyResourceGroup --plan MyAppServicePlan --name my-redirect-app --runtime "NODE:22-lts"

# Deploy the code
az webapp deploy --resource-group MyResourceGroup --name my-redirect-app --src-path . --type zip

# Configure the startup command (if needed)
az webapp config set --resource-group MyResourceGroup --name my-redirect-app --startup-file "node server.js"
```

### Option 2: VS Code Azure Extension

1. Install the Azure App Service extension
2. Sign in to Azure
3. Right-click the DNSRedirectApp folder
4. Select "Deploy to Web App..."
5. Follow the prompts to create or select an App Service

### Option 3: GitHub Actions / Azure DevOps

Set up CI/CD pipeline with your preferred deployment tool pointing to this directory.

## API Endpoints

### `GET /health`
Returns the health status of the application.

**Response:**
```json
{
  "status": "healthy",
  "hostRedirectCount": 4,
  "pathRedirectCount": 5,
  "totalRedirectCount": 9
}
```

### `GET /admin/reload`
Reloads the redirect configuration from `redirects.json` without restarting the server.

**Response:**
```json
{
  "message": "Configuration reloaded",
  "hostRedirectCount": 4,
  "pathRedirectCount": 5,
  "totalRedirectCount": 9
}
```

### `GET /<any-path>`
Checks for matching redirect rules and performs a 301 redirect or returns 404 if no match found.

## Monitoring

Check the Azure App Service logs to monitor redirect activity:

```bash
az webapp log tail --resource-group MyResourceGroup --name my-redirect-app
```

## Configuration Updates

To update redirects in production:

1. Update `redirects.json`
2. Redeploy the application, OR
3. Use the `/admin/reload` endpoint (if you update the file directly on the server)

## Environment Variables

- `PORT` - The port number (automatically set by Azure App Service)
- `NODE_ENV` - Environment setting (development/production)

## License

MIT