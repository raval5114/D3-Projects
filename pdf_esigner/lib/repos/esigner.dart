import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart';

class Esigner {
  File? _pdfFile;
  File? _pfxFile;
  String?
      signedPdfPath; // Data member to store the path of the current signed PDF

  // Getter for PDF file
  File? get pdfFile => _pdfFile;
  // Getter for pdfFileName
  String get pdfFileName => basename(_pdfFile!.path);
  String get pfxFileName => basename(_pfxFile!.path);
  // Getter for PFX file
  File? get pfxFile => _pfxFile;

  // Method to remove the PDF file path
  void removePdfFilePath() {
    _pdfFile = null;
    debugPrint("PDF file path removed.");
  }

  // Method to remove the PFX file path
  void removePfxFilePath() {
    _pfxFile = null;
    debugPrint("PFX file path removed.");
  }

  /// Picks a file based on the specified type (PDF or PFX).
  Future<void> pickFile(String restrictedFileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions:
            restrictedFileType.toLowerCase() == "pdf" ? ['pdf'] : ['pfx'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        if (restrictedFileType.toLowerCase() == "pdf") {
          _pdfFile = file;
          debugPrint("PDF file selected: ${_pdfFile!.path}");
        } else if (restrictedFileType.toLowerCase() == "pfx") {
          _pfxFile = file;
          debugPrint("PFX file selected: ${_pfxFile!.path}");
        } else {
          debugPrint("Unsupported file type: $restrictedFileType");
        }
      } else {
        debugPrint("File picking canceled.");
      }
    } catch (e) {
      debugPrint("Error during file picking: $e");
    }
  }

  /// Signs the loaded PDF using the selected PFX certificate.
  Future<bool> signByPfx(String password) async {
    try {
      if (_pdfFile == null) {
        throw Exception("No PDF file loaded. Please select a PDF file first.");
      }
      if (_pfxFile == null) {
        throw Exception("No PFX file loaded. Please select a PFX file first.");
      }

      PdfDocument document =
          PdfDocument(inputBytes: await _pdfFile!.readAsBytes());

      PdfPage page = document.pages[0];
      PdfSignatureField signatureField = PdfSignatureField(
        page,
        'Signature',
        bounds: const Rect.fromLTWH(100, 100, 200, 50),
      );

      PdfCertificate certificate = PdfCertificate(
        await _pfxFile!.readAsBytes(),
        password,
      );

      signatureField.signature = PdfSignature(certificate: certificate);
      document.form.fields.add(signatureField);

      signedPdfPath =
          '${_pdfFile!.parent.path}/signed_document.pdf'; // Store the signed PDF path
      await File(signedPdfPath!).writeAsBytes(await document.save());

      document.dispose();
      debugPrint("PDF signed successfully! Saved at: $signedPdfPath");
      openSignedPdf();
      return true;
    } catch (e) {
      debugPrint("Error signing PDF: ${e.toString()}");
      throw Exception("Failed to sign the PDF. Please try again.");
    }
  }

  /// Opens the signed PDF document in a default PDF viewer app.
  Future<void> openSignedPdf() async {
    try {
      if (signedPdfPath == null) {
        throw Exception(
            "No signed PDF available. Please sign a document first.");
      }

      final result = await OpenFile.open(signedPdfPath!);

      if (result.type != ResultType.done) {
        debugPrint("Failed to open the signed document: ${result.message}");
      } else {
        debugPrint("Signed PDF opened successfully.");
      }
    } catch (e) {
      debugPrint("Error opening signed PDF: ${e.toString()}");
    }
  }

  /// Simulates signing the document with a handwritten signature.
  void signByHandwritten() {
    // Method implementation unchanged...
  }

  void signingByText() {}
  void uploadingStampOrImage() {}
}
