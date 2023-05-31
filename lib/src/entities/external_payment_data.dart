class ExternalPaymentData {
  String title;
  String value;

  ExternalPaymentData({
    required this.title,
    required this.value
  });

  static ExternalPaymentData fromMap(dynamic map) {
    return ExternalPaymentData(
      title: map['title'],
      value: map['value']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value
    };
  }
}
