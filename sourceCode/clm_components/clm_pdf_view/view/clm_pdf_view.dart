import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/bloc/clm_pdf_view_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/bloc/clm_pdf_view_event.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/bloc/clm_pdf_view_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/repository/clm_pdf_repository.dart';

class CLMPDFView extends StatelessWidget {
  final File file;

  CLMPDFView(this.file);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocProvider(
      create: (context) => CLMPdfBloc(CLMPDFRepository(file))..add(LoadingCLMPdfEvent()),
      child: BlocBuilder<CLMPdfBloc, ICLMPdfState>(
        builder: (context, state) => Container(
          child: state is CLMPdfState
          ? PdfView(
              controller: PdfController(
                document: PdfDocument.openFile(state.file.path)),
            )
          : Center(child: CircularProgressIndicator()),
        ),
      ),
    ),
  );
}