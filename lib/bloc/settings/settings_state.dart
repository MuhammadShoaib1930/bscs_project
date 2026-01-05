import 'package:equatable/equatable.dart';
import '../../hive/settings_model.dart';

class SettingsState extends Equatable {
  final SettingsModel settingsModel;

  const SettingsState({required this.settingsModel});

  SettingsState copyWith({SettingsModel? settingsModel}) {
    return SettingsState(settingsModel: settingsModel ?? this.settingsModel);
  }

  @override
  List<Object?> get props => [settingsModel];
}
