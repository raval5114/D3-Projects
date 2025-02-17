import 'package:flutter/material.dart';
import 'package:pdf_esigner/test/repo_testing/pdf_esigner.dart';

class MainTestingHomepage extends StatefulWidget {
  const MainTestingHomepage({super.key});

  @override
  State<MainTestingHomepage> createState() => _MainTestingHomepageState();
}

class _MainTestingHomepageState extends State<MainTestingHomepage> {
  String? pfxFileName;

  void _pickPdfFiles() async {
    await esignerTest.pickFiles("pdf");
    setState(() {}); // Refresh UI after picking PDF files
  }

  void _pickPfxFile() async {
    await esignerTest.pickFiles("pfx");

    // Assuming pfxFile is updated in the `pickFiles` function
    if (esignerTest.pfxFile!.isNotEmpty) {
      setState(() {
        pfxFileName = "Selected PFX file";
      });
    } else {
      setState(() {
        pfxFileName = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Main Testing Homepage",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: _pickPdfFiles,
                    child: const Text(
                      "Pick PDF file",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _pickPfxFile,
                    child: const Text(
                      "Pick PFX file",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            PfxAcknowledgment(
                pfxFileName: pfxFileName), // Acknowledgment widget
            const SizedBox(height: 20),
            Expanded(child: FileShowingComponent()), // Takes up remaining space
          ],
        ),
      ),
    );
  }
}

class PfxAcknowledgment extends StatelessWidget {
  final String? pfxFileName;

  const PfxAcknowledgment({super.key, this.pfxFileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:
            pfxFileName != null ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            pfxFileName != null ? Icons.check_circle : Icons.warning,
            color: pfxFileName != null ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pfxFileName ?? "No PFX file selected.",
              style: TextStyle(
                color: pfxFileName != null
                    ? Colors.green.shade800
                    : Colors.red.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FileShowingComponent extends StatefulWidget {
  const FileShowingComponent({super.key});

  @override
  State<FileShowingComponent> createState() => _FileShowingComponentState();
}

class _FileShowingComponentState extends State<FileShowingComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: esignerTest.pdfFiles.length,
      itemBuilder: (context, index) {
        final file = esignerTest.pdfFiles[index];
        return FileShowingTile(
          fileName: file.fileName,
          fileSize: "${(file.fileSize / 1024).toStringAsFixed(2)} KB",
          isSigned: file.isSigned,
          onSignTap: () {
            if (!file.isSigned) {
              // Trigger the signing process
              esignerTest.signPdf(file);
              setState(() {
                file.isSigned = true; // Mark as signed
              });
            }
          },
        );
      },
    );
  }
}

class FileShowingTile extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final bool isSigned;
  final VoidCallback onSignTap;

  const FileShowingTile({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.isSigned,
    required this.onSignTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
        title: Text(fileName, overflow: TextOverflow.ellipsis),
        subtitle: Text("Size: $fileSize"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onSignTap, // Trigger sign action on tap
              child: Text(
                isSigned ? "Signed" : "Unsigned",
                style: TextStyle(
                  color: isSigned ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.download, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}
