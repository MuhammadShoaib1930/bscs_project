part of 'relays_bloc.dart';

sealed class RelaysEvent extends Equatable {
  const RelaysEvent();

  @override
  List<Object?> get props => [];
}

class OnChangeRelayStatus extends RelaysEvent {
  final bool isTrue;
  final int index;
  const OnChangeRelayStatus({required this.isTrue, required this.index});
  @override
  List<Object?> get props => [isTrue, index];
}

class ChangeSettingRelays extends RelaysEvent {
  final int index;
  final int initialPower;
  final double initialTarget;
  final double currentKwh;
  const ChangeSettingRelays({
    required this.initialPower,
    required this.initialTarget,
    required this.currentKwh,
    required this.index,
  });
  @override
  List<Object?> get props => [initialPower, initialTarget, currentKwh, index];
}

class GetDataFromFirebase extends RelaysEvent {}
