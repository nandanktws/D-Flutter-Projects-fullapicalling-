import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fullapicalling/Postclass.dart';
import 'package:http/http.dart' as http;

class CallingApi extends StatefulWidget {
  const CallingApi({Key? key}) : super(key: key);

  @override
  State<CallingApi> createState() => _CallingApiState();
}

class _CallingApiState extends State<CallingApi> {
  List post = [];

  final _refreshkey = GlobalKey<RefreshIndicatorState>();

  // getapi calling
  Future<List<Postclass>> getdata() async {
    var response =
        await http.get(Uri.parse("https://etodoapi.herokuapp.com/task/"));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return parsed.map<Postclass>((json) => Postclass.fromJson(json)).toList();
    } else {
      throw Exception("failed to get exception");
    }
  }

  //postapi calling;
  postdata(String title, description) async {
    var response = await http.post(
        Uri.parse("https://etodoapi.herokuapp.com/task/"),
        body: {"title": title, "description": description});
    if (response.statusCode == 201) {
      String responseString = response.body;
      Postclass.fromJson(jsonDecode(responseString));
      print(responseString);
    } else {
      print(response.statusCode);
      throw Exception("failed to get Exception");
    }
  }

   // Put api calling
  updatedata(int
  id, String title, description) async {
    var response = await http.put(
        Uri.parse("https://etodoapi.herokuapp.com/task/$id/"),
        body: {"title": title, "description": description});
    if (response.statusCode == 200) {
      String responseString = response.body;
      Postclass.fromJson(jsonDecode(responseString));
      print(responseString);
    } else {
      print(response.statusCode);
      throw Exception("failed to get Exception");
    }
  }

  // delete api calling ================================================= delete api calling//
  deletedata(int id, String title, description) async {
    var response = await http.delete(
        Uri.parse("https://etodoapi.herokuapp.com/task/$id/"),
        body: {"title": title, "description": description});
    if (response.statusCode == 204) {
      String responseString = response.body;
      Postclass.fromJson(jsonDecode(responseString));
      print(responseString);
    } else {
      print(response.statusCode);
      throw Exception("failed to get Exception");
    }
  }
// patch api calling ================================================= patch api calling//
  patchdata(int id, String title) async {
    var response = await http.patch(
        Uri.parse("https://etodoapi.herokuapp.com/task/$id/"),
        body: {"title": title});
    if (response.statusCode == 200) {
      print(response.body);
      String responseString = response.body;
      Postclass.fromJson(jsonDecode(responseString));
    } else {
      print(response.statusCode);
      throw Exception("failed to get an Exception");
    }
  }

  String input = "";

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text("TodoApp with Api")),
      body: RefreshIndicator(
          key: _refreshkey,
          onRefresh: () async {
            setState(() {
              postdata;
               updatedata;
              // patchdata;
              deletedata;
            });
            return Future.delayed(const Duration(seconds: 1));
          },
          child: FutureBuilder(
            future: getdata(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print(snapshot.hasData);
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].title),
                          leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text("${snapshot.data![index].id}")),
                          subtitle: Text(snapshot.data![index].description),
                          trailing: Text(snapshot.data![index].status),
                          onTap: () {
                            _controller1.text = snapshot.data![index].title;
                            _controller2.text =
                                snapshot.data![index].description;
                            showDialog(
                              barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _controller1,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder()),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextField(
                                              controller: _controller2,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder()),
                                            ),
                                          ],
                                        )),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            _refreshkey.currentState?.show;
                                            String title = _controller1.text;
                                            String description =
                                                _controller2.text;
                                            await deletedata(
                                                snapshot.data![index].id,
                                                title,
                                              description
                                                );
                                          },
                                          child: const Text("Delete")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            _refreshkey.currentState?.show;
                                            String title = _controller1.text;
                                            String description =
                                                _controller2.text;
                                            await updatedata(
                                                snapshot.data![index].id,
                                                title,
                                                description);
                                          },
                                          child: const Text("update"))
                                    ],
                                  );
                                });
                          },
                        ),
                      );
                    });
              } else {
                print("object");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Container(
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller1,
                          onChanged: (String value) {
                            input = value;
                          },
                          decoration: const InputDecoration(
                              hintText: "title", border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          onChanged: (String value) {
                            input = value;
                          },
                          controller: _controller2,
                          decoration: const InputDecoration(
                              hintText: "description",
                              border: OutlineInputBorder()),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          _refreshkey.currentState?.show;
                          String title = _controller1.text;
                          String description = _controller2.text;
                          await postdata(title, description);
                          _controller1.clear();
                          _controller2.clear();
                          setState(() {
                            post.add(input);
                          });
                        },
                        child: const Text("Add"))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    ));
  }
}
