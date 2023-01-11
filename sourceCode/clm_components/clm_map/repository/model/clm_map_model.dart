import 'dart:io';

class CLMMapModel {
  static const FIELD_ID = "_id";
  static const FIELD_NAME = "name";
  static const FIELD_PREVIEW = "preview";

  final int id;
  final String name;
  final File slide;

  CLMMapModel(this.id, this.name, this.slide);

  CLMMapModel.build(Map<String, dynamic> item, Function(String filerName) previewFileBuilder): this(
    item[FIELD_ID],
    item[FIELD_NAME],
    previewFileBuilder(item[FIELD_PREVIEW]));
}