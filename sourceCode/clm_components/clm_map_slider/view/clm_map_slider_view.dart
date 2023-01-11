
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/extensions/ext_context.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/bloc/clm_map_slider_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/bloc/clm_map_slider_event.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/bloc/clm_map_slider_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/repository/clm_map_slider_repository.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_map_slider/repository/model/clm_map_slider_model.dart';
import 'package:proximacrm/ui/widgets/@view_slider.dart';
import 'package:proximacrm/values/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CLMMapSliderView extends StatelessWidget {
  static const double _WIDTH_OF_ITEMS = 225;
  static const int _ANIMATION_DURATION = 1;

  static _showSlide(BuildContext context, int slideId) => context.read<CLMMapSliderBloc>().add(CLMMapShowSlideEvent(slideId));
  static _hideSlide(BuildContext context, int slideId) => context.read<CLMMapSliderBloc>().add(CLMMapHideSlideEvent(slideId));

  final int clmId;
  final int clmMapId;
  final String guid;

  CLMMapSliderView({
    required this.clmId,
    required this.clmMapId,
    required this.guid,
  });

  @override
  Widget build(BuildContext context) {
    context.setOrientationLandscape();
    PageController pageController = PageController();
    return Scaffold(
      body: BlocProvider(
        create: (context) => CLMMapSliderBloc(CLMMapSliderRepository(clmId, clmMapId, guid))..add(CLMMapSliderLoadItemsEvent()),
        child: BlocBuilder<CLMMapSliderBloc, ICLMMapSliderState>(
          builder: (context, state) => Container(
            child: state is CLMMapSliderState
              ? ViewSlider(
                  pageController: pageController,
                  itemBuilders: ((context, index, isSelected) => _buildMainItems(context, state.items[index])),
                  itemCounts: state.items.length,
                  thumbnailItemBuilder:(context, index, currentSelected) => Container(
                    width: _WIDTH_OF_ITEMS,
                    color: currentSelected == index ? ThemeColors.primaryLight : Colors.transparent,
                    child: ListTile(
                      onTap: () => {
                        currentSelected = index,
                        pageController.animateToPage(currentSelected, duration: Duration(milliseconds: _ANIMATION_DURATION), curve: Curves.ease),
                      },
                      title: Container(
                        width: _WIDTH_OF_ITEMS,
                        child: _buildMirrorItems(context, state.items[index])),
                    ),
                  ),
                  onShowSlide: (index) => _showSlide(context, state.items[index].id),
                  onHideSlide: (index) => _hideSlide(context, state.items[index].id),
                )
              : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildMirrorItems(BuildContext context, CLMMapSlideModel itemModel) => Container(
    decoration: BoxDecoration(image: DecorationImage(image: FileImage(itemModel.slide))),
  );

  Widget _buildMainItems(BuildContext context, CLMMapSlideModel itemModel) => WebView(
    zoomEnabled: false,
    javascriptMode: JavascriptMode.unrestricted,
    allowsInlineMediaPlayback: true,
    gestureNavigationEnabled: true,
    onWebViewCreated: (WebViewController webViewController) {
      webViewController.loadFile(itemModel.file.path);
    },
  );
}