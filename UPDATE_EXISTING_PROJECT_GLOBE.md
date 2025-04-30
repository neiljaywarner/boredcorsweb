# Update Existing Flutter Project with Globe.dev for CORS Proxy & Web Hosting

This guide will help you quickly add Globe.dev serverless functions to handle CORS issues in an
existing Flutter web project and deploy the Flutter web app directly to Globe.dev for a complete
single-service solution.

## Quick Start

### 1. Add Constants for API Routing

Create or update `lib/constants.dart` with:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

// Replace with your actual API URL
const String apiBaseUrl = 'https://your-api.com';

// Replace with your API endpoint
const String apiEndpoint = 'endpoint';

// Smart routing based on platform
final String apiUrl = kIsWeb 
    ? '/api/proxy/$apiEndpoint' // Route via Globe function when on web
    : '$apiBaseUrl/$apiEndpoint'; // Direct API call on mobile

// For additional endpoints that need parameters
String getApiUrl(String path) {
  return kIsWeb
      ? '/api/proxy/$path'
      : '$apiBaseUrl/$path';
}
```

### 2. Update API Calls in Your App

```dart
import 'package:http/http.dart' as http;
import 'constants.dart';

Future<void> fetchData() async {
  // Use the platform-aware URL from constants
  final response = await http.get(Uri.parse(apiUrl));
  
  // Process response...
}
```

### 3. Create Globe.dev Function

Create a file `.globe/functions/proxy.dart`:

```dart
import 'dart:convert';
import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

// Change this to your API base URL
const apiBaseUrl = 'https://your-api.com';

@CloudFunction()
Future<Response> proxyFunction(Request request) async {
  // Get path from request
  final path = request.url.pathSegments.skip(1).join('/');
  
  // Handle query parameters
  String queryString = '';
  if (request.url.hasQuery) {
    queryString = '?${request.url.query}';
  }
  
  // Build target URL
  final targetUrl = '$apiBaseUrl/$path$queryString';
  
  try {
    // Forward request to actual API
    final response = await http.get(Uri.parse(targetUrl));
    
    // Return response with CORS headers
    return Response(
      response.statusCode,
      body: response.body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  } catch (e) {
    // Handle errors
    return Response(
      500,
      body: jsonEncode({'error': e.toString()}),
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    );
  }
}
```

### 4. Create Globe.dev Configuration

Create a file `.globe/globe.toml`:

```toml
# API routes
[routes]
"/api/proxy/*" = "proxy"

# Web app configuration
[web]
directory = "web"
```

### 5. Initialize Globe Project (One-time Setup)

```bash
# Install Globe CLI
dart pub global activate globe_cli

# Login to Globe
globe login

# Initialize Globe in your project directory
globe init
```

Choose "Both" when asked about project type to set up both backend and frontend.

### 6. Add GitHub Actions Workflow

Create a file `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Globe.dev

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Dart
        uses: dart-lang/setup-dart@v1
      
      - name: Install Globe CLI
        run: dart pub global activate globe_cli
      
      - name: Login to Globe.dev
        run: echo "${{ secrets.GLOBE_TOKEN }}" | globe login --token-stdin
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
          channel: 'stable'
      
      - name: Build Web
        run: |
          flutter config --enable-web
          flutter build web --release
      
      - name: Deploy to Globe.dev
        run: |
          # Copy web build to the Globe project's web directory
          mkdir -p .globe/web
          cp -r build/web/* .globe/web/
          
          # Deploy the entire Globe project (both web and functions)
          cd .globe
          globe deploy
```

### 7. Set Up Globe.dev Token in GitHub

1. Generate a token from the Globe CLI:
   ```bash
   globe token
   ```

2. Add the token to GitHub:
    - Go to your GitHub repository → Settings → Secrets → Actions
    - Add a new secret named `GLOBE_TOKEN` with the token value

### 8. Push and Deploy

Commit all changes and push to your main branch:

```bash
git add .
git commit -m "Add Globe.dev for serverless functions and web hosting"
git push origin main
```

The GitHub Action will automatically deploy both your serverless function and web app to Globe.dev.

## Verifying the Setup

After deployment completes, you'll have:

1. Your Flutter web app hosted at: `https://yourproject.globe.dev/`
2. Your serverless function at: `https://yourproject.globe.dev/api/proxy/...`

### No Need to Update Base URLs

Since both the web app and serverless function are hosted on the same domain, you don't need to
modify any URLs in your code. The relative paths `/api/proxy/...` will automatically resolve to your
Globe.dev domain.

## Testing Locally

Test the entire setup locally before deploying:

```bash
# Run Globe dev server (from .globe directory)
cd .globe
globe dev

# In another terminal, run Flutter web app in debug mode
flutter run -d chrome --web-port=8080
```

## FAQ

### How does this solution compare to other providers?

Globe.dev offers these unique benefits:

- **Single platform** for both hosting and serverless functions
- **Dart-native backend** - write all code in Dart
- **Simpler configuration** than Firebase, AWS, or Netlify
- **Perfect for Flutter apps** as it's designed with Flutter developers in mind
- **Same-domain hosting** eliminates CORS issues entirely

### Do I need to modify existing code?

Minimal changes are required:

- Add constants for URL routing
- Update API calls to use the constants
- No changes to UI code or business logic

### Can I use custom domains?

Yes! Globe.dev supports custom domains. After deployment, go to the Globe dashboard and add your
domain in the settings.

### What if I need other backend services?

Globe.dev functions can integrate with:

- Databases like Firebase, Supabase, or any REST API
- Authentication providers
- Storage services
- Email services
- Any API accessible via HTTP

### How do I handle authentication?

Your Globe function can forward authentication headers:

```dart
// In your proxy.dart file
final headers = <String, String>{};
if (request.headers.containsKey('authorization')) {
  headers['Authorization'] = request.headers['authorization']!;
}

final response = await http.get(Uri.parse(targetUrl), headers: headers);
```