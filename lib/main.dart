import 'dart:async';
import 'dart:convert';
import './coinmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'coincard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<CoinModel>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(CoinModel.fromJason(map));
          }
        }
        print(coinList.first.name);
        print(coinList.last.name);
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to Load Coins');
    }
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) => fetchCoin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          title: Text(
            "CRYPTO PRICE TRACKER",
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              return CoinCard(
                  name: coinList[index].name,
                  symbol: coinList[index].symbol,
                  imgUrl: coinList[index].imgUrl,
                  price: coinList[index].price.toDouble(),
                  change: coinList[index].change.toDouble(),
                  changePercentage: coinList[index].changePercentage.toDouble(),
                  height: height,
                  width: width);
            }));
  }
}
