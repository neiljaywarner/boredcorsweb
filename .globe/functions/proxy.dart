import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

// Change this to your API base URL
const apiBaseUrl = 'https://www.boredapi.com/api';

@CloudFunction()
Future<Response> proxyFunction(Request request) async {
  // Get path from request
  final path = request.url.pathSegments.skip(1).join('/');

  // Handle query parameters
  String queryString = '';
  if (request.url.hasQuery) {
    queryString = '?${request.url.query}';
  }

  // Build target URL
  final targetUrl = '$apiBaseUrl/$path$queryString';

  try {
    // Forward request to actual API
    final response = await http.get(Uri.parse(targetUrl));

    // Return response with CORS headers
    return Response(
      response.statusCode,
      body: response.body,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    );
  } catch (e) {
    // Handle errors
    return Response(
      500,
      body: jsonEncode({'error': e.toString()}),
      headers: {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'},
    );
  }
}
