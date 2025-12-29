part of 'wifi_settings_bloc.dart';

class WifiSettingsState extends Equatable {
  final String ssid;
  final String password;
  const WifiSettingsState({required this.ssid,required this.password});

  @override
  List<Object> get props => [ssid,password];
}
