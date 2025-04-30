import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: QuotePage());
}

class QuotePage extends StatefulWidget {
  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  bool _loading = true;
  var _q = '';
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final Uri apiUrl = kIsWeb ? Uri.parse(webApiPath) : Uri.parse(mobileApiUrl);

    final r = await http.get(apiUrl);
    final d = jsonDecode(r.body);
    setState(() {
      _q = d.first['q'];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: _loading ? const CircularProgressIndicator() : Text(_q)));
}
