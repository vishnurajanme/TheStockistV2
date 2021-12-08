import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'main.dart';
import 'model/form.dart';

class FeedbackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              desc: "Press & hold an entry to delete it. You can find the sort option in top right corner. In case of any bugs, please write to vishnurajanme@gmail.com",
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  width: 120,
                )
              ],
            ).show();


          },
          child: const Icon(Icons.help_outline,
          size: 40,),
          backgroundColor: Color(0xff0e1134),
        ),
        body: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffbabbe0), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
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
                            onLongPress: () async {
                              Alert(
                                context: context,
                                title: "Delete Entry?",
                                desc:
                                    "Please confirm whether you need to delete the selected entry",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      await db.runTransaction(
                                          (Transaction myTransaction) async {
                                        await myTransaction.delete(snapshot
                                            .data.docs[index].reference);
                                      });

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                  ),
                                  DialogButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () => Navigator.of(context,
                                            rootNavigator: true)
                                        .pop(),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(116, 116, 191, 1.0),
                                      Color.fromRGBO(52, 138, 199, 1.0)
                                    ]),
                                  )
                                ],
                              ).show();
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
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color:
                                                    Colors.white.withOpacity(0.7),
                                                fontSize: 11),
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
