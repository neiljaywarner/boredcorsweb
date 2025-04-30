# Next Steps: Using This App with Different APIs

This guide will help you adapt the app to use a different API that has CORS restrictions.

## Demonstrating CORS Issues: XKCD API Example

Let's use the XKCD API, which has CORS restrictions when accessed directly from browsers but
requires no signup or API key.

### 1. First, Show the CORS Error

The easiest way to demonstrate the CORS issue is by running the Flutter app locally with Chrome:

```bash
# Run the Flutter app in Chrome
flutter run -d chrome
```

When you modify the app to use the XKCD API directly, you'll see CORS errors in the Chrome DevTools
console (F12). The browser blocks the request because XKCD doesn't include the necessary CORS
headers.

### 2. Solving the CORS Issue with Our App

Now, let's adapt our Flutter app to use the XKCD API via our Netlify function.

#### Update the Constants

Edit the `lib/constants.dart` file:

```dart
// Change from ZenQuotes to XKCD
const String apiBaseUrl = 'https://xkcd.com';

// Change endpoint to a specific comic - in this example, comic #614
const String apiEndpoint = '614/info.0.json';

// Keep these lines unchanged
const String webApiPath = '/api/${apiEndpoint}';
const String mobileApiUrl = '$apiBaseUrl/$apiEndpoint';
```

#### Update the Netlify Function

Edit the `netlify/functions/api.js` file:

```javascript
const axios = require('axios');

/**
 * Netlify function to proxy API requests and handle CORS issues.
 */

// API configuration - XKCD base URL
const API_BASE_URL = 'https://xkcd.com';

exports.handler = async function(event, context) {
  // Extract path parameters
  let path = event.path.split('/').filter(Boolean).pop();
  
  // If no specific path or just "api", default to comic #614
  if (!path || path === 'api') {
    path = '614/info.0.json';
  }
  // If it's numeric, assume it's a comic number and format appropriately
  else if (!isNaN(parseInt(path))) {
    path = `${path}/info.0.json`;
  }
  
  try {
    // Build the target API URL
    const targetUrl = `${API_BASE_URL}/${path}`;
    console.log(`Proxying request to: ${targetUrl}`);
    
    // Forward the request to the API
    const response = await axios.get(targetUrl);
    
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
    console.error('Proxy error:', error.message);
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
};
```

#### Update the App's Data Display

Edit the `lib/main.dart` file:

```dart
Future<void> _fetch() async {
  setState(() => _loading = true);
  final Uri apiUrl = kIsWeb 
    ? Uri.parse(webApiPath)
    : Uri.parse(mobileApiUrl);

  try {
    final r = await http.get(apiUrl);
    final d = jsonDecode(r.body);
    
    setState(() {
      // XKCD API returns comic info
      _q = "${d['title']} (${d['year']})\n${d['alt']}";
      _loading = false;
    });
  } catch (e) {
    setState(() {
      _q = "Error: ${e.toString()}";
      _loading = false;
    });
  }
}
```

### 3. Deploy and Test

After deploying to Netlify:

1. Visit your deployed site: `https://your-site-name.netlify.app/`
2. You should see the XKCD comic information
3. Test the API proxy directly: `https://your-site-name.netlify.app/api/614`
4. Try a different comic: `https://your-site-name.netlify.app/api/327`

> **Note for first-time Netlify users**: When you deploy for the first time, Netlify will assign a
random subdomain name like `eager-einstein-123abc.netlify.app`. You can customize this name in the
site settings by clicking on "Domain settings" after deployment.

> **Tip**: If you're new to Netlify, don't worry - the deployment process is straightforward. The UI
will guide you through connecting your GitHub account and selecting your repository. All the
necessary build settings are already in your `netlify.toml` file.

## Common CORS-Restricted APIs

Here are some other APIs that typically have CORS restrictions and would benefit from this proxy
approach:

1. **No Authentication Required**:
    - XKCD API (as shown in our example)
    - NASA APOD (Astronomy Picture of the Day)
    - Reddit JSON API

2. **Requires Authentication**:
    - OpenWeatherMap
    - Alpha Vantage (financial data)
    - Twitter API

3. **Other APIs**:
    - Many government data APIs
    - Various news APIs
    - Sports data APIs

## FAQ and Troubleshooting

### How to Test CORS Issues Locally with Flutter

Testing CORS issues locally is easy with Flutter's built-in web server:

1. **Run the Flutter app in Chrome**:
   ```bash
   flutter run -d chrome
   ```

2. **Observe the CORS error**:
    - Open Chrome DevTools (F12 or right-click > Inspect)
    - Go to the Console tab
    - You'll see CORS errors when the app attempts to fetch from the API directly

3. **Test API calls directly in the browser console**:
   ```javascript
   // Try this in the Chrome DevTools console
   fetch('https://xkcd.com/614/info.0.json')
     .then(response => response.json())
     .then(data => console.log(data))
     .catch(error => console.error('CORS Error:', error));
   ```

### Why Do CORS Issues Happen?

CORS (Cross-Origin Resource Sharing) issues happen because browsers implement a security feature
that prevents a web page from making requests to a different domain than the one that served the
page. This is to protect users from certain types of attacks.

For an API to allow cross-origin requests, it needs to include special headers like
`Access-Control-Allow-Origin`. If the API provider doesn't include these headers (like XKCD),
browsers will block the requests when made directly from client-side JavaScript.

### Why Does the Netlify Function Approach Work?

The Netlify Function approach works because:

1. The proxy function runs server-side, not in the browser
2. Server-side requests aren't subject to CORS restrictions
3. Our function adds the necessary CORS headers to the response
4. The browser sees these headers and allows the response through

It's essentially a "man in the middle" that relays messages between your app and the restricted API.

### Common Issues for New Netlify Users

1. **Function not found**: If you get a "Function not found" error, make sure that:
    - Your `netlify.toml` file has the correct `functions` directory specified
    - The function file (`api.js`) is in the correct location (`netlify/functions/api.js`)

2. **Build failures**: If your build fails, check the Netlify logs. Common issues include:
    - Missing dependencies (our setup handles Flutter installation automatically)
    - Syntax errors in your code

3. **Custom domains**: Once your site is working, you can add a custom domain in the Netlify site
   settings

## Customizing for Different APIs

When adapting this template for different APIs, consider these adjustments:

1. Update the UI to appropriately display the specific data your API provides
2. Add proper error handling for API-specific errors
3. Consider adding authentication if your chosen API requires it
4. Create a more full-featured UI with search or pagination for APIs that support it

By following these steps, you can adapt this template to work with virtually any API that has CORS
restrictions.