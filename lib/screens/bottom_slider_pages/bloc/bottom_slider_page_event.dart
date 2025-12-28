part of 'bottom_slider_page_bloc.dart';

sealed class BottomSliderPageEvent extends Equatable {
  const BottomSliderPageEvent();
}

class ChangePage extends BottomSliderPageEvent {
  final int pageIndex;
  const ChangePage({this.pageIndex = 0});
  @override
  List<Object> get props => [pageIndex];
}
