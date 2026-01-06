// ignore_for_file: empty_catches

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'servo_event.dart';
part 'servo_state.dart';

class ServoBloc extends Bloc<ServoEvent, ServoState> {
  ServoBloc() : super(ServoInitialState()) {
    on<GetFromFirebaseEvent>(_getFromFirebase);
    on<DoorAngleChangeEvent>(_doorAngleChange);
    on<WindowAngleChangeEvent>(_windowAngleChange);
  }

  FutureOr<void> _getFromFirebase(GetFromFirebaseEvent event, Emitter<ServoState> emit) async {
    final doorAngle = await FirebaseDatabase.instance.ref('servo/door').get();
    final doorAngleGet = doorAngle.exists ? doorAngle.value as int : 0;
    final windowAngle = await FirebaseDatabase.instance.ref('servo/window').get();
    final windowAngleGet = windowAngle.exists ? windowAngle.value as int : 0;
    emit(ServoLoadedState(doorAngle: doorAngleGet, windowAngle: windowAngleGet));
  }

  FutureOr<void> _doorAngleChange(DoorAngleChangeEvent event, Emitter<ServoState> emit) async {
    try {
      await FirebaseDatabase.instance.ref('servo/door').set(event.doorAngle);
      add(GetFromFirebaseEvent());
    } catch (e) {}
  }

  FutureOr<void> _windowAngleChange(WindowAngleChangeEvent event, Emitter<ServoState> emit) async {
    try {
      await FirebaseDatabase.instance.ref('servo/window').set(event.windowAngle);
      add(GetFromFirebaseEvent());
    } catch (e) {}
  }
}
