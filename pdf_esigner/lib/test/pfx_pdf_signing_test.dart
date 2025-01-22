import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart'; // Add this package
import 'package:path/path.dart';

class PfxPdfSigningTest extends StatefulWidget {
  const PfxPdfSigningTest({super.key});

  @override
  State<PfxPdfSigningTest> createState() => _PfxPdfSigningTestState();
}

class _PfxPdfSigningTestState extends State<PfxPdfSigningTest> {
  File? sampleFilePdf;
  File? sampleFilePfx;
  bool isLoading = true;

  // Method to load the PDF file from assets
  Future<void> loadPdfFromAssets() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/samples/hr_resume_1.pdf');
      final buffer = data.buffer.asUint8List();
      final tempDir = await Directory.systemTemp.createTemp();
      final pdfFile = File('${tempDir.path}/hr_resume_1.pdf');
      await pdfFile.writeAsBytes(buffer);

      setState(() {
        sampleFilePdf = pdfFile;
        debugPrint('PDF file loaded successfully.');
      });
    } catch (e) {
      debugPrint("Error loading PDF from assets: $e");
    }
  }

  // Method to load the PFX file from assets
  Future<void> loadPfxFromAssets() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/samples/Demo PFX file.pfx');
      final buffer = data.buffer.asUint8List();
      final tempDir = await Directory.systemTemp.createTemp();
      final pfxFile = File('${tempDir.path}/Demo PFX file.pfx');
      await pfxFile.writeAsBytes(buffer);

      setState(() {
        sampleFilePfx = pfxFile;
        isLoading = false;
        debugPrint('PFX file loaded successfully.');
      });
    } catch (e) {
      debugPrint("Error loading PFX from assets: $e");
    }
  }

  // Signs the loaded PDF using the selected PFX certificate
  Future<bool> signByPfx(String password) async {
    try {
      if (sampleFilePdf == null || sampleFilePfx == null) {
        throw Exception("Files not loaded. Please try again.");
      }

      PdfDocument document =
          PdfDocument(inputBytes: await sampleFilePdf!.readAsBytes());

      PdfPage page = document.pages[0];
      PdfSignatureField signatureField = PdfSignatureField(
        page,
        'Signature',
        bounds: const Rect.fromLTWH(100, 100, 200, 50),
      );

      PdfCertificate certificate = PdfCertificate(
        await sampleFilePfx!.readAsBytes(),
        password,
      );

      signatureField.signature = PdfSignature(certificate: certificate);
      document.form.fields.add(signatureField);

      // Get application documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String signedPdfPath = '${appDocDir.path}/signed_document.pdf';
      await File(signedPdfPath).writeAsBytes(await document.save());

      document.dispose();
      debugPrint("PDF signed successfully! Saved at: $signedPdfPath");
      return true;
    } catch (e) {
      debugPrint("Error signing PDF: ${e.toString()}");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadPdfFromAssets();
    loadPfxFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PfxPdfSigningTest",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      const String password =
                          '1234567890'; // Replace with actual PFX password
                      try {
                        bool success = await signByPfx(password);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Document signed successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to sign the document."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        //Add Alertbox if any error arrises
                      }
                    },
              child: const Text("Sign Document"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
