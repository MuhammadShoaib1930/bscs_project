import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../hive/settings_model.dart';
import '../../constants/app_constants.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final Box<SettingsModel> box = Hive.box<SettingsModel>(AppConstants.settingModel);
  final String key = AppConstants.settingkey;

  SettingsBloc()
    : super(
        SettingsState(
          settingsModel: SettingsModel(
            fontSize: 16,
            fontFamily: 'Roboto',
            isDarkMode: false,
            isOnline: false
          ),
        ),
      ) {
    on<LoadSettingsEvent>((event, emit) {
      final storedSettings = box.get(key);
      if (storedSettings != null) {
        emit(SettingsState(settingsModel: storedSettings));
      } else {
        box.put(key, state.settingsModel);
        emit(SettingsState(settingsModel: state.settingsModel));
      }
    });

    on<ToggleDarkModeEvent>((event, emit) {
      final newSettings = state.settingsModel.copyWith(isDarkMode: !state.settingsModel.isDarkMode);
      box.put(key, newSettings);
      emit(state.copyWith(settingsModel: newSettings));
    });

    on<ChangeFontSizeEvent>((event, emit) {
      final newSettings = state.settingsModel.copyWith(fontSize: event.fontSize);
      box.put(key, newSettings);
      emit(state.copyWith(settingsModel: newSettings));
    });

    on<ChangeFontFamilyEvent>((event, emit) {
      final newSettings = state.settingsModel.copyWith(fontFamily: event.fontFamily);
      box.put(key, newSettings);
      emit(state.copyWith(settingsModel: newSettings));
    });

    on<ToggleOnlineModeEvent>((event, emit) {
      final newSettings = state.settingsModel.copyWith(isOnline: !state.settingsModel.isOnline);
      box.put(key, newSettings);
      emit(state.copyWith(settingsModel: newSettings));
    });
  }
}
