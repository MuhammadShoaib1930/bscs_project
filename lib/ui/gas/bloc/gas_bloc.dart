import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gas_event.dart';
part 'gas_state.dart';

class GasBloc extends Bloc<GasEvent, GasState> {
  final DatabaseReference gasRef = FirebaseDatabase.instance.ref('sensor/gas');
  late final StreamSubscription<DatabaseEvent> _gasSub;

  GasBloc() : super(GasInitial()) {
    _gasSub = gasRef.onValue.listen((DatabaseEvent event) {
      final value = event.snapshot.value;
      if (value != null) {
        final gasValue = value as int;
        add(GasValueChangedEvent(gasValue: gasValue));
      }
    });

    on<GasValueChangedEvent>((event, emit) {
      emit(GasLoadedState(gasValue: event.gasValue));
    });

    on<GetGasValueFromFirebase>((event, emit) async {
      final snapshot = await gasRef.get();
      if (snapshot.exists) {
        final gasValue = snapshot.value as int;
        emit(GasLoadedState(gasValue: gasValue));
      }
    });
  }

  @override
  Future<void> close() {
    _gasSub.cancel();
    return super.close();
  }
}
