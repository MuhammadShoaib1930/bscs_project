import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wifi_settings_event.dart';
part 'wifi_settings_state.dart';

class WifiSettingsBloc extends Bloc<WifiSettingsEvent, WifiSettingsState> {
  WifiSettingsBloc() : super(WifiSettingsState(ssid: "", password: "")) {
    on<GetWifiFromFiebase>(_getWifiFromFiebase);
    on<SetWifiSsidPassword>(_setWifiSsidPassword);
  }

  FutureOr<void> _setWifiSsidPassword(SetWifiSsidPassword event, Emitter<WifiSettingsState> emit) {
    _setWiFiCredentials(event.ssid, event.password);
    add(GetWifiFromFiebase());
  }

  FutureOr<void> _getWifiFromFiebase(
    GetWifiFromFiebase event,
    Emitter<WifiSettingsState> emit,
  ) async {
    Map<String, String> wifi = await _getWifi();

    emit(WifiSettingsState(ssid: wifi['ssid'] ?? "", password: wifi['password'] ?? ""));
  }

  Future<Map<String, String>> _getWifi() async {
    final ref = FirebaseDatabase.instance.ref("wifi");
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value is! Map) {
      return {"ssid": "", "password": ""};
    }
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return {"ssid": data["ssid"] as String? ?? "", "password": data["password"] as String? ?? ""};
  }

  Future<void> _setWiFiCredentials(String ssid, String password) async {
    final ref = FirebaseDatabase.instance.ref("wifi");
    await ref.set({"ssid": ssid, "password": password});
  }
}
