import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: BoredActivityPage());
}

class BoredActivityPage extends StatefulWidget {
  @override
  State<BoredActivityPage> createState() => _BoredActivityPageState();
}

class _BoredActivityPageState extends State<BoredActivityPage> {
  bool _loading = true;
  String _activity = '';
  String _type = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.get(uri);
      final data = jsonDecode(response.body);
      setState(() {
        _activity = data['activity'];
        _type = data['type'];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _activity = 'Error loading activity: ${e.toString()}';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bored Activity Suggestions')),
    body: Center(
      child:
          _loading
              ? const CircularProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _activity,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text('Type: $_type', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    ElevatedButton(onPressed: _fetch, child: const Text('Get Another Activity')),
                  ],
                ),
              ),
    ),
  );
}
