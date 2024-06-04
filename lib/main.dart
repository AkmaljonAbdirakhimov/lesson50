import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/views/screens/home_screen.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HttpExamples(),
    );
  }
}

class Contact {
  String id;
  String fullname;

  Contact({
    required this.id,
    required this.fullname,
  });
}

class HttpExamples extends StatefulWidget {
  const HttpExamples({super.key});

  @override
  State<HttpExamples> createState() => _HttpExamplesState();
}

class _HttpExamplesState extends State<HttpExamples> {
  final nameController = TextEditingController();
  Future<List<Contact>> getContacts() async {
    Uri url = Uri.parse(
        "https://lesson46-761b9-default-rtdb.firebaseio.com/contacts.json");

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Contact> contacts = [];
    if (data != null) {
      data.forEach((key, value) {
        contacts.add(
          Contact(
            id: key,
            fullname: value['fullname'],
          ),
        );
      });
    }
    return contacts;
  }

  Future<void> addContact(String fullname) async {
    Uri url = Uri.parse(
        "https://lesson46-761b9-default-rtdb.firebaseio.com/contacts.json");

    final response = await http.post(
      url,
      body: jsonEncode({"fullname": fullname}),
    );
    final data = jsonDecode(response.body);

    print(data);
    setState(() {});
  }

  Future<void> editContact(String id, String fullname) async {
    Uri url = Uri.parse(
        "https://lesson46-761b9-default-rtdb.firebaseio.com/contacts/$id.json");

    final response = await http.patch(url,
        body: jsonEncode(
          {"fullname": fullname},
        ));

    setState(() {});
  }

  Future<void> deleteContact(String id) async {
    Uri url = Uri.parse(
        "https://lesson46-761b9-default-rtdb.firebaseio.com/contacts/$id.json");
    final response = await http.delete(url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HTTP UCHUN MISOLLAR"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final response = await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text("Kontakt qo'shish"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Ism va Familiya",
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Bekor Qilish"),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context, nameController.text);
                        },
                        child: const Text("Yaratish"),
                      ),
                    ],
                  );
                },
              );

              if (response != null) {
                //? yangi kontakt qo'shamiz
                nameController.clear();
                addContact(response);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final contacts = snapshot.data;
            return contacts == null || contacts.isEmpty
                ? const Center(
                    child: Text("Kontaktlar mavjud emas"),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (ctx, index) {
                      contacts.sort(
                        (a, b) => b.fullname
                            .toLowerCase()
                            .compareTo(a.fullname.toLowerCase()),
                      );
                      return ListTile(
                        onTap: () async {
                          nameController.text = contacts[index].fullname;
                          final response = await showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: const Text("Kontakt tahrirlash"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Ism va Familiya",
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Bekor Qilish"),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context, nameController.text);
                                    },
                                    child: const Text("Yangilash"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (response != null) {
                            //? kontaktni o'zgartiramiz
                            editContact(contacts[index].id, response);
                          }
                        },
                        title: Text(
                          "${index + 1}. ${contacts[index].fullname}",
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            deleteContact(contacts[index].id);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  );
          }),
    );
  }
}
