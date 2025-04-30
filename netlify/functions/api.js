const axios = require('axios');

/**
 * Netlify function to proxy API requests and handle CORS issues.
 * 
 * IMPORTANT: If you change the API URL in lib/constants.dart, 
 * make sure to update API_BASE_URL here as well.
 */

// API configuration
const API_BASE_URL = 'https://zenquotes.io/api';

exports.handler = async function(event, context) {
  // Extract path parameters
  const path = event.path.split('/').filter(Boolean).pop();
  
  try {
    // Build the target API URL - Default to 'random' if no path is provided
    const targetUrl = `${API_BASE_URL}/${path || 'random'}`;
    console.log(`Proxying request to: ${targetUrl}`);
    
    // Forward the request to the API
    const response = await axios.get(targetUrl);
    
    // Return the response with CORS headers
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Content-Type": "application/json"
      },
      body: JSON.stringify(response.data)
    };
  } catch (error) {
    // Handle errors
    console.error('Proxy error:', error.message);
    return {
      statusCode: error.response?.status || 500,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "Content-Type",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ error: error.message })
    };
  }
};