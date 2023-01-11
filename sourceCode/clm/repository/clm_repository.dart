import 'dart:io';
import 'package:injector/injector.dart';
import 'package:proximacrm/logger/logger.dart';
import 'package:proximacrm/providers/database/main_db_provider.dart';
import 'package:proximacrm/providers/options/options_provider.dart';
import 'package:proximacrm/providers/path/_file_path_provider.dart';
import 'package:proximacrm/ui/page/clm/repository/clm_file_builder.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_file_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_folder_model.dart';

class CLMRepository {
  late final Logger _logger;
  late final OptionsProvider _optionsProvider;
  late final MainDBProvider _mainDBProvider;
  late final IFilePathProvider _filePathProvider;

  final CLMFileBuilder builder;
  final List<CLMFolderModel?> _breadCrumbs = [];

  List<CLMFolderModel?> get breadCrumbs => _breadCrumbs;

  CLMFolderModel get rootFolder => CLMFolderModel(0, null);
  CLMFolderModel? get parent => _breadCrumbs.length > 1 ? _breadCrumbs[_breadCrumbs.length - 2] : null;

  CLMRepository(this.builder) {
    final injector = Injector.appInstance;
    _logger = injector.get<Logger>();
    _optionsProvider = injector.get<OptionsProvider>();
    _mainDBProvider = injector.get<MainDBProvider>();
    _filePathProvider = injector.get<IFilePathProvider>();
  }

  Future<File> getPathToFile(ICLMFileModel itemModel) async => _filePathProvider.buildCLMFile("${itemModel.guid}${itemModel.fileExt}");

  Future<List<ICLMItemModel>> getItems(CLMFolderModel folder) async => _sortItems([
    ...await _getFoldersFor(folder),
    ...await _getFilesInGroup(folder.id),
  ]);

  Future<List<ICLMItemModel>> search(String search) async {
    return _sortItems([
      ...await _getFolders(search: search),
      ...await _getFilesFor(search),
    ]);
  }

  Future<void> clearBreadCrumbs() async => _breadCrumbs.clear();

  Future<List<CLMFolderModel>> _getFoldersFor(CLMFolderModel folder) async {
    _buildPath(folder);
    return await _getFolders(parentId: folder.id);
  }

  Future<List<CLMFolderModel>> _getFolders({
    int? parentId,
    String? search,
  }) async {
    String condition = "";
    if(null != parentId) {
      condition = "ifnull(CLM_GROUP.parent_id, 0) = $parentId ";
    }
    if(null != search) {
      condition = "${condition.isNotEmpty ? "$condition AND " : ""}CLM_GROUP.name LIKE '$search%'";
    }
    String query = """
      SELECT 
        CLM_GROUP._id AS ${CLMFolderModel.FIELD_ID}
       ,CLM_GROUP.name AS ${CLMFolderModel.FIELD_NAME}
       FROM info_clmgroup CLM_GROUP
       INNER JOIN info_clmgroupdirection GROUP_DIRECTION ON GROUP_DIRECTION.direction_id IN (
            SELECT direction_id FROM info_userdirection WHERE user_id = ${_optionsProvider.userId}
          )
          AND GROUP_DIRECTION.clmgroup_id = CLM_GROUP._id
       WHERE $condition AND ifnull(CLM_GROUP.isarchive, 0) = 0 
    """;
    _logger.info(this, "_getFolders($query)");
    return await _mainDBProvider.queryToModelList<CLMFolderModel>(query,
        converter: (_, item) async => CLMFolderModel.build(item));
  }

  _buildPath(CLMFolderModel? folder) {
    if (_breadCrumbs.contains(folder)) {
      _breadCrumbs.removeRange(_breadCrumbs.indexOf(folder) + 1, _breadCrumbs.length);
    } else {
      _breadCrumbs.add(folder);
    }
  }

  Future<List<ICLMFileModel>> _getFilesInGroup(int groupId) async {
    String query = """
        SELECT
         CLM._id AS ${ICLMFileModel.FIELD_ID}
        ,CLM.name AS ${ICLMFileModel.FIELD_NAME}
        ,CLM.filename AS ${ICLMFileModel.FIELD_FILE_NAME}
        ,CLM.fileext AS ${ICLMFileModel.FIELD_FILE_EXTENSION}
        ,CLM.guid AS ${ICLMFileModel.FIELD_GUID}
        FROM info_clm CLM
        INNER JOIN info_clmingroup CLM_IN_GROUP ON CLM._id = CLM_IN_GROUP.clm_id
        WHERE CLM_IN_GROUP.group_id = $groupId AND ifnull(CLM.isarchive, 0) = 0
      """;
    _logger.info(this, "_getFilesInGroup($query)");
    return await _mainDBProvider.queryToModelList<ICLMFileModel>(query,
        converter: (_, item) async => builder.build(item));
  }

  Future<List<ICLMFileModel>> _getFilesFor(String search) async {
    String query = """
        SELECT
         CLM._id AS ${ICLMFileModel.FIELD_ID}
        ,CLM.name AS ${ICLMFileModel.FIELD_NAME}
        ,CLM.filename AS ${ICLMFileModel.FIELD_FILE_NAME}
        ,CLM.fileext AS ${ICLMFileModel.FIELD_FILE_EXTENSION}
        ,CLM.guid AS ${ICLMFileModel.FIELD_GUID}
        FROM info_clm CLM
	      INNER JOIN info_clmingroup CLM_IN_GROUP ON CLM_IN_GROUP.clm_id = CLM._id
	      INNER JOIN (
	        SELECT CLM_GROUP._id AS clmgroup_id
	        FROM info_clmgroup CLM_GROUP
	        WHERE CLM_GROUP._id IN (
              SELECT clmgroup_id FROM info_clmgroupdirection WHERE direction_id IN (
                SELECT direction_id FROM info_userdirection WHERE user_id = 5
              )
            )
	          AND ifnull(CLM_GROUP.isarchive, 0) = 0
        ) CLM_GROUP_BY_DIRECTION ON CLM_GROUP_BY_DIRECTION.clmgroup_id = CLM_IN_GROUP.group_id
        WHERE CLM.name LIKE '$search%' 
      """;
    _logger.info(this, "_getFilesFor($query)");
    return await _mainDBProvider.queryToModelList<ICLMFileModel>(query,
        converter: (_, item) async => builder.build(item));
  }

  List<ICLMItemModel> _sortItems(List<ICLMItemModel> items) => items
    ..sort((a, b) {
      if (a is CLMFolderModel && b is CLMFolderModel) {
        if (null == a.name && null == b.name) {
          return 0;
        } else {
          return (a.name ?? "").compareTo(b.name ?? "");
        }
      }
      if (a is CLMFolderModel && b is ICLMFileModel) {
        return -1;
      }

      if (a is ICLMFileModel && b is CLMFolderModel) {
        return 1;
      }

      if (a is ICLMFileModel && b is ICLMFileModel) {
        return a.name.compareTo(b.name);
      } else
        return 0;
    });
}