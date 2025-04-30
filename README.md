# Bored CORS Web

A Flutter web app that demonstrates handling CORS issues using Netlify Functions.

## About

This app displays random quotes from the ZenQuotes API. Since the API doesn't support CORS for
direct browser requests, we use a Netlify serverless function as a proxy to handle these requests
when deployed as a web app.

## Getting Started

Before proceeding with deployment, make sure you have all the necessary tools and accounts set up.

**[View the complete prerequisites guide](PREREQUISITES.md)**

> **Quick Start with Puro**: For faster Flutter setup, you can use [Puro](https://puro.dev/) - a
Flutter version manager. Install it with: `curl -fsSL https://get.puro.dev/install.sh | sh`

## Deployment Instructions

### For Mobile

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to test on mobile devices/emulators

### Deploy to Netlify

1. Push your code to a GitHub repository

2. Connect to Netlify:
    - Go to [Netlify](https://app.netlify.com/)
    - Click "New site from Git"
    - Select GitHub and authorize Netlify
    - Select your repository

3. The deployment will start automatically:
    - The `netlify.toml` file contains the configuration to install Flutter using Puro
    - Puro speeds up the Flutter installation process by about 20%
    - Deployment typically takes 4-8 minutes to complete

4. After the deployment is complete:
    - Test your site by visiting the deployed URL
    - To test the API proxy directly, visit `https://your-site-name.netlify.app/api/random`

## How It Works

- The application automatically detects if it's running on the web and routes API requests through
  the Netlify function
- The `netlify.toml` file configures redirects so `/api/*` routes to the serverless function
- The function in `netlify/functions/api.js` acts as a proxy, forwarding requests to ZenQuotes API
  and adding CORS headers to the response
- All API URLs are centralized in `lib/constants.dart` to make changing APIs easier

## Using with Other APIs

Want to use this CORS proxy with a different API? We've created a step-by-step guide:

**[View the next steps guide](NEXT_STEPS.md)**

This guide includes:

- How to switch to a different API
- Examples of common CORS-restricted APIs
- How to test if an API needs a CORS proxy
- Tips for customizing the UI for your specific API

## Troubleshooting

- If quotes don't load, check the browser console for CORS errors
- Verify the serverless function is deployed correctly in the Netlify dashboard
- Make sure the API endpoint in the code matches the redirect rule in `netlify.toml`