// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String _latestLink = 'Unknown';
  late Uri _latestUri;

  late StreamSubscription _sub;

  @override
  initState() {
    super.initState();
    initPlatformStateForUriUniLinks();
  }

  @override
  dispose() {
    _sub.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    // ignore: deprecated_member_use
    _sub = getLinksStream().listen((String? link) {
      setState(() {
        _latestLink = link ?? 'Unknown';
        try {
          if (link != null) _latestUri = Uri.parse(link);
          // ignore: empty_catches
        } on FormatException {}
      });
    }, onError: (err) {
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = Uri();
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String? link) {
      print('got link: $link');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink().toString();
      initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = Uri();
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = Uri();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    setState(() {
      _latestLink = initialLink;
      _latestUri = Uri.parse(initialLink); // initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri? uri) {
      setState(() {
        _latestUri = uri != null ? uri : Uri();

        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      setState(() {
        _latestUri = Uri();
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri? uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri() ?? Uri();
      print('initial uri: ${initialUri.path}'
          ' ${initialUri.queryParametersAll}');
      initialLink = initialUri.toString();
    } on PlatformException {
      initialUri = Uri();
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = Uri();
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_latestUri.queryParametersAll);
    final queryParams = _latestUri.queryParametersAll.entries.toList();
    print("params ni sya");
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              ListTile(
                title: const Text('Link'),
                subtitle: Text(_latestLink,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              ),
              ListTile(
                title: const Text('Uri Path'),
                subtitle: Text(_latestUri.path,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
              ),
              Column(
                  children: queryParams.map((item) {
                return ListTile(
                  title: Text(item.key),
                  trailing: Text(item.value[0]),
                );
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
