import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sheets_app/screen3.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'main.dart';
import 'model/form.dart';
import 'package:flutter/widgets.dart';
String sortitem = 'date';
String fromdate = '1900-01-01';
String todate = '2050-01-01';
String searchKey = "";

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

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget appBarTitle = new Text("Purchase History");
  Icon actionIcon = new Icon(Icons.search);

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
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
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
    void handleClick(String value) {
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
      switch (value) {
        case 'Date':
          sortitem = 'date';
          break;
        case 'Profit':
          sortitem = 'profit';
          break;
        case 'Purchase Price':
          sortitem = 'purchase';
          break;
        case 'Sale Price':
          sortitem = 'sale';
          break;
      }
    }

    Future<void> handleFilter(String value) async {
      sortitem = 'date';
      switch (value) {
        case 'From':

            DateTime date = DateTime(1900);
            FocusScope.of(context)
                .requestFocus(new FocusNode());

            date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            fromdate = date.toIso8601String().split('T').first;

          break;
        case 'To':

          DateTime date = DateTime(1900);
          FocusScope.of(context)
              .requestFocus(new FocusNode());

          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));

          todate = date.toIso8601String().split('T').first;

          break;
      }
    }

    myController.addListener(() {
      setState(() {
        searchKey = myController.text;
      });
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title:appBarTitle,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    IconButton(icon: actionIcon,onPressed:(){
                      setState(() {
                        if ( this.actionIcon.icon == Icons.search){
                          sortitem = "name";
                          this.actionIcon = new Icon(Icons.close);
                          this.appBarTitle = new TextField(
                            textCapitalization: TextCapitalization.none,
                            controller: myController,
                            style: new TextStyle(
                              color: Colors.white,
                            ),
                            decoration: new InputDecoration(
                                prefixIcon: new Icon(Icons.search, color: Colors.white),
                                hintText: "Search...",
                                hintStyle: new TextStyle(color: Colors.white)
                            ),
                          );}
                        else {
                          sortitem = 'date';
                          this.actionIcon = new Icon(Icons.search);
                          this.appBarTitle = new Text("Purchase History");
                        }

                      });
                    } ,),
                    PopupMenuButton<String>(
                      onSelected: handleFilter,
                      itemBuilder: (BuildContext context) {
                        return {'From', 'To'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: ListTile(
                              leading: Icon(Icons.date_range),
                              title: Text(choice),
                            ),
                          );
                        }).toList();
                      },
                      icon: Icon(Icons.filter_list),
                    ),
                    PopupMenuButton<String>(
                      onSelected: handleClick,
                      itemBuilder: (BuildContext context) {
                        return {'Date', 'Profit'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                      icon: Icon(Icons.sort),
                    ),
                  ],
                ),
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
              desc: "Tap an entry to modify or delete the same. Search, sort and datewise filtering can be availed by selecting appropriate options in this screen's appbar (Top portion). If you notice any bugs, please inform me at vishnurajanme@gmail.com Thank you",
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
                  stream: _mystream(),
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
  Stream<dynamic> _mystream() {
    if (sortitem == 'date') {
      return db
          .collection("users")
          .doc(uid)
          .collection("products")
          .orderBy(sortitem, descending: _descending)
          .where(sortitem, isGreaterThanOrEqualTo: fromdate)
          .where(sortitem, isLessThanOrEqualTo: todate)
          .snapshots();
    }
    else if (sortitem == 'name') {
      return db
          .collection("users")
          .doc(uid)
          .collection("products")
          .where(sortitem, isGreaterThanOrEqualTo: searchKey)
          .where(sortitem, isLessThan: searchKey +'z')
          .snapshots();
    }
    else return db
        .collection("users")
        .doc(uid)
        .collection("products")
        .orderBy(sortitem, descending: _descending)
        .snapshots();
  }
}