// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'door_window_exhaust_gas_bloc.dart';

class DoorWindowExhaustGasState extends Equatable {
  final int door;
  final int window;
  final int exhaust;
  final int gasValue;
  final bool isRisk;
  final int gasThreshold;
  final bool isThresholdEnable;
  const DoorWindowExhaustGasState({
    required this.door,
    required this.exhaust,
    required this.gasValue,
    required this.isRisk,
    required this.window,
    required this.gasThreshold,
    required this.isThresholdEnable
  });

  @override
  List<Object> get props => [door, window, exhaust, gasValue, isRisk, gasThreshold,isThresholdEnable];

  DoorWindowExhaustGasState copyWith({
    int? door,
    int? window,
    int? exhaust,
    int? gasValue,
    bool? isRisk,
    int? gasThreshold,
    bool? isThresholdEnable,
  }) {
    return DoorWindowExhaustGasState(
      door: door ?? this.door,
      window: window ?? this.window,
      exhaust: exhaust ?? this.exhaust,
      gasValue: gasValue ?? this.gasValue,
      isRisk: isRisk ?? this.isRisk,
      gasThreshold: gasThreshold ?? this.gasThreshold,
      isThresholdEnable: isThresholdEnable ?? this.isThresholdEnable,
    );
  }
}
