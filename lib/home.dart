import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminar_blockchain/crime_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String APITOKEN =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDIwQkNkRDk2QTIyZEIyRjA0ODVBNzU0MmQ1QWRCZDI5MmNhYjk0NDEiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2OTcyMDU1NTgwMjEsIm5hbWUiOiJzZW1pbmFyLWNyaW1pbmFsIn0.WuDuB6O4aka7oiQ--ujUyBtEw9qiVE0SUgFhTSxPDNw";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveFileFromIpfs("QmZYN8TjLoPzERyKL7grxvSqfAgTZsH9hWs7cVMrYemHrG");
  }

  Future<String> retrieveFileFromIpfs(String ipfsHash) async {
    try {
      var response =
          await http.get(Uri.parse("https://dweb.link/ipfs/$ipfsHash"));
      var decodedData = await json.decode(json.encode(response.body));
      print("Done");
      print(decodedData);
      // uploadFileToIpfs();
      return "Success";
    } catch (e) {
      print('Error retrieving file from IPFS: $e');
      return "";
    }
  }

  Future<String> uploadFileToIpfs() async {
    try {
      // Read the file as bytes
      final ImagePicker picker = ImagePicker();
      List<int> fileBytes;
      // Pick an image.
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Get the file path from the XFile object.
        String filePath = image.path;

        // Read the file as bytes.
        fileBytes = File(filePath).readAsBytesSync();
        var multipartFile = http.MultipartFile.fromBytes(
          'file', // Field name for the file in the request
          fileBytes, // List<int> of file bytes
          filename: 'file_name.ext', // Filename to be used on IPFS
        );

        // Create a MultipartRequest and add the MultipartFile to it
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://ipfs.infura.io:5001/api/v0/add'))
          ..files.add(multipartFile);

        // Send the request and get the response
        var response = await request.send();

        // Read the response as a JSON
        var responseData = await response.stream.bytesToString();

        // Parse the JSON response to get the IPFS hash
        var ipfsResponse = json.decode(responseData);
        String ipfsHash = ipfsResponse['Hash'];

        print('File uploaded to IPFS with hash: $ipfsHash');
        return ipfsHash;
      } else {
        print("Image not retrieved");
        return "";
      }
    } catch (e) {
      print('Error uploading file to IPFS: $e');
      return "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<CrimeService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body:
          // notesServices.isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: 1,
          // itemCount: notesServices.notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              // title: Text(notesServices.notes[index].title),
              // subtitle: Text(notesServices.notes[index].description),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  // notesServices.deleteNote(notesServices.notes[index].id);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // notesServices.addNote(
                      //   titleController.text,
                      //   descriptionController.text,
                      // );
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
