# Demo Steps: Creating a Loom Video for CORS Solution

This guide provides step-by-step instructions for creating an efficient Loom demonstration of the
CORS issue and how to solve it with Netlify Functions.

## Preparation (Before Recording)

1. **Set up the local Flutter project**
    - The project should already be cloned from GitHub
    - Run `flutter pub get` to ensure dependencies are installed
    - Update `lib/constants.dart` to use the XKCD API:
      ```dart
      const String apiBaseUrl = 'https://xkcd.com';
      const String apiEndpoint = '614/info.0.json';
      ```

2. **Before starting the recording**:
    - Open Chrome with the Netlify dashboard (sign in to your account)
    - Open VS Code or your IDE with the project
    - Have your terminal ready

## Recording Script (5-Minute Demo)

### Part 1: Demonstrate the CORS Issue (1 minute)

1. **Start Loom recording** (screen + microphone)

2. **Introduction**
    - "Hello! I'm going to demonstrate how to solve CORS issues using Netlify Functions with a
      Flutter web app."
    - "First, let's see the problem with direct API access..."

3. **Run the Flutter app locally**
   ```bash
   flutter run -d chrome
   ```

4. **Show the issue**
    - When the app loads, it will attempt to fetch from XKCD directly
    - Open Chrome DevTools (F12)
    - Show the CORS error in the console
    - "As you can see, the browser blocks direct requests to XKCD's API due to CORS restrictions"

### Part 2: Deploy to Netlify (2 minutes)

1. **Go to Netlify**
    - Navigate to your Netlify dashboard (should already be open)
    - Click "Add new site" > "Import an existing project"
    - Select "Deploy with GitHub"

2. **Connect to your GitHub repository**
    - If this is your first time, you'll need to authorize Netlify to access your GitHub
    - Search for and select your repository

3. **Configure the deployment**
    - On the "Site settings" page, Netlify should automatically detect the build settings from your
      netlify.toml file
    - No need to modify any settings - just click "Deploy site"
    - "Netlify will automatically install Flutter using Puro and build our app"
    - Start the deploy

4. **While deploying, explain how it works**
    - "While Netlify is deploying, let's take a look at how our solution works"
    - Show the `netlify/functions/api.js` file:
      ```javascript
      /* Explain how the proxy works:
       * 1. It makes a server-side request (not subject to CORS)
       * 2. It adds proper CORS headers to the response
       * 3. It forwards the data back to the client
       */
      ```
    - Show the `netlify.toml` file:
      ```
      # Show how the redirects work and how Puro speeds up Flutter installation
      [build]
      command = """
        # Puro speeds up Flutter installation by 20%
        curl -fsSL https://get.puro.dev/install.sh | sh
      """
      ```
    - Show the `lib/constants.dart` file:
      ```dart
      // Show how the app detects web platform and uses the proxy
      ```

### Part 3: Test the Deployed Solution (2 minutes)

1. **When deployment is complete**
    - "Great! Our deployment is complete. Let's test it out."
    - Navigate to the deployed site URL (click the link Netlify provides)

2. **Show it working**
    - "As you can see, our app is now successfully fetching data from XKCD via the Netlify Function"
    - Show that the app displays the XKCD comic information
    - Open DevTools and show no CORS errors

3. **Test the API directly**
    - "We can also test our API proxy directly"
    - Navigate to `https://your-site-name.netlify.app/api/614`
    - Show the JSON response

### Conclusion

1. **Recap the solution**
    - "To summarize, we've solved the CORS issue by:"
    - "1. Creating a serverless function in Netlify that acts as a proxy"
    - "2. Adding CORS headers to the response"
    - "3. Configuring our app to use the proxy when running on the web"

2. **End the recording**
    - "Thanks for watching! This approach can be adapted for any API with CORS restrictions."

## Tips for a Smooth Recording

1. **If the Netlify deployment is taking too long**
    - You can pre-deploy before recording and then just show the final deployed site
    - Or show a pre-recorded clip of the deployment completion

2. **Keep Chrome DevTools open**
    - This helps viewers see what's happening behind the scenes
    - Use the Network and Console tabs to show requests and errors

3. **First-time Netlify users**
    - If this is your first time using Netlify, the GitHub authorization step may take a bit longer
    - It's perfectly fine to narrate what you're doing as you go through these steps
    - The UI is intuitive - just follow the prompts to connect your GitHub account