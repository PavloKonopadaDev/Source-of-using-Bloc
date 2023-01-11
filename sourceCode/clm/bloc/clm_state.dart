import 'dart:io';

import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_folder_model.dart';

abstract class ICLMState {}

abstract class IClMOpenCLMState implements ICLMState {
  final int clmId;
  final String title;

  IClMOpenCLMState(this.clmId, this.title);
}

abstract class IClMOpenFileState extends IClMOpenCLMState {
  final File file;

  IClMOpenFileState(int clmId, String title, this.file): super(clmId, title);
}

class CLMLoadingState implements ICLMState {}

abstract class DisplayCLMState implements ICLMState {
  final List<ICLMItemModel> items;

  DisplayCLMState(this.items);
}

class CLMState extends DisplayCLMState {
  final List<CLMFolderModel?> breadCrumbs;
  final CLMFolderModel? parent;

  CLMState(
    List<ICLMItemModel> items, {
    required this.breadCrumbs,
    required this.parent,
  }) : super(items);
}

class CLMSearchState extends DisplayCLMState {
  final String search;

  CLMSearchState(List<ICLMItemModel> item, this.search) : super(item);
}

class CLMOpenPdfFileState extends IClMOpenFileState {
  CLMOpenPdfFileState({
    required int clmId,
    required String title,
    required File file,
  }) : super(clmId, title, file);
}

class CLMOpenUndefinedFileState extends IClMOpenFileState {
  CLMOpenUndefinedFileState({
    required int clmId,
    required String title,
    required File file,
  }) : super(clmId, title, file);
}

class CLMOpenMapState extends IClMOpenCLMState {
  final String guid;

  CLMOpenMapState({
    required int clmId,
    required String title,
    required this.guid,
  }) : super(clmId, title);
}

class CLMOpenHtmlFileState extends IClMOpenFileState {
  CLMOpenHtmlFileState({
    required int clmId,
    required String title,
    required File file,
  }) : super(clmId, title, file);
}

class CLMOpenVideoFileState extends IClMOpenFileState {
  CLMOpenVideoFileState({
    required int clmId,
    required String title,
    required File file,
  }) : super(clmId, title, file);
}
