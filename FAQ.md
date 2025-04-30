# Frequently Asked Questions (FAQ)

## Understanding CORS

### What is CORS?

CORS (Cross-Origin Resource Sharing) is a security feature implemented by web browsers that
restricts web pages from making requests to a different domain than the one that served the web
page. This security measure helps prevent various types of attacks, including cross-site request
forgery.

### Why do I encounter CORS errors?

CORS errors occur when:

1. Your web application tries to make an API request to a domain different from where your app is
   hosted
2. The API server doesn't explicitly allow requests from your domain by sending proper CORS headers
3. The browser, following security protocols, blocks these requests

For example, if your app hosted at `example.com` tries to fetch data from `api.someservice.com`, the
request will be blocked unless `api.someservice.com` specifically allows requests from
`example.com`.

### How does CORS affect Flutter web apps?

Flutter web apps run in the browser, so they're subject to the same CORS restrictions as any
JavaScript application. While Flutter mobile apps can make direct API calls to any endpoint, Flutter
web apps cannot unless the API server includes the proper CORS headers.

## Serverless Functions

### What are serverless functions?

Serverless functions are single-purpose, stateless, cloud-executed functions that run on-demand
without requiring you to manage the underlying server infrastructure. They automatically scale based
on usage and you only pay for the compute time you consume.

### How do serverless functions help with CORS?

Serverless functions run on the server side, not in the browser, so they aren't subject to CORS
restrictions. By creating a serverless function that acts as a proxy:

1. Your web app makes a request to your serverless function (same domain, no CORS issues)
2. The serverless function makes the request to the external API
3. The function adds CORS headers to the response before sending it back to your web app

This approach creates a "bridge" between your web app and APIs that don't support CORS.

## TOML Files

### What are TOML files?

TOML (Tom's Obvious, Minimal Language) is a configuration file format designed to be easy to read
and write. It was created by Tom Preston-Werner (co-founder of GitHub) in 2013 as an alternative to
more complex formats like JSON and YAML.

### Why is it called TOML?

The name "TOML" stands for "Tom's Obvious, Minimal Language," named after its creator, Tom
Preston-Werner. The format aims to be obvious in its intent and minimal in its syntax.

### How is TOML different from YAML?

TOML offers several advantages over YAML:

1. **Less ambiguity**: TOML has clearer syntax rules with fewer edge cases
2. **Simpler indentation**: TOML doesn't rely on significant whitespace for structure
3. **Clear data types**: TOML explicitly defines data types
4. **Better for configuration**: TOML focuses specifically on being a configuration language

Example of TOML vs YAML:

TOML:

```toml
[server]
host = "example.com"
port = 8080

[database]
username = "admin"
enabled = true
```

YAML:

```yaml
server:
  host: example.com
  port: 8080
database:
  username: admin
  enabled: true
```

## Hosting Options for Flutter Web with CORS Solutions

### Why did we choose Netlify?

We chose Netlify for this project because:

1. **Integrated serverless functions**: Netlify Functions are built in and easy to configure
2. **Simple deployment workflow**: Direct GitHub integration with automatic builds
3. **Free tier generous limits**: 125,000 function invocations per month on the free plan
4. **Fast global CDN**: Great performance for static assets worldwide
5. **Simple configuration**: The netlify.toml file provides a clean way to configure everything in
   one place

### What are other hosting options?

#### Firebase Hosting + Cloud Functions

**Pros:**

- Deep integration with other Firebase services (Authentication, Firestore, etc.)
- Good free tier (1GB storage, 10GB/month transfer, 125K/month Cloud Function invocations)
- Google infrastructure and reliability

**Cons:**

- More complex setup for Cloud Functions
- Cloud Functions can be slower to cold start than Netlify Functions
- Requires separate configuration for hosting and functions

**When to choose Firebase:**

- Your app already uses other Firebase services
- You need to leverage the Google Cloud ecosystem
- You need more advanced authentication or database features

#### Vercel

**Pros:**

- Excellent developer experience
- Fast builds and deployments
- Good integration with Next.js (if using it with Flutter)
- Serverless functions included

**Cons:**

- Free tier has more limited function execution time
- Better suited for Next.js projects than vanilla Flutter

**When to choose Vercel:**

- Building a hybrid app with Next.js + Flutter
- You prefer their developer experience
- You need multiple preview environments

#### AWS Amplify + Lambda

**Pros:**

- Full AWS ecosystem access
- Highly scalable
- More control over configuration

**Cons:**

- More complex to set up and maintain
- Steeper learning curve
- Can be more expensive for small projects

**When to choose AWS:**

- Need for advanced security or compliance requirements
- Already using AWS services
- Need more control over the infrastructure

#### Globe.dev (Dart-Native Backend Platform)

**Pros:**

- **Fully Dart-native backend platform** specifically built for Flutter developers
- Simpler setup process compared to Appwrite or Firebase
- No context switching between languages - write all code in Dart
- Streamlined developer experience with minimal configuration
- Good integration with existing Flutter workflows

**Cons:**

- Relatively new platform with smaller community
- Less comprehensive documentation compared to established alternatives
- Fewer third-party integrations available

**When to choose Globe.dev:**

- You want the simplest possible setup for a Dart-based backend
- You prioritize developer experience over extensive feature sets
- You prefer a solution built specifically for Flutter developers
- You want to avoid configuration complexity

#### Appwrite (Dart Functions Support)

**Pros:**

- **Supports serverless functions in Dart** - write both your app and functions in the same language
- Open source and can be self-hosted or used with Appwrite Cloud
- Comprehensive backend-as-a-service with authentication, database, storage, etc.
- Strong Flutter integration

**Cons:**

- Newer platform with smaller community than Firebase or AWS
- Self-hosting requires more setup and maintenance
- Cloud offering still maturing

**When to choose Appwrite:**

- You want to write your serverless functions in Dart
- You prefer consistency with one language across frontend and backend
- You value open-source solutions
- You need an integrated backend platform specifically designed for Flutter

#### Supabase

**Pros:**

- Excellent PostgreSQL database with real-time capabilities
- Open source alternative to Firebase
- Edge Functions support (but in JavaScript/TypeScript, not Dart)
- Great authentication system

**Cons:**

- Edge Functions don't support Dart (only JavaScript/TypeScript/Python)
- More focused on database features than general serverless compute

**When to choose Supabase:**

- Your application is database-centric
- You prefer SQL over NoSQL
- You need real-time database capabilities
- You're comfortable writing Edge Functions in JavaScript/TypeScript

## Can I implement the same CORS solution using Dart?

Yes, with Dart-based platforms like Appwrite or Globe.dev, you can implement the same CORS proxy
pattern entirely in Dart.

### Example with Appwrite:

```dart
import 'dart:convert';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:http/http.dart' as http;

// Main function for handling Appwrite function execution
Future<void> start(final req, final res) async {
  // Extract path from the request
  final path = req.path ?? 'random';
  
  // Build target URL for the API
  final targetUrl = 'https://zenquotes.io/api/$path';
  
  try {
    // Make the request to the external API
    final response = await http.get(Uri.parse(targetUrl));
    
    // Set CORS headers
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    
    // Return the response
    res.json(json.decode(response.body));
  } catch (e) {
    // Handle errors
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    res.status(500).json({
      'error': e.toString()
    });
  }
}
```

### Globe.dev Simplified Approach:

Globe.dev makes the process even simpler with its more streamlined API:

```dart
import 'dart:convert';
import 'package:globe/globe.dart';
import 'package:http/http.dart' as http;

@Route.get('/api/:path')
Future<Response> proxyRequest(Request request, String path) async {
  final targetUrl = 'https://zenquotes.io/api/$path';
  
  try {
    final response = await http.get(Uri.parse(targetUrl));
    
    // Return the response with CORS headers
    return Response.json(
      json.decode(response.body),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  } catch (e) {
    return Response.json(
      {'error': e.toString()},
      statusCode: 500,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  }
}
```

These approaches allow you to maintain a consistent Dart codebase across your Flutter application
and serverless functions.

## General Questions

### Is this approach production-ready?

Yes, using serverless functions as a CORS proxy is a standard pattern for production applications.
The approach we've implemented:

- Is scalable (serverless functions automatically scale)
- Is cost-effective (pay only for what you use, with generous free tiers)
- Provides proper error handling
- Can be extended to include authentication and other security measures

### Will this approach work for any API?

Yes, this approach will work for virtually any HTTP-based API. The proxy function makes server-side
requests that aren't subject to CORS restrictions. You may need to customize the function for
specific APIs that:

1. Require special authentication headers
2. Use non-standard HTTP methods
3. Have rate limiting that might be affected by proxying

### How much will this cost me?

For most small to medium applications, you can stay within the free tier limits:

- Netlify Free tier: 125K function invocations per month
- Firebase Free tier: 125K function invocations per month
- Vercel Hobby tier: 100 serverless function invocations per day
- Appwrite Cloud: Free tier with 500K function executions
- Globe.dev: Free tier available with usage-based limits

If your application grows beyond these limits, costs will scale based on usage, but typically remain
reasonable for most applications.