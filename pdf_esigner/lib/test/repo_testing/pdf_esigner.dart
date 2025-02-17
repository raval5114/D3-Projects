import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Model class to store file information
class PdfFileForFlutter {
  final Uint8List pdfFile;
  final String fileName;
  final int fileSize;
  bool isSigned;
  Uint8List? signedPdf; // Nullable to avoid uninitialized variable errors

  PdfFileForFlutter(this.pdfFile, this.fileName, this.fileSize,
      {this.isSigned = false, this.signedPdf});
}

class PdfEsignerTest {
  List<PdfFileForFlutter> pdfFiles = [];
  Uint8List? pfxFile; // Nullable to handle cases where no pfx is picked

  // Method to pick files (PDF or PFX)
  Future<void> pickFiles(String restrictedFileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: restrictedFileType.toLowerCase() == "pdf",
        withData: true, // Ensures bytes are loaded
        allowedExtensions:
            restrictedFileType.toLowerCase() == "pdf" ? ['pdf'] : ['pfx'],
      );

      if (result != null) {
        if (restrictedFileType.toLowerCase() == "pfx") {
          if (result.files.isNotEmpty && result.files.first.bytes != null) {
            pfxFile = result.files.first.bytes!;
            debugPrint("PFX file loaded: ${result.files.first.name}");
          }
        } else {
          pdfFiles.clear();
          for (var file in result.files) {
            if (file.bytes != null) {
              pdfFiles.add(PdfFileForFlutter(
                file.bytes!,
                file.name,
                file.size,
              ));
            }
          }
          debugPrint("Picked ${pdfFiles.length} PDF files.");
        }
      } else {
        debugPrint("No files were selected.");
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  // Method to sign a PDF using a PFX file
  Future<void> signPdf(PdfFileForFlutter file) async {
    try {
      // Load the PDF document
      PdfDocument document = PdfDocument(inputBytes: file.pdfFile);

      // Ensure a PFX file is loaded
      if (pfxFile == null) {
        debugPrint("No PFX file loaded for signing.");
        return;
      }

      // Assuming the PFX file contains a certificate and password
      final pfxCertificate = PdfCertificate(pfxFile!, '1234567890');

      // Add signature field to the document
      PdfSignatureField signatureField = PdfSignatureField(
        document.pages[0], // Add signature on the first page
        'Signature',
        bounds: Rect.fromLTWH(0, 0, 200, 50),
        signature: PdfSignature(certificate: pfxCertificate),
      );

      // Add the signature field to the document
      document.form.fields.add(signatureField);

      // Save the signed document to a new file
      final signedPdfBytes = await document.save();
      document.dispose();

      // Save the signed PDF
      file.signedPdf = signedPdfBytes as Uint8List?;
      file.isSigned = true;

      // Optionally, you can save the signed file to the file system
      final signedPdfFile = File('signed_${file.fileName}');
      await signedPdfFile.writeAsBytes(signedPdfBytes);
      debugPrint("PDF signed and saved as ${signedPdfFile.path}");
    } catch (e) {
      debugPrint("Error signing PDF: $e");
    }
  }

  void downloadFile() {
    //create a function for downloading that signed file
  }
}

// Testing instance
final PdfEsignerTest esignerTest = PdfEsignerTest();
