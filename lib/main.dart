import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _connectionStatus = 'Unknown';
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getData() async {
    http.Response response =
    await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/"));
    if (response.statusCode == HttpStatus.OK) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Connectivity")),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, i) => ListTile(
                  title: Text(mydata[i]['title']),
                  // subtitle: Text(mydata[i]['body']),
                ),
                itemCount: mydata.length,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
