# Transform a Flutter Counter App into an XKCD Comic Viewer with Globe.dev

This guide will show you how to transform the default Flutter counter app into an XKCD comic viewer
that works on both web and mobile. We'll use Globe.dev to create a Dart-based serverless function
that handles CORS issues for web deployments.

I've chosen Globe.dev as it's the simplest solution for Flutter developers:

- Fully Dart-native platform (no JavaScript required)
- Minimal configuration needed
- Designed specifically for Flutter developers
- Streamlined developer experience

## Prerequisites

Before you begin, you'll need to:

1. Have Flutter installed
2. Have a GitHub account
3. Sign up for a Globe.dev account
4. Install the Globe CLI

## Step 1: Set Up Globe.dev Account and CLI

1. Visit [Globe.dev](https://www.globe.dev/) and sign up for a free account
2. Install the Globe CLI:

```bash
dart pub global activate globe_cli
```

3. Authenticate with your Globe account:

```bash
globe login
```

## Step 2: Transform the Counter App to XKCD Viewer

### Step 2.1: Update pubspec.yaml

Add the necessary dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_dotenv: ^5.1.0
  cached_network_image: ^3.3.0
  url_launcher: ^6.2.1
```

### Step 2.2: Create a Constants File

Create a new file at `lib/constants.dart`:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

// XKCD API constants
const String apiBaseUrl = 'https://xkcd.com';
const String apiEndpoint = 'info.0.json';

// Web uses Globe.dev proxy, mobile calls directly
final String apiUrl = kIsWeb 
    ? '/api/xkcd/latest' // Globe function route 
    : '$apiBaseUrl/$apiEndpoint'; // Direct API call

// For specific comics
String getComicUrl(int comicId) {
  return kIsWeb
      ? '/api/xkcd/$comicId'  // Globe function route with comic ID
      : '$apiBaseUrl/$comicId/$apiEndpoint'; // Direct API with comic ID
}
```

### Step 2.3: Create Comic Model

Create a file `lib/models/comic.dart`:

```dart
class Comic {
  final int num;
  final String title;
  final String alt;
  final String img;
  final String year;
  final String month;
  final String day;

  Comic({
    required this.num,
    required this.title,
    required this.alt,
    required this.img,
    required this.year,
    required this.month,
    required this.day,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      num: json['num'] as int,
      title: json['title'] as String,
      alt: json['alt'] as String,
      img: json['img'] as String,
      year: json['year'] as String,
      month: json['month'] as String,
      day: json['day'] as String,
    );
  }
}
```

### Step 2.4: Create Comic Service

Create a file `lib/services/comic_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comic.dart';
import '../constants.dart';

class ComicService {
  // Fetch the latest comic
  Future<Comic> getLatestComic() async {
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      return Comic.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load comic: ${response.statusCode}');
    }
  }
  
  // Fetch a specific comic by ID
  Future<Comic> getComic(int id) async {
    final response = await http.get(Uri.parse(getComicUrl(id)));
    
    if (response.statusCode == 200) {
      return Comic.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load comic: ${response.statusCode}');
    }
  }
  
  // Fetch a random comic
  Future<Comic> getRandomComic() async {
    // First get the latest comic to know the max number
    final latest = await getLatestComic();
    
    // Generate a random number between 1 and the latest comic number
    final randomId = 1 + (DateTime.now().millisecondsSinceEpoch % latest.num);
    
    // Fetch that comic
    return getComic(randomId);
  }
}
```

### Step 2.5: Replace Main.dart

Replace `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/comic.dart';
import 'services/comic_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XKCD Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const XkcdPage(),
    );
  }
}

class XkcdPage extends StatefulWidget {
  const XkcdPage({super.key});

  @override
  State<XkcdPage> createState() => _XkcdPageState();
}

class _XkcdPageState extends State<XkcdPage> {
  final ComicService _comicService = ComicService();
  Comic? _currentComic;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestComic();
  }

  Future<void> _loadLatestComic() async {
    setState(() {
      _loading = true;
    });
    
    try {
      final comic = await _comicService.getLatestComic();
      setState(() {
        _currentComic = comic;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading comic: $e')),
        );
      }
    }
  }

  Future<void> _loadRandomComic() async {
    setState(() {
      _loading = true;
    });
    
    try {
      final comic = await _comicService.getRandomComic();
      setState(() {
        _currentComic = comic;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading comic: $e')),
        );
      }
    }
  }

  Future<void> _loadPreviousComic() async {
    if (_currentComic == null || _currentComic!.num <= 1) return;
    
    setState(() {
      _loading = true;
    });
    
    try {
      final comic = await _comicService.getComic(_currentComic!.num - 1);
      setState(() {
        _currentComic = comic;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading comic: $e')),
        );
      }
    }
  }

  Future<void> _loadNextComic() async {
    if (_currentComic == null) return;
    
    setState(() {
      _loading = true;
    });
    
    try {
      final comic = await _comicService.getComic(_currentComic!.num + 1);
      setState(() {
        _currentComic = comic;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: This might be the latest comic')),
        );
      }
    }
  }

  void _showAltText() {
    if (_currentComic == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentComic!.title),
        content: Text(_currentComic!.alt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('XKCD Comic Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _currentComic != null ? _showAltText : null,
            tooltip: 'Show alt text',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: _currentComic != null
                ? () => launchUrl(Uri.parse('https://xkcd.com/${_currentComic!.num}'))
                : null,
            tooltip: 'Open in browser',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentComic == null
              ? const Center(child: Text('No comic loaded'))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '#${_currentComic!.num}: ${_currentComic!.title}',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Published: ${_currentComic!.year}-${_currentComic!.month}-${_currentComic!.day}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _showAltText,
                        child: CachedNetworkImage(
                          imageUrl: _currentComic!.img,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tap image to show alt text',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.first_page),
              onPressed: () => _comicService.getComic(1).then((comic) {
                setState(() {
                  _currentComic = comic;
                });
              }),
              tooltip: 'First comic',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _loadPreviousComic,
              tooltip: 'Previous comic',
            ),
            IconButton(
              icon: const Icon(Icons.shuffle),
              onPressed: _loadRandomComic,
              tooltip: 'Random comic',
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _loadNextComic,
              tooltip: 'Next comic',
            ),
            IconButton(
              icon: const Icon(Icons.last_page),
              onPressed: _loadLatestComic,
              tooltip: 'Latest comic',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Step 3: Create Globe.dev Serverless Function

### Step 3.1: Initialize Globe Project

In your project root directory:

```bash
globe init
```

Select the following options:

- Project name: xkcd-proxy
- Choose "Backend" for the project type
- Choose "Yes" for using this directory

### Step 3.2: Create XKCD Proxy Function

Create a file `globe/functions/xkcd_proxy.dart`:

```dart
import 'dart:convert';
import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> xkcdProxy(Request request) async {
  // Parse the path parameter to get the comic ID
  final path = request.url.pathSegments;
  String comicId = '';
  
  if (path.length >= 2 && path[0] == 'xkcd') {
    comicId = path[1];
  }
  
  // Build the target URL based on the path
  final String targetUrl;
  if (comicId == 'latest') {
    // Latest comic
    targetUrl = 'https://xkcd.com/info.0.json';
  } else {
    // Specific comic
    targetUrl = 'https://xkcd.com/$comicId/info.0.json';
  }
  
  try {
    // Make the request to the external API
    final response = await http.get(Uri.parse(targetUrl));
    
    // Return the response with CORS headers
    return Response(
      response.statusCode,
      body: response.body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
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
        'Access-Control-Allow-Methods': 'GET, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
  }
}
```

### Step 3.3: Configure Routes

Update the `globe.toml` file (created during `globe init`):

```toml
[routes]
"/api/xkcd/:comicId" = "xkcd_proxy"
```

## Step 4: Deploy to Globe.dev

Deploy your serverless function:

```bash
globe deploy
```

This will deploy your function and give you a URL like:
`https://yourproject.globe.dev/api/xkcd/latest`

## Step 5: Update Web Configuration

Create a file `web/index.html` (or update if it exists) and add this in the `<head>` section:

```html
<head>
  <!-- Existing head content -->
  
  <!-- Configure API URL for web -->
  <script>
    window.flutterWebApiBaseUrl = "https://yourproject.globe.dev"; // Replace with your Globe.dev URL
  </script>
</head>
```

## Step 6: Final Testing and Deployment

### Build for Web

```bash
flutter build web --release
```

### Deploy to Web Hosting (optional)

You can deploy the built web app to any web hosting service like Firebase Hosting, GitHub Pages, or
Netlify.

Example for Firebase:

```bash
firebase init hosting
firebase deploy
```

### Run Locally

For mobile:

```bash
flutter run
```

For web:

```bash
flutter run -d chrome
```

## Troubleshooting

### CORS Issues Persist

- Make sure your Globe.dev function is properly deployed
- Verify that the CORS headers are being set correctly
- Check the browser console for specific error messages

### Comic Not Loading

- Ensure your Globe.dev function URL is correct in the constants file
- Check if the XKCD API is responding correctly
- Try loading a specific comic ID rather than the latest

## Resources

- [Globe.dev Documentation](https://docs.globe.dev)
- [Flutter Web Documentation](https://flutter.dev/docs/platform-integration/web)
- [XKCD API Documentation](https://xkcd.com/json.html)

## Next Steps

- Add offline support with caching
- Implement search functionality
- Add bookmarking favorite comics
- Create a PWA for better web experience