import 'dart:io';

class CLMMapSlideModel {
  static const FIELD_ID = "_id";
  static const FIELD_NAME = "name";
  static const FIELD_PREVIEW = "preview";
  static const FIELD_FILE_NAME = "filename";

  final int id;
  final String name;
  final File slide;
  final File file;

  CLMMapSlideModel(
    this.id,
    this.name,
    this.slide,
    this.file,
  );

  CLMMapSlideModel.build(Map<String, dynamic> item, Function(String filerName) previewFileBuilder): this(
    item[FIELD_ID],
    item[FIELD_NAME],
    previewFileBuilder(item[FIELD_PREVIEW]),
    previewFileBuilder(item[FIELD_FILE_NAME]),
  );
}