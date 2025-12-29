import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'door_window_exhaust_gas_event.dart';
part 'door_window_exhaust_gas_state.dart';

class DoorWindowExhaustGasBloc extends Bloc<DoorWindowExhaustGasEvent, DoorWindowExhaustGasState> {
  DoorWindowExhaustGasBloc()
    : super(
        DoorWindowExhaustGasState(
          door: 0,
          exhaust: 0,
          gasValue: 0,
          isRisk: false,
          window: 0,
          gasThreshold: 0,
          isThresholdEnable: false,
        ),
      ) {
    on<GetValuesFromFirebase>(_getValuesFromFirebase);
    on<ChangeDoorAngle>(_changeDoorAngle);
    on<ChangeWindowAngle>(_changeWindowAngle);
    on<ChangeExhaustSpeed>(_changeExhaustSpeed);
    on<ChangeGasThreshold>(_changeGasThreshold);
    on<IsThresholdEnable>(_isThresholdEnable);
  }

  FutureOr<void> _getValuesFromFirebase(
    GetValuesFromFirebase event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    Map<String, dynamic> loadedData = await loadControlData();
    emit(
      DoorWindowExhaustGasState(
        door: loadedData['door'],
        exhaust: loadedData['exhaust'],
        gasValue: loadedData['gasValue'],
        isRisk: loadedData['gasRisk'],
        window: loadedData['window'],
        gasThreshold: loadedData['gasThreshold'],
        isThresholdEnable: false,
      ),
    );
  }

  Future<Map<String, dynamic>> loadControlData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value is! Map) {
      return {
        "door": 0,
        "window": 0,
        "exhaust": 0,
        "gasValue": 0,
        "gasRisk": false,
        "gasThreshold": 400,
      };
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return {
      "door": data["door"] ?? 0, // 0–180
      "window": data["window"] ?? 0, // 0–180
      "exhaust": data["exhaust"] ?? 0, // 0–1023
      "gasValue": data["gas"]?["value"] ?? 0, // 0–1023
      "gasRisk": data["gas"]?["risk"] ?? false, // bool
      "gasThreshold": data["gas"]?["threshold"] ?? 400, // 0 to 1023
    };
  }

  FutureOr<void> _changeDoorAngle(
    ChangeDoorAngle event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("door").set(event.doorAngle);
    add(GetValuesFromFirebase());
  }

  FutureOr<void> _changeWindowAngle(
    ChangeWindowAngle event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("window").set(event.windowAngle);
    add(GetValuesFromFirebase());
  }

  FutureOr<void> _changeExhaustSpeed(
    ChangeExhaustSpeed event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("exhaust").set(event.exhaustSpeed);
    add(GetValuesFromFirebase());
  }

  FutureOr<void> _changeGasThreshold(
    ChangeGasThreshold event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref('gas/threshold').set(event.gasThreshold);
    emit(state.copyWith(gasThreshold: event.gasThreshold));
    Future.delayed(Duration(seconds: 5)).then((value) {
      add(GetValuesFromFirebase());
    });
  }

  FutureOr<void> _isThresholdEnable(
    IsThresholdEnable event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) {
    emit(state.copyWith(isThresholdEnable: event.isThresholdEnable));
  }
}
