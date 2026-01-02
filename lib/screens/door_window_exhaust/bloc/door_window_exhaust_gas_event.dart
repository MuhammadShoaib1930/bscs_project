part of 'door_window_exhaust_gas_bloc.dart';

sealed class DoorWindowExhaustGasEvent extends Equatable {
  const DoorWindowExhaustGasEvent();

  @override
  List<Object> get props => [];
}

class GetValuesFromFirebase extends DoorWindowExhaustGasEvent {}

class ChangeDoorAngle extends DoorWindowExhaustGasEvent {
  final int doorAngle;
  const ChangeDoorAngle({required this.doorAngle});
  @override
  List<Object> get props => [doorAngle];
}

class ChangeWindowAngle extends DoorWindowExhaustGasEvent {
  final int windowAngle;
  const ChangeWindowAngle({required this.windowAngle});
  @override
  List<Object> get props => [windowAngle];
}

class ChangeExhaustSpeed extends DoorWindowExhaustGasEvent {
  final int exhaustSpeed;
  const ChangeExhaustSpeed({required this.exhaustSpeed});
  @override
  List<Object> get props => [exhaustSpeed];
}

class ChangeGasThreshold extends DoorWindowExhaustGasEvent {
  final int gasThreshold;
  const ChangeGasThreshold({required this.gasThreshold});
  @override
  List<Object> get props => [gasThreshold];
}

class IsThresholdEnable extends DoorWindowExhaustGasEvent {
  final bool isThresholdEnable;
  const IsThresholdEnable({required this.isThresholdEnable});
   @override
  List<Object> get props => [isThresholdEnable];
}
class UpdateValuesFromFirebase extends DoorWindowExhaustGasEvent {
  final int door;
  final int window;
  final int exhaust;
  final int gasValue;
  final bool gasRisk;
  final int gasThreshold;

  const UpdateValuesFromFirebase({
    required this.door,
    required this.window,
    required this.exhaust,
    required this.gasValue,
    required this.gasRisk,
    required this.gasThreshold,
  });
}
