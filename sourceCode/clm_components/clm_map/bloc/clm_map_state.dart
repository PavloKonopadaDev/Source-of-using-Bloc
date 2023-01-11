import 'package:proximacrm/ui/_component/clm_components/clm_map/repository/model/clm_map_model.dart';

abstract class ICLMMapState {}

class LoadingCLMMapState implements ICLMMapState {}

class CLMMapState implements ICLMMapState {
  final List<CLMMapModel> items;

  CLMMapState(this.items);
}