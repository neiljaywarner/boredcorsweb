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

### Deploy to Netlify

1. Push your code to a GitHub repository

2. Connect to Netlify:
   - Go to [Netlify](https://app.netlify.com/)
   - Click "New site from Git"
   - Select GitHub and authorize Netlify
   - Select your repository

3. Configure build settings:
   - Build command: `flutter build web --release`
   - Publish directory: `build/web`
   - Click "Deploy site"

4. After the initial deployment:
   - Go to "Functions" in your Netlify dashboard to verify the API proxy function is working
   - Test your site by visiting the deployed URL

### How It Works

- The application automatically detects if it's running on the web and routes API requests through the Netlify function
- The `netlify.toml` file configures redirects so `/api/*` routes to the serverless function
- The function acts as a proxy, forwarding requests to ZenQuotes API and adding CORS headers to the response

### Troubleshooting

- If quotes don't load, check the browser console for CORS errors
- Verify the serverless function is deployed correctly in the Netlify dashboard
- Make sure the API endpoint in the code matches the redirect rule in `netlify.toml`