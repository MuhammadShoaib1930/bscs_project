class SettingsState {
  final bool isDarkMode;
  final double fontSize;
  final String fontFamily;

  SettingsState({required this.isDarkMode, required this.fontSize, required this.fontFamily});

  SettingsState copyWith({bool? isDarkMode, double? fontSize, String? fontFamily}) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }
}
