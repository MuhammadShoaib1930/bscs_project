import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';
import '../../hive/hive_manager.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(isDarkMode: false, fontSize: 16, fontFamily: 'Roboto')) {
    on<LoadSettingsEvent>((event, emit) {
      final box = HiveManager.getSettingsBox();
      emit(
        SettingsState(
          isDarkMode: box.get('isDarkMode', defaultValue: false),
          fontSize: box.get('fontSize', defaultValue: 16.0),
          fontFamily: box.get('fontFamily', defaultValue: 'Roboto'),
        ),
      );
    });

    on<ToggleDarkModeEvent>((event, emit) {
      final box = HiveManager.getSettingsBox();
      final newMode = !state.isDarkMode;
      box.put('isDarkMode', newMode);
      emit(state.copyWith(isDarkMode: newMode));
    });

    on<ChangeFontSizeEvent>((event, emit) {
      final box = HiveManager.getSettingsBox();
      box.put('fontSize', event.fontSize);
      emit(state.copyWith(fontSize: event.fontSize));
    });

    on<ChangeFontFamilyEvent>((event, emit) {
      final box = HiveManager.getSettingsBox();
      box.put('fontFamily', event.fontFamily);
      emit(state.copyWith(fontFamily: event.fontFamily));
    });
  }
}
