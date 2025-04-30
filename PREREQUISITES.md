# Prerequisites

This document outlines all the prerequisites needed to develop and deploy the Bored CORS Web
application.

## Required Software

### Flutter

Flutter is the framework used to build the application.

**Traditional Installation:**

1. Download Flutter SDK from [Flutter's website](https://docs.flutter.dev/get-started/install)
2. Extract the SDK to a desired location
3. Add Flutter to your path
4. Run `flutter doctor` to verify installation and identify any dependencies
5. Install any missing dependencies identified by Flutter doctor

For detailed instructions, visit
the [Flutter installation guide](https://docs.flutter.dev/get-started/install).

**Quick Install with Puro (Recommended):**

For a faster and easier Flutter setup, you can use Puro - a Flutter version manager:

```bash
# Install Puro
curl -fsSL https://get.puro.dev/install.sh | sh

# Add Puro to your path (follow instructions after install)
# Then create a new Flutter project setup
puro init

# Verify installation
puro flutter --version
```

Puro automatically manages Flutter versions and dependencies, making setup much simpler.

## Setting Up Accounts

### GitHub Account

1. Create a [GitHub account](https://github.com/join) if you don't have one
2. Set up Git on your local machine:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

### Netlify Account

Netlify is a web hosting platform that we'll use to deploy our Flutter web application and handle
CORS issues through serverless functions.

#### Creating and Connecting a Netlify Account:

1. **Sign up**: Go to [Netlify's signup page](https://app.netlify.com/signup)
    - You can sign up using your GitHub account (recommended), or with an email address

2. **Connecting to GitHub**:
    - After logging in to Netlify, click on your profile picture in the top right corner
    - Select "User settings" from the dropdown menu
    - In the left sidebar, click on "Applications"
    - Under "OAuth applications", click "Install" next to GitHub
    - You'll be redirected to GitHub to authorize Netlify
    - Choose whether to give Netlify access to all repositories or only select ones
    - Click "Install" to confirm

This connection will allow you to easily deploy your application from your GitHub repository.

## Next Steps

Once you have all prerequisites installed, return to the [README.md](README.md) for deployment
instructions.