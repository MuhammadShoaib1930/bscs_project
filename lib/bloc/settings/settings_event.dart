import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {}

class ChangeFontSizeEvent extends SettingsEvent {
  final double fontSize;
  ChangeFontSizeEvent(this.fontSize);

  @override
  List<Object?> get props => [fontSize];
}

class ChangeFontFamilyEvent extends SettingsEvent {
  final String fontFamily;
  ChangeFontFamilyEvent(this.fontFamily);

  @override
  List<Object?> get props => [fontFamily];
}

class ToggleOnlineModeEvent extends SettingsEvent {}
