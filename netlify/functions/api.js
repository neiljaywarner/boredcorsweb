const axios = require('axios');

exports.handler = async function(event, context) {
  // Extract path parameters
  const path = event.path.split('/').filter(Boolean).pop();
  
  try {
    // Forward the request to zenquotes API
    const response = await axios.get(`https://zenquotes.io/api/${path || 'random'}`);
    
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