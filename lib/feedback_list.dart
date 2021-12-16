import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sheets_app/screen3.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'main.dart';
import 'model/form.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static double appheight;


  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    appheight = AppBar().preferredSize.height;

    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth -
        _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight -
        _safeAreaVertical) / 100;
  }
}

class FeedbackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MobileAds.instance.initialize();
    return MaterialApp(
        title: 'Feedback Responses',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FeedbackListPage(title: "Sales History"));
  }
}

class FeedbackListPage extends StatefulWidget {
  FeedbackListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  bool _descending = true;
  List<FeedbackForm> feedbackItems = List<FeedbackForm>();

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-8764497517675712/2819979771',
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    if(_descending == true) {
                      setState(() {
                        _descending = false;
                      });
                    }
                    else {
                      setState(() {
                        _descending = true;
                      });
                    }
                    print(_descending);
                  },
                  child: Icon(
                      Icons.sort
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            // Add your onPressed code here!
            Alert(
              context: context,
              type: AlertType.success,
              title: "",
              desc: "Tap an entry to modify or delete the same. If you notice any bugs, please inform me at vishnurajanme@gmail.com Thank you",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeVertical*2),
                  ),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  width: SizeConfig.blockSizeVertical*20,
                )
              ],
            ).show();
          },
          child: const Icon(Icons.help_outline,
          size: 40),
          backgroundColor: Color(0xff0e1134),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffbabbe0), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                child: adContainer,
              ),
              Container(
                height: SizeConfig.screenHeight - SizeConfig._safeAreaVertical - myBanner.size.height.toDouble() - SizeConfig.appheight,
                child: StreamBuilder(
                  stream: db
                      .collection("users")
                      .doc(uid)
                      .collection("products")
                      //.where('name', isGreaterThanOrEqualTo: 'Oneplus')
                      .orderBy('date', descending: _descending)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text("Loading...");
                    return ListView.builder(
                      itemExtent: 80.0,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: ListTile(
                            onTap: () async {

                              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Screen3(snapshot.data.docs[index])));

                              print("Name: ${snapshot.data.docs[index]['name']}\n"
                                  "Purchase Price: ${snapshot.data.docs[index]['purchase']}\n"
                                  "Sale Price: ${snapshot.data.docs[index]['sale']}\n"
                                  "Remarks: ${snapshot.data.docs[index]['remark']}\n"
                                  "Date: ${snapshot.data.docs[index]['date']}\n"
                                  "Profit: ${snapshot.data.docs[index]['profit']}\n  ");
                            },
                            title: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          size: 35,
                                        ),
                                        Text(
                                          "${snapshot.data.docs[index]["date"]}",
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              fontSize: 7),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${snapshot.data.docs[index]["name"]}",
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(1),
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "${snapshot.data.docs[index]["remark"]}",
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.monetization_on,
                                              color: Colors.white54,
                                              size: 26,
                                            ),
                                            Text(
                                                "${snapshot.data.docs[index]["profit"]}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(1),
                                                    fontSize: 18)),
                                          ],
                                        ),
                                        Text(
                                            "${snapshot.data.docs[index]["sale"]} - ${snapshot.data.docs[index]["purchase"]}",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(1),
                                                fontSize: 10)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
