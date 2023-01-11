
abstract class ICLMMapSliderEvent {}

class CLMMapSliderLoadItemsEvent implements ICLMMapSliderEvent {}

class CLMMapShowSlideEvent implements ICLMMapSliderEvent {
  int slideId;

  CLMMapShowSlideEvent(this.slideId);
}

class CLMMapHideSlideEvent implements ICLMMapSliderEvent {
  int slideId;

  CLMMapHideSlideEvent(this.slideId);
}
