# Globe.dev CORS Demo - Loom Recording Script

This guide provides a script for a quick (~5-7 minute) Loom video demonstrating how to create a new
Flutter app, add CORS handling using Globe.dev (for both hosting and functions), and deploy it
automatically via GitHub Actions.

**Goal**: Show the easiest path for a Flutter developer to deploy a web app that calls a
CORS-restricted API.

## Preparation (Before Recording)

1. **Open Apps**: Have Android Studio (or VS Code), a web browser, and a terminal ready.
2. **Loom Ready**: Have Loom installed and ready to record.

## Recording Script

**(Start Loom Recording - Screen + Microphone)**

### 1. Introduction & Project Creation (~1 minute)

* **Narration**: "Hi! Today I'll show you the absolute quickest way to create a Flutter web app that
  calls an external API, like XKCD, and deploy it using Globe.dev to handle CORS issues
  automatically. We'll go from a new project to a deployed app in just a few minutes."
* **Action**: In Android Studio/VS Code:
    * Go to `File > New > Flutter Project`.
    * Name it `globe_demo_app`.
    * Wait for creation.
    * Open `main.dart`.
* **Narration**: "Here's the standard Flutter counter app. We'll replace this to fetch data from the
  XKCD API, which normally has CORS issues on the web."

### 2. Globe.dev Signup & Login (~1 minute)

* **Narration**: "Next, we need Globe.dev. It's a platform designed for Dart developers that
  provides hosting and serverless functions. Let's sign up and log in via the CLI."
* **Action**: Switch to Browser:
    * Open `globe.dev`.
    * Briefly show the signup process (or mention you've already signed up).
* **Action**: Switch to Terminal (in project root):
    * Run `dart pub global activate globe_cli` (Mention this only needs to be done once).
    * Run `globe login`. Follow browser authentication.
* **Narration**: "Okay, we're logged into the Globe CLI."

### 3. GitHub Setup (~2 minutes)

* **Narration**: "Now, let's push this initial project to GitHub and set up the secret needed for
  automatic deployments."
* **Action**: In Browser:
    * Create a new public GitHub repository named `globe_demo_app`.
* **Action**: In Terminal (in project root):
    * Run the commands provided by GitHub to push the initial project:
      ```bash
      git init
      git add .
      git commit -m "Initial commit"
      git branch -M main
      git remote add origin <Your-Repo-URL>
      git push -u origin main
      ```
* **Narration**: "Now we need a Globe token for GitHub Actions."
* **Action**: In Terminal:
    * Run `globe token`.
    * Copy the generated token.
* **Action**: Switch to Browser (GitHub Repo):
    * Go to `Settings > Secrets and variables > Actions`.
    * Click `New repository secret`.
    * Name: `GLOBE_TOKEN`.
    * Paste the token into the `Secret` field.
    * Click `Add secret`.
* **Narration**: "Great, the secret is added. GitHub Actions can now authenticate with Globe.dev to
  deploy our app."

### 4. AI Prompt to Implement CORS Solution & Deployment (~1 minute + AI Time)

* **Narration**: "This is where the magic happens. Instead of manually creating all the files for
  Globe.dev and CORS handling, we'll use a single prompt for an AI assistant like Google's Gemini or
  ChatGPT."
* **Action**: Copy the entire prompt block below.
* **Action**: Paste it into your AI assistant chat window.

```text
**AI Prompt:**

Please apply the following instructions to my current Flutter project (`globe_demo_app`). The goal is to transform it into a simple XKCD comic viewer, using Globe.dev for both web hosting and a Dart serverless function to proxy XKCD API calls, handling CORS automatically. Also, set up a GitHub Actions workflow for deployment.

**Instructions:**

1.  **Create `lib/constants.dart`**: Define API URLs for XKCD, routing through `/api/proxy/` for web.

    ```dart
    // lib/constants.dart
    import 'package:flutter/foundation.dart' show kIsWeb;

    const String apiBaseUrl = 'https://xkcd.com';
    const String latestComicEndpoint = 'info.0.json'; // Endpoint for the latest comic

    // Use Globe proxy for web, direct URL for mobile
    final String apiUrl = kIsWeb 
        ? '/api/proxy/$latestComicEndpoint' 
        : '$apiBaseUrl/$latestComicEndpoint';

    // Function to get URL for a specific comic ID
    String getComicUrl(int id) {
      final String specificEndpoint = '$id/info.0.json';
      return kIsWeb
          ? '/api/proxy/$specificEndpoint'
          : '$apiBaseUrl/$specificEndpoint';
    }
    ```

2.  **Create `.globe/functions/proxy.dart`**: Implement the Dart serverless function to proxy requests to `xkcd.com`.

    ```dart
    // .globe/functions/proxy.dart
    import 'dart:convert';
    import 'package:functions_framework/functions_framework.dart';
    import 'package:http/http.dart' as http;
    import 'package:shelf/shelf.dart';

    const apiBaseUrl = 'https://xkcd.com';

    @CloudFunction()
    Future<Response> proxyFunction(Request request) async {
      // Extract the rest of the path after /api/proxy/
      final pathSegments = request.url.pathSegments;
      if (pathSegments.length < 3 || pathSegments[1] != 'proxy') {
        return Response(404, body: 'Not Found');
      }
      final apiPath = pathSegments.sublist(2).join('/');
      
      String queryString = request.url.hasQuery ? '?${request.url.query}' : '';
      final targetUrl = '$apiBaseUrl/$apiPath$queryString';

      try {
        final response = await http.get(Uri.parse(targetUrl));
        return Response(
          response.statusCode,
          body: response.body,
          headers: {
            'Content-Type': response.headers['content-type'] ?? 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type',
          },
        );
      } catch (e) {
        return Response(500, body: jsonEncode({'error': e.toString()}), headers: {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'});
      }
    }
    ```

3.  **Create `.globe/globe.toml`**: Configure routing and web hosting.

    ```toml
    # .globe/globe.toml
    [routes]
    "/api/proxy/**" = "proxy"

    [web]
    directory = "web"
    ```

4.  **Create `.github/workflows/deploy.yml`**: Set up the GitHub Actions workflow.

    ```yaml
    # .github/workflows/deploy.yml
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
              mkdir -p .globe/web
              cp -r build/web/* .globe/web/
              cd .globe
              globe deploy
    ```

5.  **Initialize Globe Project**: If not done already, guide the user to run `globe init` in the project root and choose "Both" as the project type.

6.  **Update `lib/main.dart`**: Replace the counter app code with a simple widget that uses `constants.dart` and `http` to fetch and display the latest XKCD comic title.

    ```dart
    // lib/main.dart
    import 'dart:convert';
    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'constants.dart'; // Import constants

    void main() => runApp(MyApp());

    class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) => MaterialApp(home: HomePage());
    }

    class HomePage extends StatefulWidget {
      @override
      _HomePageState createState() => _HomePageState();
    }

    class _HomePageState extends State<HomePage> {
      String _displayText = 'Loading XKCD...';

      @override
      void initState() {
        super.initState();
        _fetchComic();
      }

      Future<void> _fetchComic() async {
        setState(() => _displayText = 'Loading XKCD...');
        try {
          // Use apiUrl from constants.dart
          final response = await http.get(Uri.parse(apiUrl)); 
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            setState(() => _displayText = "Latest XKCD: ${data['title']}");
          } else {
            setState(() => _displayText = 'Error: ${response.statusCode}');
          }
        } catch (e) {
          setState(() => _displayText = 'Error fetching comic: ${e.toString()}');
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Globe CORS Demo')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_displayText, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _fetchComic,
            tooltip: 'Reload Comic',
            child: Icon(Icons.refresh),
          ),
        );
      }
    }
    ```

7.  **Update `pubspec.yaml`**: Ensure the `http` package is added.

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      http: ^1.1.0 # Add this line
    ```

8.  **Run `flutter pub get`**.

```

* **Narration**: "I've pasted the prompt. The AI will now create the necessary constants file, the
  Globe.dev function code, the configuration files, the GitHub Actions workflow, and update our main
  Dart file to fetch and display the XKCD comic title. It also ensures the http package is added."
* **Action**: Wait for the AI to apply the changes. Review the generated/modified files briefly if
  needed.

### 5. Commit & Push to Trigger Deployment (~1 minute)

* **Narration**: "Okay, the AI has set everything up. Now we just need to commit these changes and
  push them to GitHub. This push will automatically trigger the GitHub Action we defined, which
  builds and deploys our app and function to Globe.dev."
* **Action**: In Terminal:
    * Run:
      ```bash
      git add .
      git commit -m "Implement Globe.dev CORS handling and deployment"
      git push origin main
      ```

### 6. Monitor Deployment & View App (~1-2 minutes + Wait Time)

* **Narration**: "The code is pushed! Let's check the GitHub Actions tab to see our deployment
  pipeline running. This usually takes about 4 to 8 minutes as it builds the Flutter web app and
  deploys everything to Globe."
* **Action**: Switch to Browser (GitHub Repo):
    * Go to the `Actions` tab.
    * Click on the running workflow.
    * Briefly show the steps (Setup, Build, Deploy).
* **(Wait for Action to complete - potentially edit this part in Loom or narrate over it)**
* **Narration**: "The deployment is complete! Let's open the app. Globe provides a URL for our
  project."
* **Action**: Switch to Browser:
    * Open the Globe.dev dashboard or find the URL in the GitHub Action output (e.g.,
      `https://globe-demo-app-xxxx.globe.dev`).
    * Navigate to the URL.
* **Action**: Show the App:
    * The app should load and display the latest XKCD comic title.
    * Open DevTools (F12) -> Console. Show that there are NO CORS errors.
* **Narration**: "And there it is! Our Flutter web app is fetching data from XKCD using our Dart
  serverless function on Globe.dev, with no CORS errors. Everything is hosted and running on
  Globe.dev with automatic deployment via GitHub Actions."

### 7. Conclusion (~30 seconds)

* **Narration**: "So, that's how easy it is to handle CORS for Flutter web using Globe.dev and Dart.
  We went from a new project to a deployed solution with automated deployment in just a few minutes,
  thanks to Globe.dev's simplicity and a little help from AI. Thanks for watching!"

**(End Loom Recording)**