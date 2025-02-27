import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'package:pdf_esigner/test/repo_testing/pdf_esigner.dart';
import 'package:pdf_esigner/widgets/src/acknowledgementOfFile.dart';
import 'package:pdf_esigner/widgets/src/fileShowingTile.dart';
import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'package:pdf_esigner/test/repo_testing/pdf_esigner.dart';
import 'package:pdf_esigner/widgets/src/acknowledgementOfFile.dart';
import 'package:pdf_esigner/widgets/src/fileShowingTile.dart';

class HomePageForWeb extends StatefulWidget {
  const HomePageForWeb({super.key});

  @override
  State<HomePageForWeb> createState() => _HomePageForWebState();
}

class _HomePageForWebState extends State<HomePageForWeb> {
  String? pfxFileName;
  Map<String, double> signingProgress = {};
  bool isSigningAll = false;

  void _pickPdfFiles() async {
    await esignerWeb.pickFiles("pdf");
    setState(() {});
  }

  void _pickPfxFile() async {
    await esignerWeb.pickFiles("pfx");
    setState(() {
      pfxFileName = esignerWeb.pfxFile != null ? "✅ PFX File Selected" : null;
    });
  }

  void showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> signPdfWithProgress(PdfFileForFlutter file) async {
    try {
      for (double progress = 0.2; progress <= 1.0; progress += 0.2) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!mounted)
          return false; // Prevents updating state if widget is unmounted
        setState(() => signingProgress[file.fileName] = progress);
      }

      bool success = await esignerWeb.signByPfx(file, '1234567890');

      if (success) {
        if (!mounted) return false;
        setState(() => signingProgress[file.fileName] = 1.0);
      } else {
        signingProgress.remove(file.fileName);
      }

      return success;
    } catch (e) {
      if (mounted) {
        showSnackbar("❌ Error while signing: $e", Colors.red);
      }
      return false;
    }
  }

  Future<void> _signAllFiles() async {
    if (pfxFileName == null) {
      showSnackbar("❌ No PFX file selected!", Colors.red);
      return;
    }

    bool confirmSign = await _showConfirmationDialog();
    if (!confirmSign) return;

    setState(() => isSigningAll = true);

    bool allSuccess = true;

    for (var file in esignerWeb.pdfFiles) {
      if (!file.isSigned) {
        if (!mounted) return;
        setState(() => signingProgress[file.fileName] = 0.1);
        bool success = await signPdfWithProgress(file);
        if (!success) {
          allSuccess = false;
        }
      }
    }

    if (!mounted) return;
    setState(() => isSigningAll = false);

    showSnackbar(
      allSuccess
          ? "✅ All files signed successfully!"
          : "❌ Some files failed to sign!",
      allSuccess ? Colors.green : Colors.red,
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Signing"),
            content:
                const Text("Are you sure you want to sign all selected PDFs?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Sign All"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PDF Signer"),
          backgroundColor: PRIMARY_COLOR,
          centerTitle: true,
          elevation: 4,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              AnimatedOpacity(
                opacity: pfxFileName != null ? 1.0 : 0.0,
                duration: ANIMATION_SPEED,
                child: PfxAcknowledgment(pfxFileName: pfxFileName),
              ),
              const SizedBox(height: 10),
              if (pfxFileName != null)
                ElevatedButton(
                  onPressed: isSigningAll ? null : _signAllFiles,
                  child: isSigningAll
                      ? const CircularProgressIndicator()
                      : const Text("Sign All"),
                ),
              const SizedBox(height: 10),
              if (isSigningAll) const LinearProgressIndicator(),
              const SizedBox(height: 10),
              Expanded(
                child: esignerWeb.pdfFiles.isEmpty
                    ? const Center(
                        child: Text(
                          "No PDF files selected",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: esignerWeb.pdfFiles.length,
                        itemBuilder: (context, index) {
                          final file = esignerWeb.pdfFiles[index];
                          return FileShowingTile(
                            file: file,
                            signingProgress:
                                signingProgress[file.fileName] ?? 0.0,
                            onSignTap: () async {
                              if (!file.isSigned) {
                                if (!mounted) return;
                                setState(
                                    () => signingProgress[file.fileName] = 0.1);
                                bool success = await signPdfWithProgress(file);
                                if (success) {
                                  showSnackbar(
                                      "✅ Signing successful!", Colors.green);
                                } else {
                                  showSnackbar("❌ Signing failed!", Colors.red);
                                }
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                heroTag: "pdf",
                onPressed: isSigningAll ? null : _pickPdfFiles,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Pick PDF"),
                backgroundColor: PRIMARY_COLOR,
              ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                heroTag: "pfx",
                onPressed: isSigningAll ? null : _pickPfxFile,
                icon: const Icon(Icons.security),
                label: const Text("Pick PFX"),
                backgroundColor: SECOUNDARY_COLOR,
              ),
            ],
          ),
        ));
  }
}
