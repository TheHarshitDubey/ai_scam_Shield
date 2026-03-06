class ScanModel {
  final int id;
  final String message;
  final bool isScam;
  final double confidence;
  final String reply;
  final String timestamp;

  ScanModel({
    required this.id,
    required this.message,
    required this.isScam,
    required this.confidence,
    required this.reply,
    required this.timestamp,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    return ScanModel(
      id: json["id"],
      message: json["message"],
      isScam: json["is_scam"],
      confidence: json["confidence"],
      reply: json["reply"],
      timestamp: json["timestamp"],
    );
  }
}