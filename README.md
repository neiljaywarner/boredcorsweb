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
   ```
   cd netlify/functions
   npm install
   cd ../..
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

- The application automatically detects if it's running on the web and routes API requests through
  the Netlify function
- The `netlify.toml` file configures redirects so `/api/*` routes to the serverless function
- The function acts as a proxy, forwarding requests to ZenQuotes API and adding CORS headers to the
  response

### Troubleshooting

- If quotes don't load, check the browser console for CORS errors
- Verify the serverless function is deployed correctly in the Netlify dashboard
- Make sure the API endpoint in the code matches the redirect rule in `netlify.toml`