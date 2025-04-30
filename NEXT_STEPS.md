# Next Steps: Using This App with Different APIs

This guide will help you adapt the app to use a different API that has CORS restrictions.

## Simplest Option: Globe.dev (Dart-Native)

For Flutter developers who prefer a pure Dart environment for both frontend and backend, **Globe.dev
is likely the simplest and easiest solution**. It allows you to write your serverless functions in
Dart and host your Flutter web app on the same domain, eliminating CORS issues entirely.

**Using the XKCD Demo Prompt:**

To quickly transform a new Flutter project into the XKCD viewer using Globe.dev, you can provide the
contents of the `GLOBE_XKCD_DEMO.md` file as a prompt to an AI assistant like me.

**Steps:**

1. **Prerequisites**: Ensure you meet the requirements listed in `GLOBE_PREREQUISITES.md` (Flutter,
   Globe account, Globe CLI login).
2. **Create Project**: Start with a fresh Flutter project (`flutter create my_xkcd_app`).
3. **Provide Prompt**: Copy the entire content of `GLOBE_XKCD_DEMO.md` and ask the AI assistant to
   apply it to your project.
4. **Deploy**: Follow the deployment steps in the guide (commit, push, check GitHub Action).
5. **View**: Once deployed, open the URL provided by Globe.dev (e.g.,
   `https://your-project-name.globe.dev`) in your browser to see the XKCD viewer.

## Demonstrating CORS Issues: XKCD API Example

Let's use the XKCD API, which has CORS restrictions when accessed directly from browsers but
requires no signup or API key.

### 1. First, Show the CORS Error

The easiest way to demonstrate the CORS issue is by running the Flutter app locally with Chrome:
