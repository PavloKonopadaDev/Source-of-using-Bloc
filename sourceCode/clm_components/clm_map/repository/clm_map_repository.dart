import 'dart:io';
import 'package:injector/injector.dart';
import 'package:proximacrm/logger/logger.dart';
import 'package:proximacrm/providers/database/main_db_provider.dart';
import 'package:proximacrm/providers/path/_file_path_provider.dart';
import 'package:proximacrm/services/archive/archive_service.dart';

import 'model/clm_map_model.dart';

class CLMMapRepository {
    static const _PACKAGE_EXTENSION = 'zip';

  late final Logger _logger;
  late final IFilePathProvider _filePathProvider;
  late final MainDBProvider _mainDBProvider;
  late final ArchiveService _archiveService;

  final int clmId;
  final String guid;

  CLMMapRepository(this.clmId, this.guid) {
    final injector = Injector.appInstance;
    _logger = injector.get<Logger>();
    _filePathProvider = injector.get<IFilePathProvider>();
    _mainDBProvider = injector.get<MainDBProvider>();
    _archiveService = injector.get<ArchiveService>();
  }

  Future<void> unpackFile() async {
    File zipFile = _filePathProvider.buildCLMFile("$guid.$_PACKAGE_EXTENSION");
    if (await zipFile.exists()) {
      bool isUnpackSuccessful = await _archiveService.unzip(zipFile, withDelete: true, isCreateDirectory: true);
      _logger.info(this, "Unpacking file is: ${isUnpackSuccessful ? "successful" : "not successful"} $zipFile");
    }
  }

  Future<List<CLMMapModel>> getCLMMapItems() async {
    String query = """
      SELECT 
       MAP._id AS ${CLMMapModel.FIELD_ID}
      ,MAP.name AS ${CLMMapModel.FIELD_NAME}
      ,SLIDE.preview AS ${CLMMapModel.FIELD_PREVIEW}
      FROM info_clmmap MAP
      LEFT JOIN (
        SELECT MAP_SLIDE.clmmap_id AS clmmap_id, SLIDE.preview
        FROM info_clmmapslide MAP_SLIDE
        INNER JOIN info_clmslide SLIDE ON SLIDE._id = MAP_SLIDE.clmslide_id
        GROUP BY MAP_SLIDE.clmmap_id
        ORDER BY MAP_SLIDE.position ASC
      ) SLIDE ON SLIDE.clmmap_id = MAP._id
      WHERE ifnull(MAP.ishidden, 0) = 0 AND clm_id = $clmId
      ORDER BY MAP.name ASC
    """;
    _logger.info(this, "getCLMMapItems($query)");
    return _mainDBProvider.queryToModelList<CLMMapModel>(query,
        converter: (_, values) async => CLMMapModel.build(values,
                (fileName) => _filePathProvider.buildCLMFile("$guid${Platform.pathSeparator}$fileName")));
  }
}