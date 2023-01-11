
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/repository/model/clm_map_slider_model.dart';

abstract class ICLMMapSliderState {}

class CLMMapSliderLoadingState implements ICLMMapSliderState {}

class CLMMapSliderState implements ICLMMapSliderState {
  final List<CLMMapSlideModel> items;

  CLMMapSliderState(this.items);
}