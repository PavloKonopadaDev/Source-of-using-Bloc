
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/l10n/localization.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/bloc/clm_map_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/bloc/clm_map_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/repository/clm_map_repository.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map/repository/model/clm_map_model.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/view/clm_map_slider_view.dart';
import 'package:proximacrm/values/dimens.dart';
import 'package:proximacrm/extensions/ext_context.dart';

class CLMMapPageView extends StatelessWidget {
  static const double clmSlideHeight = 300;
  static const double clmSlideWidth = 225;

  static const double _TITLE_OPACITY = 0.7;
  static const int _MAX_LINES = 1;

  final int clmId;
  final String title;
  final String guid;

  CLMMapPageView({
    required this.clmId, 
    required this.title, 
    required this.guid,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).backgroundColor,
    appBar: AppBar(title: Text(title)),
    body: BlocProvider(
      create: (context) => CLMMapBloc(CLMMapRepository(clmId, guid)),
      child: BlocBuilder<CLMMapBloc, ICLMMapState>(
        builder: (context, state) => Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            state is CLMMapState
              ? Expanded(
                child: state.items.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.all(ThemeDimens.spaceBigger),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: clmSlideHeight,
                          mainAxisExtent: clmSlideWidth ,
                          crossAxisSpacing: ThemeDimens.spaceMedium,
                          mainAxisSpacing: ThemeDimens.spaceBigger,
                        ),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) => _buildItem(context, state.items[index]),
                      ),
                    )
                  : Center(
                      child: Padding(padding: const EdgeInsets.all(ThemeDimens.dialogMinHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(L10n.of("empty_clm_map"),
                                style: Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).hintColor)),
                          ],
                        ),
                      ),
                    ),
              )
            : Center(child: const CircularProgressIndicator()),
          ],
        ),
      ),
    ),
  );

  Widget _buildItem(BuildContext context, CLMMapModel itemModel) => InkWell(
    onTap: () async {
      await Navigator.push(context, MaterialPageRoute(builder: (context) =>
        CLMMapSliderView(clmId: clmId, clmMapId: itemModel.id, guid: guid)));
      context.setOrientationAuto();
      },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        color: Theme.of(context).shadowColor,
      ),
      child: Stack(
        children: [
          Center(child: Image.file(itemModel.slide)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: ThemeDimens.spaceMedium,
                  horizontal: ThemeDimens.spaceBigger),
              color: Theme.of(context).shadowColor.withOpacity(_TITLE_OPACITY),
              child: Text(title,
                  style: Theme.of(context).textTheme.headline5?.copyWith(color: Theme.of(context).indicatorColor),
                  textAlign: TextAlign.center,
                  maxLines: _MAX_LINES,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    ),
  );
}