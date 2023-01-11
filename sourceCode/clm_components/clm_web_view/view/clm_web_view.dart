
import 'dart:io';
import 'package:proximacrm/ui/_component/clm_components/clm_web_view/bloc/clm_web_view_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_web_view/bloc/clm_web_view_state.dart';
import 'package:proximacrm/ui/widgets/view_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CLMWebView extends StatelessWidget {
  final String title;
  final File file;

  CLMWebView({ required this.title, required this.file });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CLMWebViewBloc(),
      child: Scaffold(
        body: BlocBuilder<CLMWebViewBloc, ICLMWebViewState>(
          builder: (context, state) => Stack(
            children: [
              ViewAppBar(
                title: title,
              ),
              Container(
                color: Theme.of(context).backgroundColor,
                child: WebView(
                  zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  allowsInlineMediaPlayback: true,
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    webViewController.loadFile(file.path);
                  },
                ) 
              ),
            ],
          ),  
        ),
      ),
    );
  }
}