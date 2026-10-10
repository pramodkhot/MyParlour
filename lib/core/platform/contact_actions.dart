import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../format/phone.dart';

/// Opens the phone's dialer, SMS app, WhatsApp or share sheet. Each method
/// returns false when nothing on the phone could handle it, so the screen
/// can show a message.
class ContactActions {
  const ContactActions();

  Future<bool> call(String phone) =>
      _open(Uri(scheme: 'tel', path: _dial(phone)));

  Future<bool> sms(String phone) =>
      _open(Uri(scheme: 'sms', path: _dial(phone)));

  /// Opens `https://wa.me/91XXXXXXXXXX`.
  Future<bool> whatsApp(String phone) async {
    final uri = PhoneNumber.whatsAppUri(phone);
    if (uri == null) return false;
    return _open(uri);
  }

  Future<bool> shareText(String text, {String? subject}) async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(text: text, subject: subject),
      );
      return result.status != ShareResultStatus.unavailable;
    } on Object {
      return false;
    }
  }

  static String _dial(String phone) {
    final n = PhoneNumber.normalise(phone);
    return n == null ? phone.trim() : '+91$n';
  }

  static Future<bool> _open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      return false;
    }
  }
}

final contactActionsProvider = Provider<ContactActions>(
  (ref) => const ContactActions(),
);
