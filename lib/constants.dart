// File: lib/constants.dart
// This file contains constants used across the application

// Base API URL for ZenQuotes - used both in the app and the Netlify function
// If you change this to a different API, update it here and in the netlify/functions/api.js file
const String apiBaseUrl = 'https://zenquotes.io/api';

// Endpoint for the API (append to base URL)
const String apiEndpoint = 'random';

// Local API path for web (uses Netlify function proxy)
const String webApiPath = '/api/${apiEndpoint}';

// Direct API URL for mobile
const String mobileApiUrl = '$apiBaseUrl/$apiEndpoint';
