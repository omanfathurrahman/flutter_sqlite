class Saham {
  final int? tickerid;
  final String ticker;
  final int open;
  final int high;
  final int last;
  final String change;

  Saham(
      {this.tickerid,
      required this.ticker,
      required this.open,
      required this.high,
      required this.last,
      required this.change});

  Saham.fromMap(Map<String, dynamic> res)
      : tickerid = res["tickerid"],
        ticker = res["ticker"],
        open = res["open"],
        high = res["high"],
        last = res["last"],
        change = res["change"];

  Map<String, Object?> toMap() {
    return {
      'tickerid': tickerid,
      'ticker': ticker,
      'open': open,
      'high': high,
      'last': last,
      'change': change
    };
  }
}
