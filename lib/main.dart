import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:google_sheets_app/feedback_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
var check = 0;
bool checkedvalue = false;

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

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
      title: 'The Stockist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoardingPage(),
    );
  }
}


class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {


  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void didChangeDependencies() {

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      var sharedPreferences = sp;
      checkedvalue = sharedPreferences.getBool('checkbox') ?? false;
      if (checkedvalue == true){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyHomePage()),);
      }

    });
    super.didChangeDependencies();
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MyHomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      isTopSafeArea: true,
      globalBackgroundColor: Colors.white,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "The Stockist",
          body:
          "A simple to use daily sales record application for small businesses",
          image: Center(child: Image.asset("images/img1.jpg")),
          decoration: pageDecoration.copyWith(
            titleTextStyle: TextStyle(color: Colors.blue, fontSize: 40, fontWeight: FontWeight.w700),
            bodyFlex: 2,
            imageFlex: 3,
          ),

        ),
        PageViewModel(
          title: "Simple interface",
          body:
          "To avoid unnecessary hassles, everything is kept barebone but still with all required functions",
          image: Center(child: Image.asset("images/img2.png")),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          title: "Infinity View",
          body:
          "The entire history of your sales will be available as a scrollable and interactive infinity view",
          image: Center(child: Image.asset("images/img4.png")),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            bodyFlex: 2,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          title: "Easy Editor",
          body:
          "Entries once saved can be edited or modified in the future just by tapping the infinity view. Easy. Right?",
          image: Center(child: Image.asset("images/img3.png")),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            bodyFlex: 2,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          title: "Privacy and Portability",
          body: "The data you store is always bundled with your google account. Just install the app in your new phone and all your existing transactions will be loaded automatically. We assure you that we wont share your valuable data with anyone. It will be kept safe and sound for ever",
          image: Center(child: Image.asset("images/tinyp.jpg")),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 2,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          reverse: true,
        ),
        PageViewModel(
          title: "Is my data safe?",
          body: "Your data is stored in firebase databases which is also used by several banking applications as their primary database server. So your data is always safe and sound and free from any hackers",

          decoration: pageDecoration.copyWith(
            bodyFlex: 5,
            imageFlex: 3,
            bodyAlignment: Alignment.center,
            imageAlignment: Alignment.center,
          ),
          image: Padding(
            padding: const EdgeInsets.only(bottom: 67),
            child: Center(child: Image.asset("images/safe.png")),
          ),
          footer: CheckboxListTile(
            title: Text("Never show this tutorial again"), //    <-- label
            value: checkedvalue,
            onChanged: (newValue) {
              setState(() {
                checkedvalue = newValue;
                print(checkedvalue);
                SharedPreferences.getInstance().then((SharedPreferences sp) {
                  var sharedPreferences = sp;
                  sharedPreferences.setBool('checkbox', checkedvalue);
                });
              });
            },
          ),
          reverse: true,
        ),
      ],
      onDone: () {
        _onIntroEnd(context);
      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
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
    }
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (check == 1) {

      _showmessage().then((String result){
        setState(() {
          summarymessage = result;
          signinText();
        });
      });

    }


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
        'name': nameController.text.toLowerCase(), // John Doe
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

    SizeConfig().init(context);

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
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*8, left: SizeConfig.blockSizeHorizontal*5, right: SizeConfig.blockSizeHorizontal*5, bottom: SizeConfig.blockSizeVertical*1),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: SizeConfig.blockSizeVertical*5,
                      ),
                      Spacer(),
                      Text(
                        "The Stockist",
                        style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeVertical*5),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeVertical*3),
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
                        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3, bottom: SizeConfig.blockSizeVertical*2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: SizeConfig.blockSizeVertical*5,
                        child: ElevatedButton(
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.5),
                        child: Container(
                          height: SizeConfig.blockSizeVertical*5,
                          child: ElevatedButton(
                            onPressed: () {
                              if (signinstate == 0) {
                                _showSnackbar(
                                    "Please Sign in to your google account first");
                              } else {
                                check = 1;
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
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1, bottom: SizeConfig.blockSizeVertical*1),
                    child: Row(
                      children: [
                        Icon(
                          Icons.addchart_sharp,
                          color: Colors.blue,
                          size: SizeConfig.blockSizeVertical*4,
                        ),
                        Spacer(),
                        Text(
                          "Summary",
                          style: TextStyle(
                              color: Colors.blue, fontSize: SizeConfig.blockSizeVertical*4),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: SizeConfig.blockSizeVertical*14,
                      child: Text(summarymessage,
                        style: TextStyle(color: Colors.blueGrey, fontSize: SizeConfig.blockSizeVertical*2),
                        textAlign: TextAlign.center,
                      )
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: adContainer,
            ),

            Container(
              alignment: Alignment.center,
              height: SizeConfig.blockSizeVertical*4,
              child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.login,
                    color: Colors.pink,
                    size: SizeConfig.blockSizeVertical*4,
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
      print(result.data()['date']);
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