import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';

class CLMFolderModel extends ICLMItemModel {
  static const String FIELD_ID = "id";
  static const String FIELD_NAME = "name";

  final int id;
  final String? name;

  CLMFolderModel(this.id, this.name);

  CLMFolderModel.build(Map<String, dynamic> item): this(
      item[FIELD_ID] ?? 0,
      item[FIELD_NAME]);
}