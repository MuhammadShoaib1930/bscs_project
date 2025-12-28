part of 'relays_bloc.dart';

class RelaysState extends Equatable {
  final bool isOn1;
  final int power1;
  final double currentKwh1;
  final double target1;
  final String startTime1;
  final String endTime1;

  final bool isOn2;
  final int power2;
  final double target2;
  final double currentKwh2;
  final String startTime2;
  final String endTime2;

  final bool isOn3;
  final int power3;
  final double target3;
  final double currentKwh3;
  final String startTime3;
  final String endTime3;

  final bool isOn4;
  final int power4;
  final double target4;
  final double currentKwh4;
  final String startTime4;
  final String endTime4;

  const RelaysState({
    required this.isOn1,
    required this.power1,
    required this.target1,
    required this.startTime1,
    required this.currentKwh1,
    required this.endTime1,
    required this.isOn2,
    required this.power2,
    required this.target2,
    required this.startTime2,
    required this.currentKwh2,
    required this.endTime2,
    required this.isOn3,
    required this.power3,
    required this.target3,
    required this.startTime3,
    required this.currentKwh3,
    required this.endTime3,
    required this.isOn4,
    required this.power4,
    required this.target4,
    required this.startTime4,
    required this.endTime4,
    required this.currentKwh4,
  });

  factory RelaysState.initial() {
    return const RelaysState(
      isOn1: false,
      power1: 0,
      target1: 0,
      currentKwh1: 0.0,
      startTime1: "00:00",
      endTime1: "23:59",
      isOn2: false,
      power2: 0,
      target2: 0,
      currentKwh2: 0.0,
      startTime2: "00:00",
      endTime2: "23:59",
      isOn3: false,
      power3: 0,
      target3: 0,
      currentKwh3: 0.0,
      startTime3: "00:00",
      endTime3: "23:59",
      isOn4: false,
      power4: 0,
      target4: 0,
      currentKwh4: 0.0,
      startTime4: "00:00",
      endTime4: "23:59",
    );
  }

  RelaysState copyWith({
    bool? isOn1,
    int? power1,
    double? target1,
    double? currentKwh1,
    String? startTime1,
    String? endTime1,
    bool? isOn2,
    int? power2,
    double? target2,
    double? currentKwh2,
    String? startTime2,
    String? endTime2,
    bool? isOn3,
    int? power3,
    double? target3,
    double? currentKwh3,
    String? startTime3,
    String? endTime3,
    bool? isOn4,
    int? power4,
    double? target4,
    String? startTime4,
    double? currentKwh4,
    String? endTime4,
  }) {
    return RelaysState(
      isOn1: isOn1 ?? this.isOn1,
      power1: power1 ?? this.power1,
      target1: target1 ?? this.target1,
      startTime1: startTime1 ?? this.startTime1,
      endTime1: endTime1 ?? this.endTime1,
      isOn2: isOn2 ?? this.isOn2,
      power2: power2 ?? this.power2,
      target2: target2 ?? this.target2,
      startTime2: startTime2 ?? this.startTime2,
      endTime2: endTime2 ?? this.endTime2,
      isOn3: isOn3 ?? this.isOn3,
      power3: power3 ?? this.power3,
      target3: target3 ?? this.target3,
      startTime3: startTime3 ?? this.startTime3,
      endTime3: endTime3 ?? this.endTime3,
      isOn4: isOn4 ?? this.isOn4,
      power4: power4 ?? this.power4,
      target4: target4 ?? this.target4,
      startTime4: startTime4 ?? this.startTime4,
      endTime4: endTime4 ?? this.endTime4,
      currentKwh1: currentKwh1 ?? this.currentKwh1,
      currentKwh2: currentKwh2 ?? this.currentKwh2,
      currentKwh3: currentKwh3 ?? this.currentKwh3,
      currentKwh4: currentKwh4 ?? this.currentKwh4,
    );
  }

  @override
  List<Object?> get props => [
    isOn1,
    power1,
    target1,
    startTime1,
    endTime1,
    isOn2,
    power2,
    target2,
    startTime2,
    endTime2,
    isOn3,
    power3,
    target3,
    startTime3,
    endTime3,
    isOn4,
    power4,
    target4,
    startTime4,
    endTime4,
    currentKwh1,
    currentKwh2,
    currentKwh3,
    currentKwh4,
  ];
}
