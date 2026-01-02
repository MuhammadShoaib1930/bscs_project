import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'door_window_exhaust_gas_event.dart';
part 'door_window_exhaust_gas_state.dart';

class DoorWindowExhaustGasBloc extends Bloc<DoorWindowExhaustGasEvent, DoorWindowExhaustGasState> {
  late final StreamSubscription<DatabaseEvent> _firebaseSubscription;

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
    // Event handlers
    on<ChangeDoorAngle>(_changeDoorAngle);
    on<ChangeWindowAngle>(_changeWindowAngle);
    on<ChangeExhaustSpeed>(_changeExhaustSpeed);
    on<ChangeGasThreshold>(_changeGasThreshold);
    on<IsThresholdEnable>(_isThresholdEnable);
    on<UpdateValuesFromFirebase>(_updateValuesFromFirebase);

    _firebaseSubscription = FirebaseDatabase.instance.ref().onValue.listen((dbEvent) {
      final snapshot = dbEvent.snapshot;
      if (!snapshot.exists || snapshot.value == null) return;

      final data = Map<String, dynamic>.from(snapshot.value as Map);

      add(
        UpdateValuesFromFirebase(
          door: data["door"] ?? 0,
          window: data["window"] ?? 0,
          exhaust: data["exhaust"] ?? 0,
          gasValue: data["gas"]?["value"] ?? 0,
          gasRisk: data["gas"]?["risk"] ?? false,
          gasThreshold: data["gas"]?["threshold"] ?? 400,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _firebaseSubscription.cancel(); 
    return super.close();
  }

  FutureOr<void> _changeDoorAngle(
    ChangeDoorAngle event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("door").set(event.doorAngle);
  }

  FutureOr<void> _changeWindowAngle(
    ChangeWindowAngle event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("window").set(event.windowAngle);
  }

  FutureOr<void> _changeExhaustSpeed(
    ChangeExhaustSpeed event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref("exhaust").set(event.exhaustSpeed);
  }

  FutureOr<void> _changeGasThreshold(
    ChangeGasThreshold event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) async {
    await FirebaseDatabase.instance.ref('gas/threshold').set(event.gasThreshold);
    emit(state.copyWith(gasThreshold: event.gasThreshold));
  }

  FutureOr<void> _isThresholdEnable(
    IsThresholdEnable event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) {
    emit(state.copyWith(isThresholdEnable: event.isThresholdEnable));
  }

  FutureOr<void> _updateValuesFromFirebase(
    UpdateValuesFromFirebase event,
    Emitter<DoorWindowExhaustGasState> emit,
  ) {
    emit(
      state.copyWith(
        door: event.door,
        window: event.window,
        exhaust: event.exhaust,
        gasValue: event.gasValue,
        isRisk: event.gasRisk,
        gasThreshold: event.gasThreshold,
      ),
    );
  }
}
