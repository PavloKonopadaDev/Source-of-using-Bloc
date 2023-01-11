
import 'dart:io';

class CLMPDFRepository {
    final File _file;

    Future<File> get pdfFile async => _file;
    
    CLMPDFRepository(this._file);
}