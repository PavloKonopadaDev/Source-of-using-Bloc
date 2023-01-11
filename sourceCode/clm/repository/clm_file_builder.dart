import 'package:proximacrm/ui/page/clm/repository/model/_clm_file_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_html_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_pdf_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_undefined_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_map_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_video_model.dart';

class CLMFileBuilder {
  static const FILE_TYPE = "fileext";

  static const TYPE_ZIP = ".zip";
  static const TYPE_HTML = ".html";

  static const TYPE_MOV = ".mov";
  static const TYPE_MP4 = ".mp4";
  static const TYPE_AVI = ".avi";

  static const TYPE_PDF = ".pdf";

  ICLMFileModel build(Map<String, dynamic> item) {
    if (item[FILE_TYPE] == TYPE_ZIP) return CLMMapsModel.build(item);
    if (item[FILE_TYPE] == TYPE_HTML) return CLMHtmlModel.build(item);
    if (item[FILE_TYPE] == TYPE_PDF) return CLMPdfModel.build(item);
    if (item[FILE_TYPE] == TYPE_MOV) return CLMVideoModel.build(item);
    if (item[FILE_TYPE] == TYPE_MP4) return CLMVideoModel.build(item);
    if (item[FILE_TYPE] == TYPE_AVI) return CLMVideoModel.build(item);
    return CLMUndefinedModel.build(item);
  }
}