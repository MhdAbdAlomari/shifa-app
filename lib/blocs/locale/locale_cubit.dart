import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _supportedLanguageCodes = ['en', 'ar'];
const _prefsKey = 'shifa.locale';

/// Owns the app's active locale.
///
/// Defaults to the device's system locale when it's one we support (en
/// or ar), otherwise falls back to English. The chosen locale is
/// persisted so it survives app restarts; switching is immediate since
/// [MaterialApp.locale] rebuilds the tree on cubit state change.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_systemDefault());

  static Locale _systemDefault() {
    final systemCode = PlatformDispatcher.instance.locale.languageCode;
    return Locale(
      _supportedLanguageCodes.contains(systemCode) ? systemCode : 'en',
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && _supportedLanguageCodes.contains(saved)) {
      emit(Locale(saved));
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) return;
    emit(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}
