import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Photos> photoList = [];

  Future<List<Photos>> getPhoto() async {
    final res = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(res.body.toString());
    if (res.statusCode == 200) {
      for (Map i in data) {
        Photos photos = Photos(
         
            title: i['title'],
            url: i['url'],
            thumbnailUrl: i['thumbnailUrl'],
          );
        photoList.add(photos);
      }
      return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Api Model data Call'),
          backgroundColor: Colors.green),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPhoto(),
                builder: (context, AsyncSnapshot<List<Photos>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    );
                  }
                  return ListView.builder(
                      itemCount: photoList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    snapshot.data![index].url.toString(),
                                  ),
                                  radius: 50,
                                ),
                                title: Text(
                                    snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot
                                    .data![index].thumbnailUrl
                                    .toString()),
                               
                              ),
                            ],
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}

class Photos {
  String title, url, thumbnailUrl;
  Photos(
      {required this.title,
      required this.url,
      required this.thumbnailUrl,
   
      });
}
