class MetalRateModel {
  final String metalRateId;
  final String entryDate;
  final String entryTime;
  final MetalRates rates;

  MetalRateModel({
    required this.metalRateId,
    required this.entryDate,
    required this.entryTime,
    required this.rates,
  });

  factory MetalRateModel.fromJson(Map<String, dynamic> json) {
    return MetalRateModel(
      metalRateId: json['metalRateId'] as String,
      entryDate: json['entryDate'] as String,
      entryTime: json['entryTime'] as String,
      rates: MetalRates.fromJson(json['rates'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metalRateId': metalRateId,
      'entryDate': entryDate,
      'entryTime': entryTime,
      'rates': rates.toJson(),
    };
  }
}

class MetalRates {
  final double barRate;
  final double boardRate;
  final double oldGoldRate;
  final double silverRate;
  final double oldSilverRate;
  final double platinumRate;
  final double metalRate;
  final double metalRate14k;

  MetalRates({
    required this.barRate,
    required this.boardRate,
    required this.oldGoldRate,
    required this.silverRate,
    required this.oldSilverRate,
    required this.platinumRate,
    required this.metalRate,
    required this.metalRate14k,
  });

  factory MetalRates.fromJson(Map<String, dynamic> json) {
    return MetalRates(
      barRate: (json['barRate'] as num).toDouble(),
      boardRate: (json['boardRate'] as num).toDouble(),
      oldGoldRate: (json['oldGoldRate'] as num).toDouble(),
      silverRate: (json['silverRate'] as num).toDouble(),
      oldSilverRate: (json['oldSilverRate'] as num).toDouble(),
      platinumRate: (json['platinumRate'] as num).toDouble(),
      metalRate: (json['metalRate'] as num).toDouble(),
      metalRate14k: (json['metalRate14k'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barRate': barRate,
      'boardRate': boardRate,
      'oldGoldRate': oldGoldRate,
      'silverRate': silverRate,
      'oldSilverRate': oldSilverRate,
      'platinumRate': platinumRate,
      'metalRate': metalRate,
      'metalRate14k': metalRate14k,
    };
  }
}
