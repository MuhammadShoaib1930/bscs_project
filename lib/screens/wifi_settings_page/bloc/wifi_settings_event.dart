part of 'wifi_settings_bloc.dart';

sealed class WifiSettingsEvent extends Equatable {
  const WifiSettingsEvent();

  @override
  List<Object> get props => [];
}

class GetWifiFromFiebase extends WifiSettingsEvent {}

class SetWifiSsidPassword extends WifiSettingsEvent {
  final String ssid;
  final String password;
  const SetWifiSsidPassword({required this.ssid, required this.password});
    @override
  List<Object> get props => [ssid,password];
}
