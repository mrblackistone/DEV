# DNS Redirect App

A simple Node.js application for HTTP redirects, designed to run on Azure App Service with Node 22 LTS.

## Features

- Simple HTTP 301 redirects based on URI patterns
- Wildcard pattern support for flexible routing
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
  "/old-page": "https://www.example.com/new-page",
  "/blog": "https://blog.example.com",
  "/docs": "https://docs.example.com",
  "/support": "https://support.example.com/help",
  "/products/*": "https://www.example.com/catalog"
}
```

- **Exact matches**: `/old-page` will redirect only that specific path
- **Wildcard patterns**: `/products/*` will redirect any path starting with `/products/`

## Running Locally

```bash
npm start
```

The server will start on port 8080 (or the PORT environment variable if set).

## Testing

Visit these endpoints to test:
- `http://localhost:8080/health` - Health check
- `http://localhost:8080/old-page` - Test redirect
- `http://localhost:8080/admin/reload` - Reload configuration

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
  "redirectCount": 5
}
```

### `GET /admin/reload`
Reloads the redirect configuration from `redirects.json` without restarting the server.

**Response:**
```json
{
  "message": "Configuration reloaded",
  "redirectCount": 5
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