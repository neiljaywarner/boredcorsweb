# Prerequisites for XKCD App with Globe.dev

This document outlines all the prerequisites needed to build and deploy the XKCD Comic Viewer with
Globe.dev serverless functions.

## Required Software

### 1. Flutter SDK

Make sure you have the Flutter SDK installed and configured properly.

**Installation Steps:**

1. Visit the [Flutter installation guide](https://docs.flutter.dev/get-started/install) and follow
   the instructions for your operating system
2. Run `flutter doctor` to verify your installation and fix any issues
3. Make sure Flutter web is enabled:
   ```bash
   flutter config --enable-web
   ```
4. Verify web support is enabled:
   ```bash
   flutter devices
   ```
   You should see `Chrome` listed as an available device.

### 2. Dart SDK

Flutter comes with Dart SDK, but make sure you have version 3.0 or higher:

```bash
dart --version
```

### 3. Globe.dev CLI

The Globe CLI allows you to create and deploy serverless functions written in Dart.

```bash
# Install Globe CLI globally
dart pub global activate globe_cli

# Verify installation
globe --version
```

Make sure the Globe CLI is in your PATH. If not, add `~/.pub-cache/bin` to your PATH.

## Setting Up Accounts

### 1. GitHub Account

Create a [GitHub account](https://github.com/join) if you don't already have one. This will be used
for version control and potentially for deployment.

### 2. Globe.dev Account

1. Visit [Globe.dev](https://www.globe.dev/) and sign up for a free account
2. After signup, verify your email address
3. Log in to the Globe.dev dashboard
4. Note your Globe.dev organization name (you'll need this for deployments)

## Authentication Setup

### Authenticate with Globe.dev

After installing the Globe CLI, you need to authenticate:

```bash
globe login
```

This will open a browser window where you can authorize the CLI to access your Globe.dev account.

### Setting Up Project Configuration

Initialize your Globe.dev project configuration:

```bash
globe init
```

When prompted:

- Choose a unique project name
- Select "Backend" for project type
- Choose "Yes" when asked about using the current directory

## Environment Preparation

### Verify Your Setup

Ensure everything is properly set up:

1. Verify Globe CLI is authenticated:
   ```bash
   globe whoami
   ```

2. Check Flutter web support:
   ```bash
   flutter devices
   ```

3. Check that you can deploy to Globe.dev:
   ```bash
   globe status
   ```

## Next Steps

Once you have all prerequisites installed and configured, return to
the [GLOBE_XKCD_DEMO.md](GLOBE_XKCD_DEMO.md) file for detailed instructions on building and
deploying the XKCD Comic Viewer app.