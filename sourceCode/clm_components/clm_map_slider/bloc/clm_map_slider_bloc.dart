import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/bloc/clm_map_slider_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/repository/clm_map_slider_repository.dart';

import 'clm_map_slider_event.dart';

class CLMMapSliderBloc extends Bloc<ICLMMapSliderEvent, ICLMMapSliderState> {
  final CLMMapSliderRepository _repository;

  CLMMapSliderBloc(this._repository) : super(CLMMapSliderLoadingState());

  @override
  Stream<ICLMMapSliderState> mapEventToState(ICLMMapSliderEvent event) async* {

    if (event is CLMMapSliderLoadItemsEvent) {
      yield CLMMapSliderState(await _repository.getCLMMapSlides());
    }

    if(event is CLMMapShowSlideEvent) {
      await _repository.startSlideShow(event.slideId);
    }

    if (event is CLMMapHideSlideEvent) {
      await _repository.finishLastSlideShow();
    }
  }

  @override
  Future<void> close() async {
    await _repository.finishLastSlideShow();
    return super.close();
  }

}