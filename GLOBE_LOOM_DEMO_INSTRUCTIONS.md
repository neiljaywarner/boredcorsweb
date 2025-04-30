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