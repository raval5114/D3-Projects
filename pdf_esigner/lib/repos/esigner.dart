import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:file_picker/file_picker.dart'; // For cross-platform file picking
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // For getting temp directory
import 'dart:typed_data';
import 'dart:ui';
import 'package:universal_html/html.dart'
    as universal_html; // For web file downloads

class Esigner {
  File? pdfFile; // Declare the file variable for native platforms (PDF)
  Uint8List? pdfBytes; // For web (bytes of the PDF file)
  String? pdfFileName; // For web (PDF file name)
  File? pfxFile; // Declare the file variable for native platforms (PFX)
  Uint8List? pfxBytes; // For web (bytes of the PFX file)
  String? pfxFileName; // For web (PFX file name)
  Uint8List? signedBytes;
  String? signedPdfPath; // Path to save the signed PDF

  Future<void> pickFile(String restrictedFileType) async {
    try {
      // Pick file using file_picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions:
            restrictedFileType.toLowerCase() == "pdf" ? ['pdf'] : ['pfx'],
      );

      if (result != null) {
        if (kIsWeb) {
          // Handle web-specific logic
          Uint8List? fileBytes = result.files.first.bytes; // File bytes for web
          String? fileName = result.files.first.name; // File name

          if (restrictedFileType.toLowerCase() == "pdf") {
            pdfBytes = fileBytes;
            pdfFileName = fileName;
            debugPrint("Selected PDF file: $pdfFileName");
          } else {
            pfxBytes = fileBytes;
            pfxFileName = fileName;
            debugPrint("Selected PFX file: $pfxFileName");
          }
        } else {
          // Handle non-web platforms
          final path =
              result.files.single.path; // File path for native platforms

          if (path != null) {
            if (restrictedFileType.toLowerCase() == "pdf") {
              pdfFile = File(path);
              debugPrint("Selected PDF file path: ${pdfFile!.path}");
            } else {
              pfxFile = File(path);
              debugPrint("Selected PFX file path: ${pfxFile!.path}");
            }
          } else {
            // Convert bytes to a File if `path` is null
            Uint8List? fileBytes = result.files.single.bytes;
            if (fileBytes != null) {
              if (restrictedFileType.toLowerCase() == "pdf") {
                pdfFile =
                    await _bytesToFile(fileBytes, result.files.single.name);
                debugPrint("PDF file saved to: ${pdfFile!.path}");
              } else {
                pfxFile =
                    await _bytesToFile(fileBytes, result.files.single.name);
                debugPrint("PFX file saved to: ${pfxFile!.path}");
              }
            } else {
              debugPrint("Failed to retrieve file bytes.");
            }
          }
        }
      } else {
        debugPrint("No file selected.");
      }
    } catch (e) {
      debugPrint("Error during file picking: $e");
    }
  }

  Future<File> _bytesToFile(Uint8List bytes, String fileName) async {
    try {
      // Get a temporary directory for the app
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/$fileName';

      // Write the bytes to the file
      final file = File(tempPath);
      await file.writeAsBytes(bytes);

      return file; // Return the saved file
    } catch (e) {
      print("Error writing file: $e");
      rethrow;
    }
  }

  Future<bool> signByPfx(String password) async {
    try {
      if (pdfFile == null && pdfBytes == null) {
        throw Exception("No PDF file loaded. Please select a PDF file first.");
      }
      if (pfxFile == null && pfxBytes == null) {
        throw Exception("No PFX file loaded. Please select a PFX file first.");
      }

      // Load PDF and PFX data
      Uint8List pdfData = pdfBytes ?? await pdfFile!.readAsBytes();
      Uint8List pfxData = pfxBytes ?? await pfxFile!.readAsBytes();

      // Create a PDF document
      PdfDocument document = PdfDocument(inputBytes: pdfData);

      // Add a signature field
      PdfPage page = document.pages[0];
      PdfSignatureField signatureField = PdfSignatureField(
        page,
        'Signature',
        bounds: const Rect.fromLTWH(100, 100, 200, 50),
      );

      // Create a certificate from the PFX file
      PdfCertificate certificate = PdfCertificate(
        pfxData,
        password,
      );

      signatureField.signature = PdfSignature(certificate: certificate);
      document.form.fields.add(signatureField);

      // Save the document
      List<int> signedData = await document.save();
      signedBytes = Uint8List.fromList(signedData);

      if (kIsWeb) {
        // Web-specific logic
      } else {
        // Native platform logic
        signedPdfPath = '${pdfFile!.parent.path}/signed_document.pdf';
        await File(signedPdfPath!).writeAsBytes(signedBytes!);
        debugPrint("PDF signed successfully! Saved at: $signedPdfPath");
        openSignedPdf();
      }

      document.dispose();
      return true;
    } catch (e) {
      debugPrint("Error signing PDF: ${e.toString()}");
      throw Exception(
          "Failed to sign the PDF. Please ensure the password is correct or try again.");
    }
  }

  void downloadPdf_ForWeb() {
    final fileDownloader = FileDownloader();

    fileDownloader.downloadFile(signedBytes!, "signed_document.pdf");
  }

  void openSignedPdf() {
    if (signedPdfPath != null && !kIsWeb) {
      OpenFile.open(signedPdfPath);
    }
  }
}

class FileDownloader {
  Future<void> downloadFile(Uint8List data, String fileName) async {
    if (kIsWeb) {
      _downloadFileWeb(data, fileName);
    } else {
      await _downloadFileNative(data, fileName);
    }
  }

  void _downloadFileWeb(Uint8List data, String fileName) {
    final blob = universal_html.Blob([data], 'application/pdf');
    final url = universal_html.Url.createObjectUrlFromBlob(blob);
    final anchor = universal_html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();
    universal_html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadFileNative(Uint8List data, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(data);
    debugPrint('File saved at $filePath');
  }
}
