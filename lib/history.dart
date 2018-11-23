import 'package:flutter/material.dart';
import 'data.dart';
import 'camera.dart';

class HistoryScreen extends StatelessWidget {
  final _historyScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String entireTotal = Data.totals
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
                child: ListView.builder(
                  itemCount: Data.stores.length,
                  itemBuilder: (context, index) {
                    String store = Data.stores[index];
                    String date = Data.dates[index];
                    String total = Data.totals[index].toString();
                    return ListTile(
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
                        ));
                  },
                ),
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
