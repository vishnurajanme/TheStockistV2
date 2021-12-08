import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:google_sheets_app/feedback_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

String username;
int signinstate = 0;
String uid;
String summarymessage = "Welcome onboard. Signin using your google account by clicking the Sign-in button below. All your data will be safe in the cloud for ever, and will be available across your devices";
var netprofit = 0;
var yearlyprofit = 0;
var monthlyprofit = 0;
var signintext = "Signin with Google";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  await Firebase.initializeApp();
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


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();



    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      setState(() {
        signintext = sharedPreferences.getString('signintext') ?? "Signin with Google";
        summarymessage = sharedPreferences.getString('summarymessage') ?? "Welcome onboard. Signin using your google account by clicking the Sign-in button below. All your data will be safe in the cloud for ever, and will be available across your devices";
        signinstate = sharedPreferences.getInt('signinstate') ?? 0;
        username = sharedPreferences.getString('username') ?? null;
        uid = sharedPreferences.getString('uid') ?? null;
      });
      });
  }

  void _summarymessagefn() {

    if (signinstate == 0) {

      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          signinstate = 0;
        } else {
          setState(() {
            signinstate = 1;
            username = user.displayName;
            uid = user.uid;
            signintext = "Signout $username";
          });
        }

        _showmessage().then((String result){
        setState(() {
        summarymessage = result;
        signinText();
        });
        });

      });

    }
    else {
      setState(() {
        signinText();
        username = null;
        uid = null;
        signinstate = 0;
        netprofit = 0;
        yearlyprofit = 0;
        monthlyprofit = 0;
        signintext = "Signin via Google";
        summarymessage = "Welcome onboard. Signin using your google account by clicking the Sign-in button below. All your data will be safe in the cloud for ever, and will be available across your devices";
      });
    }

  }




  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
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




  Future<void> _submitForm() {

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

        _showSnackbar("Success");
      }).catchError((error) {
        _showSnackbar("Error Occurred! Check internet");
        print("Failed to add data: $error");
      });
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {

    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );

    myBanner.load();

    final AdWidget adWidget = AdWidget(ad: myBanner);

    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff7174e0), Color(0xff0e1134)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: _height*0.07, left: _width*0.06, right: _width*0.05, bottom: _height*0.005),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: _height*0.04,
                      ),
                      Spacer(),
                      Text(
                        "The Stockist",
                        style: TextStyle(color: Colors.white, fontSize: _height*0.04),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _width*0.05),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 9,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.only(top: _height*0.01, bottom: _height*0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
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
                              TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(labelText: 'Purchase Price'),
                              ),
                              TextFormField(
                                controller: mobileNoController,
                                validator: (value) {
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Sale Price',
                                ),
                              ),
                              TextFormField(
                                controller: feedbackController,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(labelText: 'Remark'),
                              ),
                              TextFormField(
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
                              )
                            ],
                          ),
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            print("The uid is as follows from buttonpress $uid");
                            if (signinstate == 0) {
                              _showSnackbar(
                                  "Please Sign in to your google account first");
                            } else {
                              _submitForm();
                              _showmessage().then((String result){
                                setState(() {
                                  summarymessage = result;
                                });
                              });
                            }
                            signinText();
                          },
                          child: Text('Upload Data to Cloud',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (signinstate == 0) {
                              _showSnackbar(
                                  "Please Sign in to your google account first");
                            } else {
                              _showmessage().then((String result){
                                setState(() {
                                  summarymessage = result;
                                });
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeedbackListScreen(),
                                  ));
                            }
                            signinText();
                          },
                          child: Text('Show Purchase History'),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: _height*0.01, bottom: _height*0.01),
                      child: Row(
                        children: [
                          Icon(
                            Icons.addchart_sharp,
                            color: Colors.blue,
                            size: _height*0.036,
                          ),
                          Spacer(),
                          Text(
                            "Summary",
                            style: TextStyle(
                                color: Colors.blue, fontSize: _height*0.036),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Text(summarymessage,
                        style: TextStyle(color: Colors.blueGrey, fontSize: _height*0.02),
                        textAlign: TextAlign.center,
                      )
                    ),
                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              height: 60,
              child: adContainer,
            ),

            Container(
              alignment: Alignment.center,
                padding: EdgeInsets.only(left: _height*0.03, right: _height*0.03, top: _height*0.008, bottom: _height*0.005),
                height: 45,
                child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.login,
                      color: Colors.pink,
                      size: 24.0,
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    label: Text(signintext),
                    onPressed: () {
                      if (signinstate == 0){
                        signInWithGoogle();
                      }
                      else {
                        _signOut();
                      }
                      _summarymessagefn();
                    }),
            )
          ],
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  GoogleSignIn().disconnect();
}

Future<String> _showmessage() async {

  var netprofit = 0;
  var yearlyprofit = 0;
  var monthlyprofit = 0;
  print(uid);

  await db
      .collection("users")
      .doc(uid)
      .collection("products")
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      netprofit = netprofit + result.data()['profit'];
      if ((result.data()['date'].toString().split('-').first) ==
          (DateTime.now().toIso8601String().split('-').first)) {
        yearlyprofit = yearlyprofit + result.data()['profit'];
        if ((DateTime.now().toIso8601String().split('-')[1]) ==
            (result.data()['date'].toString().split('-')[1])) {
          monthlyprofit = monthlyprofit + result.data()['profit'];
        }
      }
    });
  });

  if (username != null) {
    return ("Welcome $username\nMonthly Profit: $monthlyprofit \nYearly profit: $yearlyprofit \nNet profit: $netprofit");
  }
  else return ("Please Sign-in using your google account and start uploading transaction details to see the summary statement");
}


signinText() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('signintext', signintext);
  prefs.setString('summarymessage', summarymessage);
  prefs.setString('username', username);
  prefs.setString('uid', uid);
  prefs.setInt('signinstate', signinstate);
  print("saved the value to saved preferences yeah");
}

