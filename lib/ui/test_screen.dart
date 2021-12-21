import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sin_shin/model/Album.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String keyword = 'iphone';

  final TextEditingController textEditingController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<List<Album>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=11587263-a579c62bf1641ed12635c3112&q=$keyword&image_type=photo&pretty=true'));
    // print('여기는 ${response.body}');
    if (response.statusCode == 200) {
      final List<Album> myFutureAlbums =
          Album.listToAlbums(jsonDecode(response.body)['hits']);
      return myFutureAlbums;
    } else {
      throw Exception('실패');
    }
  }

  @override
  //화면이 처음에 뜰 때 사용되는 것 초기화 시켜준다.
  void initState() {
    // TODO: implement initState
    textEditingController.addListener(() {}); //교수님
  }

  @override
  //화면이 마지막에 종료되기 전에 실행되고 메모리를 해제시켜준다.
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
      ),
      body: Column(
        children: [
          Form(
            child: TextFormField(
              decoration: InputDecoration(
                  icon: TextButton(
                onPressed: () {
                  if (textEditingController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          content: Text('검색어를 입력해주세요!'),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0))),
                        );
                      },
                    );
                  } else {
                    setState(() {
                      keyword = textEditingController.text;
                    });
                  }
                },
                child: const Text('검색'),
              )),
              key: _formkey,
              controller: textEditingController,
            ),
          ),
          FutureBuilder<List<Album>>(
            future: fetchAlbum(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('네트웍 에러!'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('노 데이터'),
                );
              }
              final List<Album> albums = snapshot.data!;
              return _buildAlbums(albums);
            },
          )
        ],
      ),
    );
  }

  Widget _buildAlbums(List<Album> albums) {
    return Expanded(
      child: ListView.builder(
        itemCount: albums.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              SizedBox(
                width: 180,
                height: 100,
                child: Image.network(
                  albums[index].previewURL,
                  fit: BoxFit.cover,
                ),
              ),
              Text(albums[index].tags)
            ],
          );
        },
      ),
    );
  }
}
