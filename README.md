# Bored CORS Web

A Flutter web app that demonstrates handling CORS issues using Netlify Functions.

## About

This app displays random quotes from the ZenQuotes API. Since the API doesn't support CORS for
direct browser requests, we use a Netlify serverless function as a proxy to handle these requests
when deployed as a web app.

## Getting Started

Before proceeding with deployment, make sure you have all the necessary tools and accounts set up.

**[View the complete prerequisites guide](PREREQUISITES.md)**

## Deployment Instructions

### Local Development

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. For mobile: Run `flutter run` to test on mobile devices/emulators
4. For web with Netlify Dev:

   **Prerequisites**:
    - Make sure you have the [Netlify CLI](https://docs.netlify.com/cli/get-started/) installed (
      `npm install netlify-cli -g`)

   **Setup**:
   ```bash
   # First, make sure the netlify/functions directory exists
   mkdir -p netlify/functions
   
   # Navigate to the functions directory
   cd netlify/functions
   
   # Create package.json if it doesn't exist
   [ ! -f package.json ] && echo '{
     "name": "netlify-functions",
     "version": "1.0.0",
     "description": "Netlify serverless functions for CORS handling",
     "dependencies": {
       "axios": "^1.6.0"
     }
   }' > package.json
   
   # Create api.js if it doesn't exist
   [ ! -f api.js ] && echo 'const axios = require("axios");

exports.handler = async function(event, context) {
// Extract path parameters
const path = event.path.split("/").filter(Boolean).pop();

try {
// Forward the request to zenquotes API
const response = await axios.get(`https://zenquotes.io/api/${path || "random"}`);

    // Return the response with CORS headers
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(response.data)
    };

} catch (error) {
// Handle errors
return {
statusCode: error.response?.status || 500,
headers: {
"Access-Control-Allow-Origin": "*",
"Access-Control-Allow-Headers": "Content-Type",
"Content-Type": "application/json"
},
body: JSON.stringify({ error: error.message })
};
}
};' > api.js

# Install dependencies

npm install

# Return to project root

cd ../..

# Start Netlify dev server

netlify dev

   ```
   
   **What the Netlify dev server does**:
   
   The Netlify dev server:
   - Creates a local development environment that mimics the Netlify production environment
   - Automatically detects and runs your project (in this case, it builds and serves the Flutter web app)
   - Makes your serverless functions available locally at `/.netlify/functions/[function-name]`
   - Processes the redirect rules in your `netlify.toml` file (mapping `/api/*` to the serverless function)
   
   **Accessing your local app**:
   
   After running `netlify dev`:
   1. The terminal will show a URL (usually `http://localhost:8888`)
   2. Open this URL in your browser to access your Flutter web app
   3. The app will automatically use the local Netlify function to handle API requests
   4. You can also test the function directly at `http://localhost:8888/api/random`
   
   **Stopping the server**:
   
   Press `Ctrl+C` in the terminal to stop the Netlify dev server.

### Deploy to Netlify

1. Push your code to a GitHub repository

2. Connect to Netlify:
   - Go to [Netlify](https://app.netlify.com/)
   - Click "New site from Git"
   - Select GitHub and authorize Netlify
   - Select your repository

3. **No need to configure build settings manually**:
   - The `netlify.toml` file in the repository already contains the necessary build configuration
   - It will automatically install Flutter during the build process
   - The build script will configure Flutter for web and build the release version
   - Deployment typically takes 5-10 minutes because it needs to download and set up Flutter

4. After the deployment is complete:
   - Go to "Functions" in your Netlify dashboard to verify the API proxy function is working
   - Test your site by visiting the deployed URL
   - To test the API proxy directly, visit `https://your-site-name.netlify.app/api/random`

### Understanding the Build Process

The `netlify.toml` file contains a multi-line build command that:
1. Clones the Flutter SDK from GitHub (stable branch)
2. Adds Flutter to the PATH
3. Pre-caches Flutter dependencies
4. Enables web support
5. Builds the Flutter web app in release mode

This approach ensures that Flutter is properly installed in the Netlify build environment.

### How It Works

- The application automatically detects if it's running on the web and routes API requests through the Netlify function
- The `netlify.toml` file configures redirects so `/api/*` routes to the serverless function
- The function acts as a proxy, forwarding requests to ZenQuotes API and adding CORS headers to the response

### Troubleshooting

- If quotes don't load, check the browser console for CORS errors
- Verify the serverless function is deployed correctly in the Netlify dashboard
- Make sure the API endpoint in the code matches the redirect rule in `netlify.toml`