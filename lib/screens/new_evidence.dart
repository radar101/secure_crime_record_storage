import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminar_blockchain/styles/text.dart';
import '../service/crime_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:file_picker/file_picker.dart';

class NewEvidence extends StatefulWidget {
  const NewEvidence({super.key});

  @override
  State<NewEvidence> createState() => NewEvidenceState();
}

class NewEvidenceState extends State<NewEvidence> {
  TextEditingController caseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _filePath = "";
  String cid = "";

  
  

  @override
  Widget build(BuildContext context) {
    var crimeService = context.watch<CrimeService>();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyles styles = TextStyles(context: context);

    final minio = Minio(
      endPoint: 's3.filebase.com',
      accessKey: 'CA2D0A7A9D4AD46217FC',
      secretKey: 'fxFZLVguzIKHklJdstlZzD4IRp8lXm7tt3ny3g4D',
      useSSL: true,
    );

    void _pickImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          _filePath = result.files.first.path!;
        });
      }
    }

    Future<void> uploadObject(String bucketNo) async {
      String bucketName = "${bucketNo}bucket";
      try {
        print(_filePath);
        print(bucketName);
        // var response =
        //     await minio.fPutObject(bucketName, 'jirstImage', _filePath);
        if (!await minio.bucketExists(bucketName)) {
          await minio.makeBucket(bucketName);
          print('bucket $bucketName created');
        } else {
          print('bucket $bucketName already exists');
        }

        const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        Random random = Random();
        String result = "";

        for (int i = 0; i < 10; i++) {
          int randomIndex = random.nextInt(chars.length);
          result += chars[randomIndex];
        }
        print(result);
        if (_filePath.length != 0) {
          var response = await minio.fPutObject(bucketName, result, _filePath);
          print("This is the $response");
        }
        final stat = await minio.statObject(bucketName, result);
        cid = stat.metaData!['cid'].toString();
        print(cid);
        crimeService.putCaseData(
            int.parse(caseController.text), descriptionController.text, cid);
      } catch (e) {
        print("Error during upload $e");
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/uibg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.08).copyWith(top: height * 0.1),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Text(
                    'Case Number',
                    style: styles.medText,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: styles.darkYellow),
                      borderRadius: BorderRadius.circular(15)),
                  height: height * 0.06,
                  child: TextField(
                    controller: caseController,
                    style: GoogleFonts.poppins(color: styles.darkYellow),
                    decoration: InputDecoration(
                      hintText: 'Enter Case Number',
                      hintStyle: GoogleFonts.poppins(
                        color: styles.lightYellow,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.01),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Text(
                    'Case Description',
                    style: styles.medText,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: styles.darkYellow),
                      borderRadius: BorderRadius.circular(15)),
                  height: height * 0.2,
                  child: TextField(
                    controller: descriptionController,
                    style: GoogleFonts.poppins(color: styles.darkYellow),
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: GoogleFonts.poppins(
                        color: styles.lightYellow,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.05, vertical: height * 0.01),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Text(
                    'Case Images',
                    style: styles.medText,
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: styles.darkYellow),
                        borderRadius: BorderRadius.circular(15)),
                    height: height * 0.06,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _pickImage();
                            },
                            icon: Icon(
                              Icons.image,
                              color: styles.darkYellow,
                            )),
                        Text(
                          'Upload Case Image',
                          style: styles.medText,
                        )
                      ],
                    )),
                SizedBox(
                  height: height * 0.2,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                  child: Container(
                    child: OutlinedButton(
                      onPressed: () {
                        // Future<String?> cid =
                        uploadObject(caseController.text);
                      },
                      style: ButtonStyle(
                        side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                            return BorderSide(
                              color: styles.yellow,
                              width: 2.0,
                            );
                          },
                        ),
                      ),
                      child: Text('Submit',
                          style: styles.medText
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
