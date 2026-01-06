// ignore_for_file: empty_catches

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'relays_event.dart';
part 'relays_state.dart';

class RelaysBloc extends Bloc<RelaysEvent, RelaysState> {
  RelaysBloc() : super(RelaysInitial()) {
    on<RelayGetStateEvent>(_getStates);
    on<RelayToggleEvent>(_setRelayState);
  }

  Future<void> _getStates(RelayGetStateEvent event, Emitter<RelaysState> emit) async {
    final r1Snap = await FirebaseDatabase.instance.ref('relay/r1').get();
    final r2Snap = await FirebaseDatabase.instance.ref('relay/r2').get();
    final r3Snap = await FirebaseDatabase.instance.ref('relay/r3').get();
    final r4Snap = await FirebaseDatabase.instance.ref('relay/r4').get();
    final r5Snap = await FirebaseDatabase.instance.ref('relay/r5').get();
    final r6Snap = await FirebaseDatabase.instance.ref('relay/r6').get();
    final r7Snap = await FirebaseDatabase.instance.ref('relay/r7').get();

    final r1 = r1Snap.exists ? r1Snap.value as bool : false;
    final r2 = r2Snap.exists ? r2Snap.value as bool : false;
    final r3 = r3Snap.exists ? r3Snap.value as bool : false;
    final r4 = r4Snap.exists ? r4Snap.value as bool : false;
    final r5 = r5Snap.exists ? r5Snap.value as bool : false;
    final r6 = r6Snap.exists ? r6Snap.value as bool : false;
    final r7 = r7Snap.exists ? r7Snap.value as bool : false;

    emit(
      RelaysLoaded(
        relay1: r1,
        relay2: r2,
        relay3: r3,
        relay4: r4,
        relay5: r5,
        relay6: r6,
        relay7: r7,
      ),
    );
  }

  FutureOr<void> _setRelayState(RelayToggleEvent event, Emitter<RelaysState> emit) async {
    try {
        await FirebaseDatabase.instance.ref('relay/r${event.relayIndex}').set(event.relayState);
        add(RelayGetStateEvent());
    } catch (e) {
    }
  }
}
