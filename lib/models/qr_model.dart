import 'package:flutter/foundation.dart';

enum QRType {
  discount, // Скидка
  station, // Станция кампуса
  url, // Веб-ссылка
  text, // Текстовый QR
  contact, // Контактная информация
  wifi, // WiFi данные
  event, // Событие
  error, // Ошибка
}

@immutable
class QRCode {
  final String id;
  final String name;
  final String description;
  final String content;
  final QRType type;
  final double discountValue;
  final DateTime? expiryDate;
  final String? stationId;
  final int xpReward;
  final String? url;
  final String? businessName;
  final DateTime? scannedAt;

  const QRCode({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.type,
    this.discountValue = 0.0,
    this.expiryDate,
    this.stationId,
    this.xpReward = 10,
    this.url,
    this.businessName,
    this.scannedAt,
  });

  // Конструкторы для разных типов
  factory QRCode.discount({
    required String id,
    String name = 'Скидка',
    String description = '',
    double discountValue = 10.0,
    DateTime? expiryDate,
    String? businessName,
    DateTime? scannedAt,
  }) {
    return QRCode(
      id: id,
      name: name,
      description: description,
      content: 'discount:$id:$discountValue',
      type: QRType.discount,
      discountValue: discountValue,
      expiryDate: expiryDate,
      businessName: businessName,
      scannedAt: scannedAt,
    );
  }

  factory QRCode.station({
    required String id,
    required String stationId,
    String name = 'Станция',
    String description = '',
    int xpReward = 15,
    DateTime? scannedAt,
  }) {
    return QRCode(
      id: id,
      name: name,
      description: description,
      content: 'station:$stationId',
      type: QRType.station,
      stationId: stationId,
      xpReward: xpReward,
      scannedAt: scannedAt,
    );
  }

  factory QRCode.url({
    required String id,
    required String url,
    String name = 'Ссылка',
    String description = '',
    DateTime? scannedAt,
  }) {
    return QRCode(
      id: id,
      name: name,
      description: description,
      content: url,
      type: QRType.url,
      url: url,
      scannedAt: scannedAt,
    );
  }

  factory QRCode.text({
    required String id,
    required String content,
    String name = 'Текст',
    String description = '',
    DateTime? scannedAt,
  }) {
    return QRCode(
      id: id,
      name: name,
      description: description,
      content: content,
      type: QRType.text,
      scannedAt: scannedAt,
    );
  }

  factory QRCode.contact({
    required String id,
    required String name,
    required String description,
    required String content,
    DateTime? scannedAt,
  }) {
    return QRCode(
      id: id,
      name: name,
      description: description,
      content: content,
      type: QRType.contact,
      scannedAt: scannedAt,
    );
  }

  factory QRCode.error(String content) {
    return QRCode(
      id: 'error_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Ошибка',
      description: 'Не удалось распознать QR-код',
      content: content,
      type: QRType.error,
    );
  }

  factory QRCode.fromJson(Map<String, dynamic> json) {
    return QRCode(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      type: QRType.values.firstWhere(
        (t) => t.toString().split('.').last == json['type'] as String,
        orElse: () => QRType.text,
      ),
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      stationId: json['stationId'] as String?,
      xpReward: json['xpReward'] as int? ?? 10,
      url: json['url'] as String?,
      businessName: json['businessName'] as String?,
      scannedAt: json['scannedAt'] != null
          ? DateTime.parse(json['scannedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'type': type.toString().split('.').last,
      'discountValue': discountValue,
      'expiryDate': expiryDate?.toIso8601String(),
      'stationId': stationId,
      'xpReward': xpReward,
      'url': url,
      'businessName': businessName,
      'scannedAt': scannedAt?.toIso8601String(),
    };
  }

  bool get isStation => type == QRType.station;
  bool get isDiscount => type == QRType.discount;
  bool get isURL => type == QRType.url;
  bool get isText => type == QRType.text;
  bool get isValid => type != QRType.error;

  String get formattedDate {
    if (scannedAt == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scanDate =
        DateTime(scannedAt!.year, scannedAt!.month, scannedAt!.day);

    if (scanDate == today) {
      return 'Сегодня, ${_formatTime(scannedAt!)}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (scanDate == yesterday) {
      return 'Вчера, ${_formatTime(scannedAt!)}';
    }

    return '${_formatDate(scannedAt!)}, ${_formatTime(scannedAt!)}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

@immutable
class QRStation {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> location;
  final int points;
  final bool isCompleted;
  final DateTime? completedAt;
  final List<String> requiredItems;
  final String qrData;

  const QRStation({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    this.points = 15,
    this.isCompleted = false,
    this.completedAt,
    this.requiredItems = const [],
    required this.qrData,
  });

  factory QRStation.fromJson(Map<String, dynamic> json) {
    return QRStation(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      location: Map<String, dynamic>.from(json['location']),
      points: json['points'] as int? ?? 15,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      requiredItems: List<String>.from(json['requiredItems'] ?? []),
      qrData: json['qrData'] as String? ?? 'station:${json['id']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'points': points,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'requiredItems': requiredItems,
      'qrData': qrData,
    };
  }

  QRCode toQRCode() {
    return QRCode.station(
      id: 'station_$id',
      stationId: id,
      name: name,
      description: description,
      xpReward: points,
    );
  }
}

@immutable
class QRPartner {
  final String id;
  final String name;
  final String description;
  final String category;
  final double discount;
  final String qrData;
  final DateTime? expiryDate;
  final String? logoUrl;
  final String? address;
  final String? phone;
  final String? website;

  const QRPartner({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.discount,
    required this.qrData,
    this.expiryDate,
    this.logoUrl,
    this.address,
    this.phone,
    this.website,
  });

  factory QRPartner.fromJson(Map<String, dynamic> json) {
    return QRPartner(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      discount: (json['discount'] as num).toDouble(),
      qrData: json['qrData'] as String,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      logoUrl: json['logoUrl'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'discount': discount,
      'qrData': qrData,
      'expiryDate': expiryDate?.toIso8601String(),
      'logoUrl': logoUrl,
      'address': address,
      'phone': phone,
      'website': website,
    };
  }

  QRCode toQRCode() {
    return QRCode.discount(
      id: 'partner_$id',
      name: 'Скидка $discount% от $name',
      description: description,
      discountValue: discount,
      expiryDate: expiryDate,
      businessName: name,
    );
  }
}
