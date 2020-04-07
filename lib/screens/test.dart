import 'package:covid19/models/current.dart';
import 'package:covid19/models/covid_summary.dart';
import 'package:covid19/service/covid_service.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'dart:async' show Future;

class Test extends StatefulWidget {
  static final String id = "Test";

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isSearching = false;
  final RefreshController refreshController = RefreshController();
  Future<CurrentStats> currentStats;
  Future<CovidSummary> covidSummary;
  String filterText;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    covidSummary = fetchCovidSummary();
    currentStats = fetchCurrentStats();
    searchController.addListener(search);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void search() {
    setState(() {
      filterText = searchController.text;
    });
  }

  void getData() {
    setState(() {
      covidSummary = fetchCovidSummary();
      currentStats = fetchCurrentStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      home: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: double.infinity,
            child: SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              onRefresh: () async {
                Future.delayed(Duration(seconds: 1));
                setState(() {
                  covidSummary = fetchCovidSummary();
                  currentStats = fetchCurrentStats();
                });
                refreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    buildSearchBar(context),
                    buildWorldSummaryContainer(context),
                    buildCountryList(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWorldSummaryContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: FutureBuilder<CovidSummary>(
        future: covidSummary,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    summaryCard(context, "Confirmed", snapshot.data.confirmed,
                        Colors.blue),
                    summaryCard(context, "Recovered", snapshot.data.recovered,
                        Colors.green),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                summaryCard(
                    context, "Deaths", snapshot.data.deaths, Colors.red),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget summaryCard(
      BuildContext context, String title, int count, Color indicatorColor) {
    return Card(
      elevation: 5.0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: indicatorColor,
              width: 3.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width / 3,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: indicatorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 23),
              hintText: "Search Country"),
        ),
      ),
    );
  }

  Widget buildCountryList(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder<CurrentStats>(
        future: currentStats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildCountryListHelper(context, snapshot.data.data);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Align(
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildCountryListHelper(BuildContext context, List<Current> items) {
    if (filterText != "" && filterText != null) {
      items = items
          .where((item) =>
              item.location.toLowerCase().contains(filterText.toLowerCase()))
          .toList();
    }
    print("Length ${items.length}");
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(
            items[index].location,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.only(bottom: 8.0),
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    subHeaderRow(
                        "Confirmed:", items[index].confirmed.toString()),
                    subHeaderRow(
                        "Recoverd:", items[index].recovered.toString()),
                    subHeaderRow("Deaths:", items[index].deaths.toString()),
                    subHeaderRow(
                        "Recovery rate:",
                        getPercent(
                            items[index].confirmed, items[index].recovered)),
                    subHeaderRow(
                        "Death rate:",
                        getPercent(
                            items[index].confirmed, items[index].deaths)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget subHeaderRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: subHeadingStyle,
        ),
        Text(
          value,
          style: subHeadingStyle,
        ),
      ],
    );
  }
}

const TextStyle subHeadingStyle = TextStyle(
  color: Colors.grey,
  fontSize: 12.0,
);

String getPercent(total, amount) {
  double percent = (amount / total) * 100;
  return percent.toStringAsFixed(2);
}
