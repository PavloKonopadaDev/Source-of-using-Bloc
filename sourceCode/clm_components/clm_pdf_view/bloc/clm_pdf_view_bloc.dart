import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/bloc/clm_pdf_view_event.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/bloc/clm_pdf_view_state.dart';
import 'package:proximacrm/ui/_component/clm_components/clm_pdf_view/repository/clm_pdf_repository.dart';


class CLMPdfBloc extends Bloc<ICLMPdfEvent, ICLMPdfState> {
  final CLMPDFRepository _repository;

  CLMPdfBloc(this._repository) : super(LoadingCLMPdfState());

  @override
  Stream<ICLMPdfState> mapEventToState(ICLMPdfEvent event) async* {
    if (event is LoadingCLMPdfEvent) {
      yield CLMPdfState(await _repository.pdfFile);
    }
  }
}