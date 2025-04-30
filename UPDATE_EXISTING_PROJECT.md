# Adding CORS Handling to an Existing Flutter Project

This guide provides step-by-step instructions for adding Netlify Functions to an existing Flutter
project to handle CORS issues when calling external APIs.

## Prerequisites

- An existing Flutter project that needs to make API calls
- A GitHub repository for your project
- A Netlify account (free tier is sufficient)

## Step 1: Add Constants for API URLs

First, we'll centralize your API URLs to make them platform-aware:

1. Create a `lib/constants.dart` file if it doesn't exist:

```dart
// URL of the API you're trying to access
const String apiBaseUrl = 'https://api-domain.com';

// The specific endpoint you need
const String apiEndpoint = 'path/to/endpoint';

// Web version uses the Netlify Function proxy
const String webApiPath = '/api/${apiEndpoint}';

// Mobile version can call the API directly
const String mobileApiUrl = '$apiBaseUrl/$apiEndpoint';
```

2. Update your API calls to use these constants:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'constants.dart';

// In your API fetch method:
Future<void> fetchData() async {
  final Uri apiUrl = kIsWeb 
      ? Uri.parse(webApiPath)  // Use proxy when on web
      : Uri.parse(mobileApiUrl);  // Use direct API call on mobile
      
  final response = await http.get(apiUrl);
  // Process the response...
}
```

## Step 2: Add Netlify Configuration Files

### Create the netlify.toml File

Create a `netlify.toml` file in your project's root directory:

```toml
[build]
  command = """
    curl -fsSL https://get.puro.dev/install.sh | sh
    export PATH="$PATH:$HOME/.puro/bin"
    puro install flutter --system
    export PATH="$PATH:$HOME/.puro/envs/flutter/flutter/bin"
    flutter config --enable-web
    flutter build web --release
  """
  publish = "build/web"

[functions]
  directory = "netlify/functions"

[[redirects]]
  from = "/api/*"
  to = "/.netlify/functions/api/:splat"
  status = 200
```

### Create the Netlify Function

1. Create a directory structure for your serverless function:

```bash
mkdir -p netlify/functions
```

2. Create `netlify/functions/api.js`:

```javascript
const axios = require('axios');

// Configuration - replace with your actual API base URL
const API_BASE_URL = 'https://api-domain.com';

exports.handler = async function(event, context) {
  // Extract path parameters and query string
  const path = event.path.split('/').filter(Boolean).pop();
  const queryString = new URLSearchParams(event.queryStringParameters || {}).toString();
  const queryPart = queryString ? `?${queryString}` : '';
  
  try {
    // Build the target URL - adjust as needed for your API
    const targetUrl = `${API_BASE_URL}/${path}${queryPart}`;
    console.log(`Proxying request to: ${targetUrl}`);
    
    // Get any headers from the request that should be forwarded
    const headers = {};
    // Add auth headers if needed:
    // if (event.headers.authorization) {
    //   headers.Authorization = event.headers.authorization;
    // }
    
    // Make the request to the external API
    const response = await axios.get(targetUrl, { headers });
    
    // Return the response with CORS headers
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(response.data)
    };
  } catch (error) {
    console.error('Proxy error:', error.message);
    
    // Return error with CORS headers
    return {
      statusCode: error.response?.status || 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ 
        error: error.message,
        details: error.response?.data
      })
    };
  }
};
```

3. Create `netlify/functions/package.json`:

```json
{
  "name": "netlify-functions",
  "version": "1.0.0",
  "description": "Netlify serverless functions for CORS handling",
  "dependencies": {
    "axios": "^1.6.0"
  }
}
```

## Step 3: Update .gitignore

Make sure your .gitignore includes common Node.js and Netlify patterns:

```
# Node.js dependencies
node_modules/
npm-debug.log

# Netlify
.netlify/
```

## Step 4: Deploy to Netlify

1. Commit and push your changes to GitHub

2. Log in to Netlify and create a new site:
    - Click "Add new site" > "Import an existing project"
    - Choose GitHub as your Git provider
    - Select your repository
    - The settings should be auto-detected from your netlify.toml

3. Wait for the deployment to complete (5-10 minutes)

4. Test your deployed site:
    - Visit the Netlify-generated URL
    - Test the API endpoint directly: `https://your-site-name.netlify.app/api/your-endpoint`

## Step 5: Test and Debug

### Common Issues

1. **CORS errors still present**: Check that you're using the correct path (`/api/...`) in your web
   app

2. **Function not found**: Make sure:
    - The `api.js` file is in the correct location
    - Your netlify.toml has the correct [functions] directory

3. **API data not loading**: Check:
    - The browser console for errors
    - Netlify Function logs in the Netlify dashboard
    - That the paths in the API function match your API's requirements

## Advanced Configuration

### Adding Authentication

If your API requires authentication, modify the API function:

```javascript
// In the api.js file:
exports.handler = async function(event, context) {
  // ... existing code ...
  
  try {
    // Add API key or other auth
    const headers = {
      'Authorization': 'Bearer YOUR_API_KEY',
      // Or read from environment variables:
      // 'Authorization': `Bearer ${process.env.API_KEY}`
    };
    
    const response = await axios.get(targetUrl, { headers });
    // ... rest of function ...
  }
};
```

For environment variables, add them in the Netlify dashboard under Site settings > Build & deploy >
Environment.

### Supporting Multiple Endpoints

To support multiple API endpoints, enhance your `api.js`:

```javascript
exports.handler = async function(event, context) {
  const endpoint = event.path.split('/')[2]; // /api/endpoint1/path -> endpoint1
  
  // Different base URLs for different endpoints
  const API_URLS = {
    'users': 'https://users-api.example.com',
    'products': 'https://products-api.example.com',
    'default': 'https://default-api.example.com'
  };
  
  const baseUrl = API_URLS[endpoint] || API_URLS.default;
  // ... rest of function ...
};
```

## Open Source Considerations

This project can be 100% open source and publicly available as it:

1. Contains no proprietary code or algorithms
2. Uses widely available open source libraries
3. Implements a common pattern for CORS handling
4. Contains no API keys or sensitive information in the committed code

Remember to:

- Never commit API keys or sensitive credentials - use environment variables
- Add proper open source licensing (MIT, Apache, etc.) to your repository
- Credit any third-party libraries or resources used

## License

When making your project public, consider adding a standard open source license like MIT:

```
MIT License

Copyright (c) [year] [your name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```