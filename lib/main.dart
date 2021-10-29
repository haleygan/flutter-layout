import 'package:exercise_four/userdata.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Friends list'),
      ),
      body: FutureBuilder(
        future: readJsonData(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('$data.error');
          } else if (data.hasData) {
            var user = data.data as List<UserData>;
            return ListView.separated(
                itemCount: user.length,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                user[index].avatar == null
                                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLpp9qUyaYk9AltxxPs_8ShxCYar6DZzddwKCUkSfUFCMTuSY1n7NMeSkmZdAKVecj8e8&usqp=CAU"
                                    : user[index].avatar.toString(),
                              ),
                            )),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        user[index].firstName.toString() +
                                            ' ' +
                                            user[index].lastName.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        user[index].username.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        user[index].status == null
                                            ? "Nothing to say"
                                            : user[index].status.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ))),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  user[index].lastSeenTime.toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        user[index].messages == null
                                            ? "0"
                                            : user[index].messages.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }

  Future<List<UserData>> readJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('assets/data.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => UserData.fromJson(e)).toList();
  }
}
