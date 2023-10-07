import 'package:aitc_bootcamp2/data_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final String url = 'https://reqres.in/api/users?page=2';
  List? data;

  Future<void> _getRefreshData() async {
    getJsonData(context);
  }

  Future<void> getJsonData(BuildContext context) async {
    var response =
        await http.get(Uri.parse(url), headers: {'Accept': 'application/json'});

    setState(() {
      var converDataToJson = jsonDecode(response.body);
      data = converDataToJson['data'];
    });
  }

  @override
  void initState() {
    _getRefreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Data from Reqres API'),
      ),
      body: RefreshIndicator(
        onRefresh: _getRefreshData,
        child: data == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: data == null ? 0 : data!.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) {
                                return DataDetailScreen(id: data![index]['id']);
                              }),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            ClipRRect(
                              child: Image.network(
                                data![index]['avatar'],
                                height: 80,
                                width: 80,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(data![index]['first_name'] +
                                    ' ' +
                                    data![index]['last_name']),
                                Text(data![index]['email'])
                              ],
                            )
                          ]),
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
