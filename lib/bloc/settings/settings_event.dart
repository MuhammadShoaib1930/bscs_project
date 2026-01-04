abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {}

class ChangeFontSizeEvent extends SettingsEvent {
  final double fontSize;
  ChangeFontSizeEvent(this.fontSize);
}

class ChangeFontFamilyEvent extends SettingsEvent {
  final String fontFamily;
  ChangeFontFamilyEvent(this.fontFamily);
}
