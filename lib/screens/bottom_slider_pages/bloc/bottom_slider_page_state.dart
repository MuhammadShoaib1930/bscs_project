part of 'bottom_slider_page_bloc.dart';

class BottomSliderPageState extends Equatable {
  final int pageIndex;
  const BottomSliderPageState({this.pageIndex = 0});

  @override
  List<Object> get props => [pageIndex];
}
