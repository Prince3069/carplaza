class CarHistoryReport {
  final String vin;
  final int? accidentCount;
  final int? ownerCount;
  final int? serviceRecords;
  final bool? hasOpenRecalls;
  final String? lastReportDate;

  CarHistoryReport({
    required this.vin,
    this.accidentCount,
    this.ownerCount,
    this.serviceRecords,
    this.hasOpenRecalls,
    this.lastReportDate,
  });

  factory CarHistoryReport.fromJson(Map<String, dynamic> json) {
    return CarHistoryReport(
      vin: json['vin'] ?? '',
      accidentCount: json['accidentCount'] as int?,
      ownerCount: json['ownerCount'] as int?,
      serviceRecords: json['serviceRecords'] as int?,
      hasOpenRecalls: json['hasOpenRecalls'] as bool?,
      lastReportDate: json['lastReportDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'vin': vin,
        'accidentCount': accidentCount,
        'ownerCount': ownerCount,
        'serviceRecords': serviceRecords,
        'hasOpenRecalls': hasOpenRecalls,
        'lastReportDate': lastReportDate,
      };
}
