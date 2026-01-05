part of 'gas_bloc.dart';

sealed class GasEvent extends Equatable {
  const GasEvent();

  @override
  List<Object> get props => [];
}

class GetGasValueFromFirebase extends GasEvent {}

class GasValueChangedEvent extends GasEvent {
  final int gasValue;
  const GasValueChangedEvent({required this.gasValue});
    @override
  List<Object> get props => [gasValue];
}
