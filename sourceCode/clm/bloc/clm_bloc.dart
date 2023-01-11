import 'package:proximacrm/ui/page/clm/bloc/clm_event.dart';
import 'package:proximacrm/ui/page/clm/bloc/clm_state.dart';
import 'package:proximacrm/ui/page/clm/repository/clm_repository.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_file_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_folder_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_html_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_pdf_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_undefined_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_video_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_map_model.dart';

class CLMBloc extends Bloc<ICLMEvent, ICLMState> {
  final CLMRepository _repository;

  CLMBloc(this._repository) : super(CLMLoadingState()) {
    add(OpenFolderCLMEvent());
  }

  @override
  Stream<ICLMState> mapEventToState(ICLMEvent event) async* {
    if (event is OpenFolderCLMEvent) {
      yield await _getCLMState(event.folderModel);
    }

    if (event is SearchItemCLMEvent) {
      if (event.search.isNotEmpty) {
        List<ICLMItemModel> items = await _repository.search(event.search);
        yield CLMSearchState(items, event.search);
      } else {
        await _repository.clearBreadCrumbs();
        yield await _getCLMState();
      }
    }

    if (event is OpenFileCLMEvent) {
      ICLMFileModel clmFile = event.fileModel;
      switch (clmFile.runtimeType) {
        case CLMPdfModel:
          yield CLMOpenPdfFileState(
              clmId: clmFile.id, title: clmFile.name, file: await _repository.getPathToFile(clmFile));
          break;

        case CLMMapsModel:
          yield CLMOpenMapState(
            clmId: clmFile.id,
            title: clmFile.name,
            guid: clmFile.guid,
          );
          break;

        case CLMHtmlModel:
          yield CLMOpenHtmlFileState(
              clmId: clmFile.id,
              title: clmFile.name,
              file: await _repository.getPathToFile(event.fileModel));
          break;

        case CLMVideoModel:
          yield CLMOpenVideoFileState(
              clmId: clmFile.id,
              title: clmFile.name,
              file: await _repository.getPathToFile(event.fileModel));
          break;

        case CLMUndefinedModel:
          yield CLMOpenUndefinedFileState(
              clmId: clmFile.id,
              title: clmFile.name,
              file: await _repository.getPathToFile(event.fileModel));
          break;
      }
    }
  }

  Future<CLMState> _getCLMState([CLMFolderModel? folderModel]) async {
    List<ICLMItemModel> items =
        await _repository.getItems(folderModel ?? _repository.rootFolder);
    return CLMState(
      items,
      breadCrumbs: _repository.breadCrumbs,
      parent: _repository.parent,
    );
  }
}