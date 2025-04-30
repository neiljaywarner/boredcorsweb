# XKCD Comic Viewer with Globe.dev

A Flutter application that displays XKCD comics with a Dart-based serverless function to handle CORS
issues when running on the web.

## Overview

This project demonstrates how to:

- Create a Flutter app that works on both web and mobile platforms
- Handle CORS restrictions for web builds using Globe.dev serverless functions
- Implement a clean architecture for API integration
- Deploy Dart-native serverless functions

## Features

- View the latest XKCD comic
- Navigate to previous/next comics
- View a random comic
- See comic metadata (publication date, title, etc.)
- View the "alt text" for each comic
- Open the comic in the official XKCD website

## Getting Started

To get started with this project, make sure you have the necessary prerequisites:

1. Check the [Prerequisites Guide](GLOBE_PREREQUISITES.md) for required software and account setup
2. Follow the [Implementation Guide](GLOBE_XKCD_DEMO.md) for step-by-step instructions

## Project Structure

```
lib/
  ├── constants.dart       # API URL configuration
  ├── main.dart            # Main application entry
  ├── models/
  │   └── comic.dart       # XKCD comic data model
  ├── services/
  │   └── comic_service.dart # API service for fetching comics
  └── widgets/
      └── ... (optional UI components)
      
globe/
  └── functions/
      └── xkcd_proxy.dart  # CORS proxy function
```

## Why Globe.dev?

We chose Globe.dev for this project because:

1. **Dart-Native Backend**: Write your backend code in Dart, just like your Flutter app
2. **Simple Setup**: Minimal configuration compared to other serverless platforms
3. **Flutter-Friendly**: Designed with Flutter developers in mind
4. **Seamless Integration**: Easy to integrate with Flutter web applications

## How It Works

1. The Flutter app detects if it's running on web or mobile
2. On mobile, it directly calls the XKCD API
3. On web, it calls the Globe.dev serverless function
4. The Globe.dev function acts as a proxy, adding CORS headers to the response

This approach allows the same codebase to work across platforms while solving the CORS restriction
issue for web deployments.

## Credits

- [XKCD](https://xkcd.com/) for their wonderful comics and open API
- [Flutter](https://flutter.dev/) for the cross-platform UI framework
- [Globe.dev](https://www.globe.dev/) for the Dart-native serverless platform

## License

This project is released under the MIT License. See the LICENSE file for details.