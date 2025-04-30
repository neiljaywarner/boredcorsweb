# Flutter CORS Hello World with Globe.dev

This document provides end-to-end instructions for creating a new Flutter project, adding CORS
handling with Globe.dev, and deploying it. It includes time estimates for each step.

**Overall Goal**: Create a simple Flutter web app that displays data from an external API (like
XKCD) and works correctly despite CORS restrictions, using Globe.dev for both hosting and serverless
functions.

**Total Estimated Time**: 15-25 minutes

## Step 1: Create a New Flutter Project

- **Time**: ~1-2 minutes
- **Action**: Open your terminal and run:
  ```bash
  flutter create globe_cors_hello
  cd globe_cors_hello
  ```

## Step 2: Initial Setup (Prerequisites)

- **Time**: ~5-10 minutes (if not already done)
- **Action**: Follow the setup steps in `GLOBE_PREREQUISITES.md`:
    1. Ensure Flutter & Dart SDKs are installed and configured.
    2. Install the Globe CLI (`dart pub global activate globe_cli`).
    3. Sign up for a Globe.dev account.
    4. Log in via the Globe CLI (`globe login`).
    5. Initialize Globe in the project (`globe init`, choose "Both" project type).
    6. Create a GitHub repository for the project.
    7. Add the `GLOBE_TOKEN` secret to your GitHub repository settings.

## Step 3: Apply CORS Solution using AI Prompt

- **Time**: ~2-3 minutes (AI generation time)
- **Action**: Use the content of `UPDATE_EXISTING_PROJECT_GLOBE.md` as a prompt for an AI assistant.
    - **Prompt Example**: "Please apply the instructions in the following guide to my current
      Flutter project (`globe_cors_hello`). Replace the placeholder API (
      `https://your-api.com/endpoint`) with the XKCD API (`https://xkcd.com/614/info.0.json`)."
    - Paste the entire content of `UPDATE_EXISTING_PROJECT_GLOBE.md` after the prompt.
    - **AI will**:
        - Create `lib/constants.dart` with XKCD URLs.
        - Create `.globe/functions/proxy.dart` for XKCD.
        - Create `.globe/globe.toml` with routes and web config.
        - Create `.github/workflows/deploy.yml`.
        - Guide you to update `lib/main.dart` (if needed) to use the constants and display API data.

## Step 4: Customize `main.dart` (if needed)

- **Time**: ~2-5 minutes
- **Action**: The AI might need help updating `lib/main.dart`. Ensure it:
    - Imports the new `constants.dart`.
    - Uses the `apiUrl` or `getApiUrl()` from constants for HTTP requests.
    - Displays the data fetched from the API (e.g., the XKCD comic title or alt text).
    - Example minimal `_fetch` method for XKCD:
      ```dart
      import 'dart:convert';
      import 'package:http/http.dart' as http;
      import 'constants.dart';
      
      // Inside your State class
      String _displayText = 'Loading...';
  
      Future<void> _fetch() async {
        setState(() => _displayText = 'Loading...');
        try {
          final response = await http.get(Uri.parse(apiUrl));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            setState(() => _displayText = data['title'] ?? 'No title');
          } else {
            setState(() => _displayText = 'Error: ${response.statusCode}');
          }
        } catch (e) {
          setState(() => _displayText = 'Error: ${e.toString()}');
        }
      }
      
      // In your build method, display _displayText
      // Text(_displayText)
      ```

## Step 5: Commit and Push to GitHub

- **Time**: ~1 minute
- **Action**: Commit all the changes created by the AI and your modifications:
  ```bash
  git add .
  git commit -m "Implement Globe.dev CORS handling for XKCD API"
  git push origin main
  ```

## Step 6: Monitor GitHub Action and Globe.dev Deployment

- **Time**: ~4-8 minutes (Wait time)
- **Action**:
    1. Go to the "Actions" tab in your GitHub repository.
    2. Watch the "Deploy to Globe.dev" workflow run.
    3. The action will build the Flutter web app and deploy it along with the function to Globe.dev.
    4. Check the Globe.dev dashboard for deployment status updates.

## Step 7: View Deployed App in Browser

- **Time**: ~1 minute
- **Action**:
    1. Once the GitHub Action completes, find your deployment URL.
        - Check the output of the GitHub Action.
        - Or, log in to your Globe.dev dashboard and find the project URL (e.g.,
          `https://your-project-name.globe.dev`).
    2. Open the URL in your browser.
    3. Verify that the app loads and displays data fetched from the XKCD API without CORS errors.

## Summary & Time Comparison

- **Total Time**: 15-25 minutes from `flutter create` to a working, deployed app with CORS handling.
- **Comparison to Netlify**: Globe.dev might be slightly faster overall for a pure Dart setup.
    - **Netlify Build Time**: ~5-10 minutes (includes cloning/setting up Flutter via Puro).
    - **Globe.dev Build Time**: ~4-8 minutes (Flutter build + Globe deployment). The key difference
      is that Globe's environment is already Dart-native, potentially speeding up the function
      deployment part compared to Netlify's multi-language approach. The single-platform nature (
      hosting + functions) also simplifies the workflow.

Globe.dev offers the simplest path for Flutter developers needing both web hosting and Dart
serverless functions, especially for resolving CORS issues.