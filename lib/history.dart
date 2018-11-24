import 'package:flutter/material.dart';
import 'data.dart';
import 'camera.dart';
import 'receipt.dart';

enum sortType {
  store_a_z,
  store_z_a,
  total_asc,
  total_desc,
  date_new,
  date_old
}

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
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Container(
                child: Text(
                  total,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Container(
                child: Text(
                  date,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
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

  sortTotal(bool isDes) {
    if (isDes) {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) => a.total.compareTo(b.total));
      createList(totalSorted);
      return;
    } else {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) => b.total.compareTo(a.total));
      createList(totalSorted);
      return;
    }
  }

  sortStore(bool isDes) {
    if (isDes) {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) => a.store.compareTo(b.store));
      createList(totalSorted);
      return;
    } else {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) => b.store.compareTo(a.store));
      createList(totalSorted);
      return;
    }
  }

  sortDate(bool isDes) {
    if (isDes) {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) {
          List<String> aSplit = a.date.split('.');
          DateTime aDate = DateTime(
              int.parse(aSplit[2]), int.parse(aSplit[1]), int.parse(aSplit[0]));

          List<String> bSplit = b.date.split('.');
          DateTime bDate = DateTime(
              int.parse(bSplit[2]), int.parse(bSplit[1]), int.parse(bSplit[0]));
          return aDate.compareTo(bDate);
        });
      createList(totalSorted);
      return;
    } else {
      List<Receipt> totalSorted = receipts
        ..sort((a, b) {
          List<String> aSplit = a.date.split('.');
          DateTime aDate = DateTime(
              int.parse(aSplit[2]), int.parse(aSplit[1]), int.parse(aSplit[0]));

          List<String> bSplit = b.date.split('.');
          DateTime bDate = DateTime(
              int.parse(bSplit[2]), int.parse(bSplit[1]), int.parse(bSplit[0]));
          return bDate.compareTo(aDate);
        });
      createList(totalSorted);
      return;
    }
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
          PopupMenuButton<sortType>(
            icon: Icon(Icons.sort),
            onSelected: (sortType result) {
              if (result == sortType.store_a_z) {
                sortStore(true);
              } else if (result == sortType.store_z_a) {
                sortStore(false);
              } else if (result == sortType.total_asc) {
                sortTotal(true);
              } else if (result == sortType.total_desc) {
                sortTotal(false);
              } else if (result == sortType.date_new) {
                sortDate(false);
              } else if (result == sortType.date_old) {
                sortDate(true);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<sortType>>[
                  const PopupMenuItem<sortType>(
                    value: sortType.store_a_z,
                    child: Text('Store: A - Z'),
                  ),
                  const PopupMenuItem<sortType>(
                    value: sortType.store_z_a,
                    child: Text('Store: Z - A'),
                  ),
                  const PopupMenuItem<sortType>(
                    value: sortType.total_asc,
                    child: Text('Total: Asc'),
                  ),
                  const PopupMenuItem<sortType>(
                    value: sortType.total_desc,
                    child: Text('Total: Desc'),
                  ),
                  const PopupMenuItem<sortType>(
                    value: sortType.date_new,
                    child: Text('Date: Most Recent'),
                  ),
                  const PopupMenuItem<sortType>(
                    value: sortType.date_old,
                    child: Text('Date: Oldest'),
                  ),
                ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CameraApp()));
            },
            icon: Icon(Icons.camera_alt),
          ),
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
                  )),
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
