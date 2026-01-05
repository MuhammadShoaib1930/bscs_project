part of 'gas_bloc.dart';

sealed class GasState extends Equatable {
  const GasState();

  @override
  List<Object> get props => [];
}

final class GasInitial extends GasState {}

final class GasLoadedState extends GasState {
  final int gasValue;
  const GasLoadedState({required this.gasValue});
    @override
  List<Object> get props => [gasValue];
}
