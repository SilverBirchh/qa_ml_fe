import 'package:flutter/material.dart';
import 'data.dart';
import 'camera.dart';
import 'receipt.dart';

class HistoryScreen extends StatefulWidget {
  @override
  HistoryScreenState createState() {
    return new HistoryScreenState();
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  final _historyScaffoldKey = GlobalKey<ScaffoldState>();

  List<Receipt> receipts = [];

  List<Widget> listChildren = [];

  createList(List<Receipt> receipts) {
    List<Widget> children = [];

    receipts.forEach((receipt) {
      String store = receipt.store;
      String date = receipt.date;
      String total = receipt.total.toString();

      Widget child = ListTile(
        contentPadding: EdgeInsets.all(0.0),
        title: Container(
          padding: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  store,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20.0),
                ),
              ),
              Container(
                child: Text(
                  total,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20.0),
                ),
              ),
              Container(
                child: Text(
                  date,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      );
      children.add(child);
    });

    setState(() {
      listChildren = children;
    });
  }

  @override
  void initState() {
    super.initState();
    receipts = []..addAll(Data.receipts);
    createList(receipts);
  }

  @override
  Widget build(BuildContext context) {
    String entireTotal = Data.receipts
        .map((receipt) => receipt.total)
        .reduce((value, element) => value + element)
        .toStringAsFixed(2);

    return Scaffold(
      key: _historyScaffoldKey,
      appBar: AppBar(
        title: Text('Purchase History'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CameraApp()));
            },
            icon: Icon(Icons.camera_alt),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Store',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 25.0),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Total (£)',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 25.0),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 25.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: listChildren,
                )
              ),
            ],
          ),
          Positioned(
            bottom: 0.0,
            child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      // top: BorderSide(color: Colors.grey,),
                      ),
                ),
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                    Text(
                      '£$entireTotal',
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
