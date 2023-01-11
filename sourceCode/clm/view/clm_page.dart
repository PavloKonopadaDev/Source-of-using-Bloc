import 'package:open_file/open_file.dart';
import 'package:proximacrm/extensions/ext_context.dart';
import 'package:proximacrm/l10n/localization.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/repository/model/clm_map_model.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/view/clm_map_page_view.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/view/clm_pdf_view.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_web_view/view/clm_web_view.dart';
import 'package:proximacrm/ui/_component/crm_list/view/crm_list_seacrh_field.dart';
import 'package:proximacrm/ui/page/clm/bloc/clm_bloc.dart';
import 'package:proximacrm/ui/page/clm/bloc/clm_event.dart';
import 'package:proximacrm/ui/page/clm/bloc/clm_state.dart';
import 'package:proximacrm/ui/page/clm/repository/clm_file_builder.dart';
import 'package:proximacrm/ui/page/clm/repository/clm_repository.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_file_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/_clm_item_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_folder_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_html_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_map_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_pdf_model.dart';
import 'package:proximacrm/ui/page/clm/repository/model/clm_video_model.dart';
import 'package:proximacrm/ui/page/clm/view/part/clm_item_view.dart';
import 'package:proximacrm/ui/screen/home/_component/page_router/page_router.dart';
import 'package:proximacrm/ui/widgets/view_app_bar.dart';
import 'package:proximacrm/ui/widgets/view_snackbar.dart';
import 'package:proximacrm/values/dimens.dart';
import 'package:proximacrm/values/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CLMPage extends StatelessWidget {
  static const double _EMPTY_FOLDER_OPACITY = .3;
  static const double _MAX_CROSS_AXIS_EXTENT = 180;

  static _openFolder(BuildContext context, [CLMFolderModel? folderModel]) => context.read<CLMBloc>().add(OpenFolderCLMEvent(folderModel));
  static _openFile(BuildContext context, ICLMFileModel fileModel) => context.read<CLMBloc>().add(OpenFileCLMEvent(fileModel));
  static _searchItems(BuildContext context, String search) => context.read<CLMBloc>().add(SearchItemCLMEvent(search));

  final PageRouter controller;

  CLMPage(this.controller);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CLMBloc(CLMRepository(CLMFileBuilder())),
      child: BlocListener<CLMBloc, ICLMState>(
        listener: (context, state) async {
          if (state is CLMOpenPdfFileState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CLMPDFView(state.file)));
          }
          if (state is CLMOpenMapState) {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => CLMMapPageView(clmId: state.clmId, title: state.title, guid: state.guid)));
          }
          if (state is CLMOpenHtmlFileState) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CLMWebView(title: state.title, file: state.file)));
          }
          if (state is CLMOpenVideoFileState) {
            var result = await OpenFile.open(state.file.path);
            if(result.type != ResultType.done) {
              ViewSnackBar.warning(context, result.message);
            }
          }
          if (state is CLMOpenUndefinedFileState) {
            var result = await OpenFile.open(state.file.path);
            if(result.type != ResultType.done) {
              ViewSnackBar.warning(context, result.message);
            }
          }
        },
        child: BlocBuilder<CLMBloc, ICLMState>(
          buildWhen: (previous, current) => current is! IClMOpenCLMState,
          builder: (context, state) => WillPopScope(
            onWillPop: () async {
              if (state is CLMState && null != state.parent) {
                _openFolder(context, state.parent!);
                return false;
              } else {
                return true;
              }
            },
            child: Column(
              children: [
                ViewAppBar(
                  title: L10n.of("menu_clm"),
                  maxVisibleIcons: 0,
                  content: Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: ThemeDimens.searchWidth,
                      child: CRMListSearchField(
                        onChange: (value) => _searchItems(context, value),
                        onClear: () => _openFolder(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: context.isPhone ? ThemeDimens.spaceBig : ThemeDimens.spaceNormal,
                      right: ThemeDimens.spaceBig,
                      bottom: ThemeDimens.spaceBig,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(ThemeDimens.spaceNormal),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(ThemeDimens.radius)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: ThemeDimens.blurRadius,
                          ),
                        ],
                      ),
                      child: state is DisplayCLMState
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state is CLMState)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: ThemeDimens.spaceNormal),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                    children: List.generate(
                                        state.breadCrumbs.length,
                                            (index) => InkWell(
                                                onTap: null != state.breadCrumbs[index] ? () => _openFolder(context,state.breadCrumbs[index]!): null,
                                                child: Text("${state.breadCrumbs[index]?.name ?? L10n.of("clm_root_folder")}\\",style: Theme.of(context).textTheme.subtitle1))))),
                                ),
                              if (state is CLMSearchState)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: ThemeDimens.spaceNormal),
                                  child: Text("${L10n.of("search_results")}: \"${state.search}\"", style: Theme.of(context).textTheme.subtitle1),
                                ),
                              Expanded(
                                child: state.items.isNotEmpty
                                  ? GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: _MAX_CROSS_AXIS_EXTENT),
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.items.length,
                                      itemBuilder: (BuildContext context, int index) => _buildCLMItem(context, state.items[index])
                                    )
                                  : Center(
                                      child: Opacity(
                                        opacity: _EMPTY_FOLDER_OPACITY,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ThemeImages.clmFolder,
                                            SizedBox(height: ThemeDimens.spaceNormal),
                                            Text(L10n.of("clm_empty_folder"),style: Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).primaryColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                              ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCLMItem(BuildContext context, ICLMItemModel itemModel) => itemModel is CLMFolderModel
    ? CLMItemView(itemModel.name ?? L10n.of("clm_root_folder"),
      image: ThemeImages.clmFolder,
      onSelect: () => _openFolder(context, itemModel))
    : itemModel is ICLMFileModel
      ? _buildCLMFile(context, itemModel)
    : CLMItemView(L10n.of("error"),
      image: ThemeImages.clmUndefined);

  Widget _buildCLMFile(BuildContext context, ICLMFileModel itemModel) =>
      CLMItemView(itemModel.name,
      image: itemModel is CLMMapModel
      ? ThemeImages.clmInteractive: itemModel is CLMHtmlModel
      ? ThemeImages.clmInteractive: itemModel is CLMMapsModel
      ? ThemeImages.clmInteractive: itemModel is CLMPdfModel
      ? ThemeImages.clmPdf: itemModel is CLMVideoModel
      ? ThemeImages.clmVideo: ThemeImages.clmUndefined,
      onSelect: () => _openFile(context, itemModel));
}