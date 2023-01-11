import 'package:proximacrm/ui/page/clm/repository/model/_clm_file_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_folder_model.dart';

abstract class ICLMEvent {}

class OpenFolderCLMEvent implements ICLMEvent {
  final CLMFolderModel? folderModel;

  OpenFolderCLMEvent([this.folderModel]);
}

class OpenFileCLMEvent implements ICLMEvent {
  final ICLMFileModel fileModel;

  OpenFileCLMEvent(this.fileModel);
}

class SearchItemCLMEvent implements ICLMEvent {
  final String search;

  SearchItemCLMEvent(this.search);
}