import 'dart:io';

abstract class ICLMPdfState {}

class LoadingCLMPdfState implements ICLMPdfState {}

class CLMPdfState implements ICLMPdfState {
  final File file;

  CLMPdfState(this.file);
}