import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  String _totalConfirmed;
  String _totalDeaths;
  String _totalRecovered;

  @override
  void initState() {
    super.initState();
    String url = 'https://coronastats-backend.herokuapp.com/stats';
    http.get(url).then((http.Response response) {
      print('Response: ' +
          response.body +
          ' Status code: ' +
          response.statusCode.toString());
      final responseJson = json.decode(response.body);
      setState(() {
        _totalConfirmed = responseJson['cases'];
        _totalDeaths = responseJson['deaths'];
        _totalRecovered = responseJson['recovered'];
      });
    });
  }

  Future<void> _refreshData() async {
    print('Refreshing data');
    initState();
    print('Updated data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171717),
      body: Container(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 18, left: 20, bottom: 6),
                child: Text(
                  'Statistics',
                  style: TextStyle(
                    color: Color(0xffDDDDDD),
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 2,
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    DataTile(
                      name: 'total confirmed',
                      data: _totalConfirmed,
                      textColor: Color(0xffFF6262),
                    ),
                    DataTile(
                      name: 'total deaths',
                      data: _totalDeaths,
                      textColor: Color(0xffB9B9B9),
                    ),
                    DataTile(
                      name: 'total recovered',
                      data: _totalRecovered,
                      textColor: Color(0xff71FFAE),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataTile extends StatelessWidget {
  String data;
  String name;
  Color textColor;

  DataTile(
      {@required this.name, @required this.data, @required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff3B3B3B),
                Color(0xff1C1C1C),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 5,
                    color: Color(0xffD0D0D0),
                    fontWeight: FontWeight.w700,
                  ),
                  textScaleFactor: 0.8,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(36),
                  child: Text(
                    data ??= '',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textScaleFactor: 3.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
