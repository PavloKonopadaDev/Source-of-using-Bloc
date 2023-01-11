import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_web_view/bloc/clm_web_view_event.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_web_view/bloc/clm_web_view_state.dart';

class CLMWebViewBloc extends Bloc<ICLMWebViewEvent, ICLMWebViewState> {
  CLMWebViewBloc() : super(CLMWebViewLoadingState()) {
    add(CLMWebViewLoadEvent());
  }

  @override
  Stream<ICLMWebViewState> mapEventToState(ICLMWebViewEvent event) async* {
    if (event is CLMWebViewLoadEvent) {
      yield CLMWebViewState();
    }
  }
}