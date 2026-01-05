part of 'relays_bloc.dart';

sealed class RelaysState extends Equatable {
  const RelaysState();

  @override
  List<Object> get props => [];
}

final class RelaysInitial extends RelaysState {}

final class RelaysLoaded extends RelaysState {
  final bool relay1;
  final bool relay2;
  final bool relay3;
  final bool relay4;
  final bool relay5;
  final bool relay6;
  final bool relay7;
  const RelaysLoaded({
    required this.relay1,
    required this.relay2,
    required this.relay3,
    required this.relay4,
    required this.relay5,
    required this.relay6,
    required this.relay7,
  });
  RelaysLoaded copyWith({
    bool? relay1,
    bool? relay2,
    bool? relay3,
    bool? relay4,
    bool? relay5,
    bool? relay6,
    bool? relay7,
  }) {
    return RelaysLoaded(
      relay1: relay1 ?? this.relay1,
      relay2: relay2 ?? this.relay2,
      relay3: relay3 ?? this.relay3,
      relay4: relay4 ?? this.relay4,
      relay5: relay5 ?? this.relay5,
      relay6: relay6 ?? this.relay6,
      relay7: relay7 ?? this.relay7,
    );
  }

  @override
  List<Object> get props => [relay1, relay2, relay3, relay4, relay5, relay6, relay7];
}
