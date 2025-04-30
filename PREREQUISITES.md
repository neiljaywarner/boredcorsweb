# Prerequisites

This document outlines all the prerequisites needed to develop and deploy the Bored CORS Web
application.

## Required Software

### 1. Homebrew (macOS)

[Homebrew](https://brew.sh/) is a package manager for macOS that makes it easy to install
development tools.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Node.js and npm

Node.js and npm are required for Netlify CLI and serverless functions.

Using Homebrew (macOS):

```bash
brew install node
```

For other platforms, download from [Node.js website](https://nodejs.org/).

Verify installation:

```bash
node --version
npm --version
```

### 3. Flutter

Flutter is the framework used to build the application.

#### Installation Steps:

1. Download Flutter SDK from [Flutter's website](https://docs.flutter.dev/get-started/install)

2. Extract the SDK to a desired location (e.g., `~/development/flutter`)

3. Add Flutter to your path:

   For macOS (add to `~/.zshrc` or `~/.bash_profile`):
   ```bash
   export PATH="$PATH:~/development/flutter/bin"
   ```

4. Run Flutter doctor to verify installation and identify any dependencies:
   ```bash
   flutter doctor
   ```

5. Install any missing dependencies identified by Flutter doctor

### 4. Netlify CLI

The Netlify Command Line Interface is needed for local development and deployment.

```bash
npm install netlify-cli -g
```

Verify installation:

```bash
netlify --version
```

## Setting Up Accounts

### GitHub Account

1. Create a [GitHub account](https://github.com/join) if you don't have one
2. Set up Git on your local machine:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### Netlify Account

[Netlify](https://www.netlify.com/) is a web hosting and automation platform that we'll use to
deploy our Flutter web application and handle CORS issues through serverless functions.

#### Creating a Netlify Account:

1. Go to [Netlify's signup page](https://app.netlify.com/signup)
2. You can sign up using your GitHub account (recommended), or with an email address

#### Connecting Netlify to GitHub:

1. After signing up and logging in to Netlify, click on your profile picture in the top right corner
2. Select "User settings" from the dropdown menu
3. In the left sidebar, click on "Applications"
4. Under "OAuth applications", you will see GitHub if already connected. If not:
    - Click "Install" next to GitHub
    - You'll be redirected to GitHub to authorize Netlify
    - Choose whether to give Netlify access to all repositories or only select ones
    - Click "Install" to confirm

#### Testing the Connection:

1. Return to the Netlify dashboard
2. Click "New site from Git"
3. Select "GitHub" as your Git provider
4. You should see a list of your GitHub repositories (if authorized)
5. If you see your repositories, the connection is successful
6. You can cancel this process for now if you're just testing the connection

This connection will allow you to easily deploy your application from your GitHub repository in
later steps.

## Next Steps

Once you have all prerequisites installed, return to the [README.md](README.md) for deployment
instructions.