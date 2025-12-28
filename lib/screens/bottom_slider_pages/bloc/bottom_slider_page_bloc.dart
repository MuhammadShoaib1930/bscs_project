import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_slider_page_event.dart';
part 'bottom_slider_page_state.dart';

class BottomSliderPageBloc extends Bloc<BottomSliderPageEvent, BottomSliderPageState> {
  BottomSliderPageBloc() : super(BottomSliderPageState(pageIndex: 0)) {
    on<ChangePage>(_changePage);
  }

  FutureOr<void> _changePage(ChangePage event, Emitter<BottomSliderPageState> emit) {
    emit(BottomSliderPageState(pageIndex: event.pageIndex));
  }
}
