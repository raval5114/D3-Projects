import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfFileForFlutter {
  final Uint8List pdfFile;
  final String fileName;
  final int fileSize;
  bool isSigned;
  Uint8List? signedPdf;

  PdfFileForFlutter(this.pdfFile, this.fileName, this.fileSize,
      {this.isSigned = false, this.signedPdf});
}

class PdfEsignerWeb {
  List<PdfFileForFlutter> pdfFiles = [];
  Uint8List? pfxFile;

  Future<void> pickFiles(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: fileType.toLowerCase() == "pdf",
        withData: true,
        allowedExtensions: fileType.toLowerCase() == "pdf" ? ['pdf'] : ['pfx'],
      );

      if (result != null && result.files.isNotEmpty) {
        if (fileType.toLowerCase() == "pfx") {
          pfxFile = result.files.first.bytes;
          debugPrint("PFX file loaded: ${result.files.first.name}");
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

  Future<bool> signByPfx(PdfFileForFlutter file, String password) async {
    try {
      if (file.pdfFile.isEmpty) {
        throw Exception("Selected PDF file is empty or invalid.");
      }
      if (pfxFile == null) {
        throw Exception("No PFX file loaded. Please select a PFX file first.");
      }

      Uint8List pdfData = file.pdfFile;
      Uint8List pfxData = pfxFile!;

      PdfDocument document = PdfDocument(inputBytes: pdfData);

      PdfCertificate? certificate;
      try {
        certificate = PdfCertificate(pfxData, password);
      } catch (e) {
        debugPrint("Invalid PFX certificate or incorrect password.");
        return false;
      }

      if (certificate == null) {
        debugPrint("Failed to load certificate.");
        return false;
      }

      PdfPage firstPage = document.pages[0];
      PdfSignatureField signatureField = PdfSignatureField(
        firstPage,
        'Signature',
        bounds: const Rect.fromLTWH(100, 100, 200, 50),
      );
      signatureField.signature = PdfSignature(certificate: certificate);
      document.form.fields.add(signatureField);

      String signerName = certificate.subjectName;
      String issuerName = certificate.issuerName;
      DateTime validFrom = certificate.validFrom;
      DateTime validTo = certificate.validTo;

      PdfPage acknowledgmentPage = document.pages.add();

      String acknowledgmentText = '''
    **Digitally Signed Document**
    
    This document has been digitally signed using a secure PFX certificate.
    
    **Signer Details:**
    - Signed by: $signerName
    - Issued by: $issuerName
    - Valid From: ${validFrom.toLocal()}
    - Valid Until: ${validTo.toLocal()}
    
    This digital signature ensures the authenticity and integrity of this document.
    ''';

      PdfTextElement textElement = PdfTextElement(
        text: acknowledgmentText,
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      textElement.draw(
        page: acknowledgmentPage,
        bounds: Rect.fromLTWH(20, 100, acknowledgmentPage.size.width - 40, 400),
      );

      List<int> signedData = await document.save();
      Uint8List signedBytes = Uint8List.fromList(signedData);

      file.isSigned = true;
      file.signedPdf = signedBytes;

      debugPrint(
          "PDF successfully signed with an acknowledgment page at the end.");
      document.dispose();
      return true;
    } catch (e) {
      debugPrint("Error signing PDF: ${e.toString()}");
      return false;
    }
  }

  Future<void> signAllFiles(String password) async {
    if (pfxFile == null) {
      debugPrint("No PFX file loaded. Please select a PFX file first.");
      return;
    }

    for (var file in pdfFiles) {
      bool result = await signByPfx(file, password);
      if (!result) {
        debugPrint("Failed to sign file: ${file.fileName}");
      } else {
        debugPrint("Successfully signed file: ${file.fileName}");
      }
    }
  }

  Future<void> downloadFile(PdfFileForFlutter file, fileName) async {
    if (file.signedPdf == null || file.signedPdf!.isEmpty) {
      debugPrint("No signed file available for download.");
      return;
    }

    String signedFileName = file.fileName.replaceAll(".pdf", "_signed.pdf");

    final blob = html.Blob([file.signedPdf], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = signedFileName
      ..click();
    html.Url.revokeObjectUrl(url);

    debugPrint("Signed PDF downloaded: $signedFileName");
  }
}

PdfEsignerWeb esignerWeb = PdfEsignerWeb();
