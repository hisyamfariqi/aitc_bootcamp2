import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataDetailScreen extends StatefulWidget {
  final int? id;

  const DataDetailScreen({super.key, this.id});

  @override
  State<DataDetailScreen> createState() => _DataDetailScreenState();
}

class _DataDetailScreenState extends State<DataDetailScreen> {
  Map? data;
  String? uri;

  Future<void> _getRefreshDataa(url) async {
    getJsonData(context, url);
  }

  Future<void> getJsonData(BuildContext context, url) async {
    setState(() {
      uri = url;
    });

    var response = await http.get(Uri.parse(uri.toString()),
        headers: {'Accept': 'application/json'});
    print(response.body);

    setState(() {
      var convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson['data'];
    });
  }

  @override
  void initState() {
    var url = 'https://reqres.in/api/users/${widget.id.toString()}';
    _getRefreshDataa(url);
    super.initState();
    print('Cek parameter +${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Data Detail from Reqres API'),
      ),
      body: Container(
          child: data == null
              ? Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.grey),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )
              : ListTile(
                  leading: Image.network(data!['avatar']),
                  title: Text(data!['first_name'] + ' ' + data!['last_name']),
                  subtitle: Text(data!['email']),
                )),
    );
  }
}
