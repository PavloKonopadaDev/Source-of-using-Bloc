
import 'dart:io';
import 'package:injector/injector.dart';
import 'package:proximacrm/extensions/ext_datetime.dart';
import 'package:proximacrm/logger/logger.dart';
import 'package:proximacrm/providers/database/main_db_provider.dart';
import 'package:proximacrm/providers/path/_file_path_provider.dart';
import 'model/clm_map_slider_model.dart';

class CLMMapSliderRepository {
  late final Logger _logger;
  late final IFilePathProvider _filePathProvider;
  late final MainDBProvider _mainDBProvider;

  final int clmId;
  final int clmMapId;
  final String guid;

  List<CLMMapSlideModel> _slides = [];
  DateTime? _startTime;
  int? _currentSlideIndex;

  CLMMapSliderRepository(this.clmId, this.clmMapId, this.guid) {
    final injector = Injector.appInstance;
    _logger = injector.get<Logger>();
    _filePathProvider = injector.get<IFilePathProvider>();
    _mainDBProvider = injector.get<MainDBProvider>();
  }

  Future<List<CLMMapSlideModel>> getCLMMapSlides() async {
    String query = """
      SELECT
      _id AS ${CLMMapSlideModel.FIELD_ID}
      ,name AS ${CLMMapSlideModel.FIELD_NAME}
      ,preview AS ${CLMMapSlideModel.FIELD_PREVIEW}
      ,filename AS ${CLMMapSlideModel.FIELD_FILE_NAME}
      FROM info_clmslide
      WHERE clm_id = $clmId 
  """;
    _logger.info(this, "getCLMMapSlides($query)");
    _slides = await _mainDBProvider.queryToModelList<CLMMapSlideModel>(query,
      converter: (_, values) async => CLMMapSlideModel.build(values, (fileName) => _filePathProvider.buildCLMFile("$guid${Platform.pathSeparator}$fileName")));
    return _slides;
  }

  Future<void> startSlideShow(int slideId) async {
    _startTime = DateTime.now();
    _currentSlideIndex = slideId;
    _logger.info(this, "startSlideShow(id: $_currentSlideIndex, startTime: $_startTime)");
  }

  Future<void> finishLastSlideShow() async {
    _logger.info(this, "finishLastSlideShow(id: $_currentSlideIndex, startTime: $_startTime)");
    if(null != _currentSlideIndex && null != _startTime) {
      await _saveStatistic(_slides[_currentSlideIndex!], _currentSlideIndex!, DateTime.now().secondsSinceEpoch - _startTime!.secondsSinceEpoch);
    }
    _startTime = null;
    _currentSlideIndex = null;
  }

  Future<void> _saveStatistic(CLMMapSlideModel slide, int index, int durationInSec) async => await _mainDBProvider.create("info_taskpresentationslide", {
      "viewingdate":  DateTime.now().secondsSinceEpoch,
      "presentation_id": clmId,
      "clmmap_id": clmMapId,
      "slide_id": slide.id,
      "slidenum": index,
      "numofsec": durationInSec,
      "slidename": slide.name,
    }
  );
}