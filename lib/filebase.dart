import 'package:flutter/material.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:file_picker/file_picker.dart';

class FileBaseService extends StatefulWidget {
  const FileBaseService({super.key});

  @override
  State<FileBaseService> createState() => _FileBaseServiceState();
}

class _FileBaseServiceState extends State<FileBaseService> {
  final minio = Minio(
    endPoint: 's3.filebase.com',
    accessKey: 'CA2D0A7A9D4AD46217FC',
    secretKey: 'fxFZLVguzIKHklJdstlZzD4IRp8lXm7tt3ny3g4D',
    useSSL: true,
  );

  String _filePath = '';

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.first.path!;
      });
      uploadObject(_filePath);
      // Call your upload function here passing _filePath
    }
  }

  Future<void> uploadObject(String file) async {
    try {
      var response =
          await minio.fPutObject('crime-images', 'sirstObject', file);
      print("This is the $response");
    } catch (e) {
      print("Error during upload $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
