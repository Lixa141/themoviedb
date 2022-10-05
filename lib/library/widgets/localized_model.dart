import 'package:flutter/material.dart';

class LocalizedModelStorage {
  String _localeTag = '';

  String get localTag => _localeTag;

  bool updateLocale(Locale locale) {
    final localeTag = locale.toLanguageTag();
    if (_localeTag == localeTag) return false;
    _localeTag = localeTag;
    return true;
  }
}