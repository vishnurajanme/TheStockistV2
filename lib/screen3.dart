import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

final _formKey = GlobalKey<FormState>();
final _scaffoldKey = GlobalKey<ScaffoldState>();

// TextField Controllers
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileNoController = TextEditingController();
TextEditingController feedbackController = TextEditingController();
TextEditingController datecontroller = TextEditingController();
TextEditingController profitcontroller = TextEditingController();
TextEditingController netcontroller = TextEditingController();

int check = 1;

void screen3() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockist',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Stockist'),
    );

  }
}



class Screen3 extends StatefulWidget {
  var olddata;
  Screen3(this.olddata);
  @override
  _Screen2State createState() => _Screen2State(this.olddata);
}

class _Screen2State extends State<Screen3> {

  Future<bool> _willPopScopeCall() async {
    Navigator.of(context, rootNavigator: false).pop();
    return false; // return true to exit app or return false to cancel exit
  }


  var olddata;
  _Screen2State(this.olddata);

  @override
  void initState() {
    super.initState();
    //Whatever you need to run just for one time may be pasted here :D
    nameController.text = olddata['name'];
    emailController.text = olddata['purchase'];
    mobileNoController.text = olddata['sale'];
    feedbackController.text = olddata['remark'];
    datecontroller.text = olddata['date'];
  }


  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Future<void> _submitForm() async {

    CollectionReference products =
    db.collection("users").doc(uid).collection("products");
    print("Here goes the uid $uid");
    // Call the user's CollectionReference to add a new user
    if (_formKey.currentState.validate()) {
      return products.add({
        'name': nameController.text, // John Doe
        'purchase': emailController.text, // Stokes and Sons
        'sale': mobileNoController.text, // 42
        'remark': feedbackController.text,
        'date': datecontroller.text,
        'profit': (int.parse(mobileNoController.text) -
            int.parse(emailController.text)),
      }).then((value) {
        _formKey.currentState.reset();

        nameController.text = "";
        emailController.text = "";
        mobileNoController.text = "";
        feedbackController.text = "";
        datecontroller.text = "";


        db.runTransaction(
                  (Transaction myTransaction) async {
                await myTransaction.delete(olddata.reference);
              });
        Navigator.of(context, rootNavigator: false).pop();
      });
    }
  }

  @override

  Widget build(BuildContext context) {

    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-8764497517675712/8359618049',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );

    myBanner.load();
    SizeConfig().init(context);

    final AdWidget adWidget = AdWidget(ad: myBanner);

    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text("Editor"),
            backgroundColor: Colors.blueAccent),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, bottom: SizeConfig.blockSizeVertical*1,
                    left: SizeConfig.blockSizeVertical*4, right: SizeConfig.blockSizeVertical*4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: SizeConfig.blockSizeVertical*7,
                          child: TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Name, Purchase & Sale Price, Date of Sale is mandatory';
                              }
                              return null;
                            },
                            decoration:
                            InputDecoration(labelText: 'Product Name'),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical*7,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration:
                            InputDecoration(labelText: 'Purchase Price'),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical*7,
                          child: TextFormField(
                            controller: mobileNoController,
                            validator: (value) {
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Sale Price',
                            ),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical*7,
                          child: TextFormField(
                            controller: feedbackController,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(labelText: 'Remark'),
                          ),
                        ),
                        Container(
                          height: SizeConfig.blockSizeVertical*7,
                          child: TextFormField(
                            controller: datecontroller,
                            decoration: InputDecoration(
                              labelText: "Date of Sale",
                              hintText: "Ex. Insert the Date of Sale",
                            ),
                            onTap: () async {
                              DateTime date = DateTime(1900);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));

                              datecontroller.text =
                                  date.toIso8601String().split('T').first;
                            },
                            validator: (value) {
                              return null;
                            },
                          ),
                        )
                      ],
                    ),
                  )),

              Container(
                alignment: Alignment.center,
                child: adContainer,
              ),

              Padding(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, bottom: SizeConfig.blockSizeVertical*1,
                    left: SizeConfig.blockSizeVertical*4, right: SizeConfig.blockSizeVertical*4),
                child: Container(
                  height: SizeConfig.blockSizeVertical*5,
                  child: ElevatedButton(
                    onPressed: () {
                      print("The uid is as follows from buttonpress $uid");
                      if (signinstate == 0) {
                        _showSnackbar(
                            "Please Sign in to your google account first");
                      } else {
                        _submitForm();
                      }
                      signinText();
                    },
                    child: Center(child: Text('UPDATE THIS ENTRY',)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeVertical*4, right: SizeConfig.blockSizeVertical*4),
                child: Container(
                  height: SizeConfig.blockSizeVertical*5,
                    child: ElevatedButton(
                      onPressed: () async {
                        await db.runTransaction(
                                (Transaction myTransaction) async {
                              await myTransaction.delete(olddata.reference);
                            });
                        Navigator.of(context, rootNavigator: false).pop();
                        _showSnackbar(
                            "Deleted");
                      },
                      child: Center(child: Text('DELETE THIS ENTRY',)),
                    )
                ),
              ),

            ],
          )
        ),
      ),
        onWillPop: _willPopScopeCall,
    );
  }
}