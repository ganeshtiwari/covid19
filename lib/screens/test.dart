import "package:flutter/material.dart";

class Test extends StatefulWidget {
  static final String id = "test_screen";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController searchController = new TextEditingController();
  String val = ""; 
  @override
  void initState() {
    super.initState(); 
    searchController.addListener(printTextField);
  }

  @override 
  void dispose() {
    searchController.dispose(); 
    super.dispose();
  }

  void printTextField() {
    setState(() {
      val = searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5.0,
                child: Container(
                  height: 75,
                  padding: EdgeInsets.all(8.0),
                  // width: MediaQuery.of(context)
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefix: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: InkWell(
                          child: Icon(
                            Icons.search,
                            size: 25.0,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: "Hello",
                    ),
                  ),
                ),
              ),
              Container(
                height: 100, 
                width: 300,
                color: Colors.grey, 
                child: Text(val), 
              )
            ],
          ),
        ),
      ),
    );
  }
}
