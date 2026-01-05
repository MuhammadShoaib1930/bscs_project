part of 'relays_bloc.dart';

sealed class RelaysEvent extends Equatable {
  const RelaysEvent();

  @override
  List<Object> get props => [];
}

final class RelayToggleEvent extends RelaysEvent {
  final int relayIndex;
  final bool relayState;
  const RelayToggleEvent({required this.relayIndex, required this.relayState});
  @override
  List<Object> get props => [relayIndex, relayState];
}

final class RelayGetStateEvent extends RelaysEvent {
  @override
  List<Object> get props => [];
}
