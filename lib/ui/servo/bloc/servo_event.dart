part of 'servo_bloc.dart';

sealed class ServoEvent extends Equatable {
  const ServoEvent();

  @override
  List<Object> get props => [];
}

final class GetFromFirebaseEvent extends ServoEvent {}

final class DoorAngleChangeEvent extends ServoEvent {
  final int doorAngle;
  const DoorAngleChangeEvent({required this.doorAngle});
  @override
  List<Object> get props => [doorAngle];
}

final class WindowAngleChangeEvent extends ServoEvent {
  final int windowAngle;
  const WindowAngleChangeEvent({required this.windowAngle});
  @override
  List<Object> get props => [windowAngle];
}
