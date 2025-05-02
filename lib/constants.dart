// File: lib/constants.dart
// This file contains constants used across the application

import 'package:flutter/foundation.dart' show kIsWeb;

// Base API URL for Bored API
const String apiBaseUrl = 'https://www.boredapi.com/api';

// Endpoint for the API (append to base URL)
const String apiEndpoint = 'activity';

// Smart routing based on platform
final String apiUrl =
    kIsWeb
        ? '/api/proxy/$apiEndpoint' // Route via Globe function when on web
        : '$apiBaseUrl/$apiEndpoint'; // Direct API call on mobile

// For additional endpoints that need parameters
String getApiUrl(String path) {
  return kIsWeb ? '/api/proxy/$path' : '$apiBaseUrl/$path';
}
