part of 'servo_bloc.dart';

sealed class ServoState extends Equatable {
  const ServoState();

  @override
  List<Object> get props => [];
}

final class ServoInitialState extends ServoState {}

final class ServoLoadedState extends ServoState {
  final int doorAngle;
  final int windowAngle;
  const ServoLoadedState({required this.doorAngle, required this.windowAngle});
  @override
  List<Object> get props => [doorAngle, windowAngle];
}
