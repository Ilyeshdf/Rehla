import 'dart:math';

class Booking {
  final String referenceNumber;
  final String placeName;
  final String category;
  final String fullName;
  final String phoneNumber;
  final DateTime date;
  final int numberOfGuests;
  final String status;
  final String? guideId;
  final String bookingType;

  Booking({
    String? referenceNumber,
    required this.placeName,
    required this.category,
    required this.fullName,
    required this.phoneNumber,
    required this.date,
    required this.numberOfGuests,
    this.status = 'جديد',
    this.guideId,
    this.bookingType = 'place',
  }) : referenceNumber = referenceNumber ?? _generateReference();

  static String _generateReference() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  Booking copyWith({String? status, String? guideId, String? bookingType}) {
    return Booking(
      referenceNumber: referenceNumber,
      placeName: placeName,
      category: category,
      fullName: fullName,
      phoneNumber: phoneNumber,
      date: date,
      numberOfGuests: numberOfGuests,
      status: status ?? this.status,
      guideId: guideId ?? this.guideId,
      bookingType: bookingType ?? this.bookingType,
    );
  }
}
