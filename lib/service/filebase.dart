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
      // uploadObject(_filePath);
    }
  }

  Future<void> uploadObject(
      String bucketNo, String filePath, String name) async {
    try {
      if (!await minio.bucketExists(bucketNo)) {
        await minio.makeBucket(bucketNo);
        print('bucket $bucketNo created');
      } else {
        print('bucket $bucketNo already exists');
      }

      var response = await minio.fPutObject(bucketNo, name, filePath);
      print("This is the $response");
    } catch (e) {
      print("Error during upload $e");
    }
  }

  Future<void> getStats() async {
    final stat = await minio.statObject('crime-images', 'firstObject');
    print(stat.acl);
    print(stat.etag);
    print(stat.lastModified);
    print(stat.metaData!['cid']);
    print(stat.size);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
    // _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
