class CoinModel {
  CoinModel({
    required this.name,
    required this.symbol,
    required this.imgUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });

  String name;
  String symbol;
  String imgUrl;
  num price;
  num change;
  num changePercentage;

  factory CoinModel.fromJason(Map<String, dynamic> json) {
    return CoinModel(
      name: json['name'],
      symbol: json['symbol'],
      imgUrl: json['image'],
      price: json['current_price'],
      change: json['price_change_24h'],
      changePercentage: json['price_change_percentage_24h'],
    );
  }
}

List<CoinModel> coinList = [];
