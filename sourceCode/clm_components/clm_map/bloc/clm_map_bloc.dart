import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/bloc/clm_map_event.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/bloc/clm_map_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/repository/clm_map_repository.dart';

class CLMMapBloc extends Bloc<ICLMMapEvent, ICLMMapState> {
  final CLMMapRepository _repository;

  CLMMapBloc(this._repository) : super(LoadingCLMMapState()) {
    add(LoadItemsCLMMapEvent());
  }

  @override
  Stream<ICLMMapState> mapEventToState(ICLMMapEvent event) async* {
    if (event is LoadItemsCLMMapEvent) {
      await _repository.unpackFile();
      yield CLMMapState(await _repository.getCLMMapItems());
    }
  }
}