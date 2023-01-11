import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';

abstract class ICLMFileModel extends ICLMItemModel {
  static const String FIELD_ID = "id";
  static const String FIELD_NAME = "name";
  static const String FIELD_FILE_EXTENSION = "fileext";
  static const String FIELD_FILE_NAME = "filename";
  static const String FIELD_GUID = "guid";

  final int id;
  final String name;
  final String fileExt;
  final String fileName;
  final String guid;

  ICLMFileModel(this.id, this.name, this.fileExt, this.fileName, this.guid, Map<String, dynamic> item);

  ICLMFileModel.build(Map<String, dynamic> item): this(
      item[FIELD_ID] ?? 0,
      item[FIELD_NAME],
      item[FIELD_FILE_EXTENSION],
      item[FIELD_FILE_NAME],
      item[FIELD_GUID],
      item);
}