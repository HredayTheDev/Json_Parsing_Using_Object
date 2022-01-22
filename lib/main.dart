import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

class Welcome {
  Welcome({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.author,
    required this.data,
  });

  int page;
  int perPage;
  int total;
  int totalPages;
  Author author;
  List<Datum> data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        author: Author.fromJson(json["author"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Author {
  Author({
    required this.firstName,
    required this.lastName,
  });

  String firstName;
  String lastName;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        firstName: json["first_name"],
        lastName: json["last_name"],
      );
}

class Datum {
  Datum({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.images,
  });

  int id;
  String firstName;
  String lastName;
  String avatar;
  List<Image> images;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );
}

class Image {
  Image({
    required this.id,
    required this.imageName,
  });

  int id;
  String imageName;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        imageName: json["imageName"],
      );
}

void main() => runApp(SingleDoc());

class SingleDoc extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SingleDoc> {
  late Future<Welcome> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
          child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: FutureBuilder<Welcome>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                      child: Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://img.freepik.com/free-photo/portrait-smiling-handsome-male-doctor-man_171337-5055.jpg?size=626&ext=jpg'),
                          radius: 90,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          snapshot.data!.data[0].images[0].id.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        // SizedBox(
                        //   height: 10,
                        // ),

                        // Center(
                        //     child: Text(
                        //   snapshot.data!.medications[0].aceInhibitors[0].dose,
                        // ))

                        //   style: const TextStyle(
                        //       color: Colors.black,
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold),
                        // )),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        // // Center(
                        // //     child: Text(
                        // //         snapshot.data!.sales[0].age.toString())),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                      ],
                    ),
                  ));
                }

                if (snapshot.hasData) {
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      )),
    );
  }

  Future<Welcome> fetchAlbum() async {
    final response =
        await http.get(Uri.parse('https://api.npoint.io/620bf60a07c19d77035a'));

    if (response.statusCode == 200) {
      var doclist = Welcome.fromJson(jsonDecode(response.body));

      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
