import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seminar_blockchain/screens/new_evidence.dart';
import 'package:seminar_blockchain/service/crime_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../styles/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController caseController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CrimeService();
    // CrimeService().putCaseData("1", "fakdjfakfd", "fjdkalflkdfdfj");
  }

  Widget build(BuildContext context) {
    var crimeServices = context.watch<CrimeService>();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyles styles = TextStyles(context: context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        crimeServices.getCaseData(caseController.text);
        setState(() {});
      }),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/uibg.jpg'), // Replace 'assets/background_image.jpg' with your actual image asset path
            fit: BoxFit
                .cover, // You can change the BoxFit according to your needs
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(width * 0.08).copyWith(top: height * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, XYZ',
                style: GoogleFonts.poppins(
                    color: styles.darkYellow,
                    textStyle: TextStyle(
                        fontSize: width * 0.08, fontWeight: FontWeight.bold)),
              ),
              Text(
                'Forensic Expert, Virology Pune',
                style: GoogleFonts.poppins(
                    color: styles.darkYellow,
                    textStyle: TextStyle(
                      fontSize: width * 0.05,
                    )),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              TextField(
                controller: caseController,
                style: GoogleFonts.poppins(color: styles.darkYellow),
                decoration: InputDecoration(
                  hintText: 'Enter Case Number',
                  hintStyle: GoogleFonts.poppins(
                    color: styles.lightYellow,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: styles.yellow, // Set the border color to yellow
                      width: 2.0, // Set the border width
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: styles
                          .yellow, // Set the border color to yellow when the TextField is focused
                      width: 2.0, // Set the border width
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'images/pexels-photo-923681.jpeg'), // Replace 'assets/background_image.jpg' with your actual image asset path
                      fit: BoxFit
                          .cover, // You can change the BoxFit according to your needs
                    ),
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NewEvidence()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: styles.darkYellow,
                      ),
                      Text(
                        '   Add New Case',
                        style: GoogleFonts.poppins(
                          color: styles.darkYellow,
                          textStyle: TextStyle(
                            fontSize: width * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
