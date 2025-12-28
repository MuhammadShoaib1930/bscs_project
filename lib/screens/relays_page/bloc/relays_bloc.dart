import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'relays_event.dart';
part 'relays_state.dart';

class RelaysBloc extends Bloc<RelaysEvent, RelaysState> {
  Map<String, dynamic> relays = {};
  RelaysBloc() : super(RelaysState.initial()) {
    on<OnChangeRelayStatus>(_onChangeRelayStatus);
    on<ChangeSettingRelays>(_changeSettingRelays);
    on<GetDataFromFirebase>(_getDataFromFirebase);
  }

  FutureOr<void> _onChangeRelayStatus(OnChangeRelayStatus event, Emitter<RelaysState> emit) async {
    if (event.index == 1) {
      await FirebaseDatabase.instance.ref('relay/r1/status').set(!state.isOn1);
      emit(state.copyWith(isOn1: event.isTrue));
    } else if (event.index == 2) {
      await FirebaseDatabase.instance.ref('relay/r2/status').set(!state.isOn2);
      emit(state.copyWith(isOn2: event.isTrue));
    } else if (event.index == 3) {
      await FirebaseDatabase.instance.ref('relay/r3/status').set(!state.isOn3);
      emit(state.copyWith(isOn3: event.isTrue));
    } else if (event.index == 4) {
      await FirebaseDatabase.instance.ref('relay/r4/status').set(!state.isOn4);
      emit(state.copyWith(isOn4: event.isTrue));
    } else {
      emit(state.copyWith());
    }
    add(GetDataFromFirebase());
  }

  FutureOr<void> _changeSettingRelays(ChangeSettingRelays event, Emitter<RelaysState> emit) async {
    if (event.index == 1) {
      final ref = FirebaseDatabase.instance.ref("relay/r1");
      await ref.update({
        "power_watt": event.initialPower,
        "target_kwh": event.initialTarget,
        "start_time": event.startTime,
        "end_time": event.endTime,
      });

      emit(
        state.copyWith(
          power1: event.initialPower,
          target1: event.initialTarget,
          currentKwh1: event.currentKwh,
          startTime1: event.startTime,
          endTime1: event.endTime,
        ),
      );
    } else if (event.index == 2) {
      final ref = FirebaseDatabase.instance.ref("relay/r2");
      await ref.update({
        "power_watt": event.initialPower,
        "target_kwh": event.initialTarget,
        "start_time": event.startTime,
        "end_time": event.endTime,
      });
      emit(
        state.copyWith(
          power2: event.initialPower,
          target2: event.initialTarget,
          currentKwh2: event.currentKwh,
          startTime2: event.startTime,
          endTime2: event.endTime,
        ),
      );
    } else if (event.index == 3) {
      final ref = FirebaseDatabase.instance.ref("relay/r3");
      await ref.update({
        "power_watt": event.initialPower,
        "target_kwh": event.initialTarget,
        "start_time": event.startTime,
        "end_time": event.endTime,
      });
      emit(
        state.copyWith(
          power3: event.initialPower,
          target3: event.initialTarget,
          currentKwh3: event.currentKwh,
          startTime3: event.startTime,
          endTime3: event.endTime,
        ),
      );
    } else if (event.index == 4) {
      final ref = FirebaseDatabase.instance.ref("relay/r4");
      await ref.update({
        "power_watt": event.initialPower,
        "target_kwh": event.initialTarget,
        "start_time": event.startTime,
        "end_time": event.endTime,
      });
      emit(
        state.copyWith(
          power4: event.initialPower,
          target4: event.initialTarget,
          currentKwh4: event.currentKwh,
          startTime4: event.startTime,
          endTime4: event.endTime,
        ),
      );
    } else {
      emit(state.copyWith());
    }
  }

  FutureOr<void> _getDataFromFirebase(GetDataFromFirebase event, Emitter<RelaysState> emit) async {
    Map<String, dynamic> relays = await _loadRelayData();
    emit(
      RelaysState(
        isOn1: relays["r1"]["status"],
        power1: relays["r1"]["power_watt"],
        target1: (relays["r1"]["target_kwh"] as num).toDouble(),
        startTime1: relays["r1"]["start_time"],
        currentKwh1: (relays["r1"]["consumed_kwh"] as num).toDouble(),
        endTime1: relays["r1"]["end_time"],
        isOn2: relays["r2"]["status"],
        power2: relays["r2"]["power_watt"],
        target2: (relays["r2"]["target_kwh"] as num).toDouble(),
        startTime2: relays["r2"]["start_time"],
        currentKwh2: (relays["r2"]["consumed_kwh"] as num).toDouble(),
        endTime2: relays["r2"]["end_time"],
        isOn3: relays["r3"]["status"],
        power3: relays["r3"]["power_watt"],
        target3: (relays["r3"]["target_kwh"] as num).toDouble(),
        startTime3: relays["r3"]["start_time"],
        currentKwh3: (relays["r3"]["consumed_kwh"] as num).toDouble(),
        endTime3: relays["r3"]["end_time"],
        isOn4: relays["r4"]["status"],
        power4: relays["r4"]["power_watt"],
        target4: (relays["r4"]["target_kwh"] as num).toDouble(),
        startTime4: relays["r4"]["start_time"],
        currentKwh4: (relays["r4"]["consumed_kwh"] as num).toDouble(),
        endTime4: relays["r4"]["end_time"],
      ),
    );
  }

  Future<Map<String, dynamic>> _loadRelayData() async {
    final ref = FirebaseDatabase.instance.ref("relay");
    final snapshot = await ref.get();
    if (snapshot.exists) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return {};
  }
}
