import 'package:url_launcher/url_launcher.dart';
import '../models/itinerary_model.dart';

class WhatsAppService {
  static Future<void> shareItinerary(Itinerary itinerary) async {
    final buffer = StringBuffer();
    buffer.writeln('رحلتي إلى ${itinerary.destination} 🧳');
    buffer.writeln();

    for (final day in itinerary.days) {
      buffer.writeln(
          'اليوم ${day.day}: صباح: ${day.morning.place} | عشية: ${day.afternoon.place} | ليل: ${day.evening.place}');
    }

    buffer.writeln();
    buffer.writeln('تم التخطيط بواسطة تطبيق رحلة 🇩🇿');

    final text = Uri.encodeComponent(buffer.toString());
    final url = 'whatsapp://send?text=$text';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {

        final webUrl = 'https://wa.me/?text=$text';
        await launchUrl(Uri.parse(webUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {

    }
  }

  static Future<void> shareBookingConfirmation({
    required String placeName,
    required String reference,
    required String date,
    required int guests,
  }) async {
    final text = Uri.encodeComponent(
      'تأكيد حجز 🎉\n'
      'المكان: $placeName\n'
      'المرجع: $reference\n'
      'التاريخ: $date\n'
      'عدد الأشخاص: $guests\n\n'
      'تم الحجز عبر تطبيق رحلة 🇩🇿',
    );

    final url = 'whatsapp://send?text=$text';
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        final webUrl = 'https://wa.me/?text=$text';
        await launchUrl(Uri.parse(webUrl),
            mode: LaunchMode.externalApplication);
      }
    } catch (e) {

    }
  }
}
