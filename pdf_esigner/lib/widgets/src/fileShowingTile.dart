import 'package:flutter/material.dart';
import 'package:pdf_esigner/config.dart';
import 'package:pdf_esigner/test/repo_testing/pdf_esigner.dart';

class FileShowingTile extends StatelessWidget {
  final PdfFileForFlutter file;
  final double signingProgress;
  final VoidCallback onSignTap;

  const FileShowingTile({
    super.key,
    required this.file,
    required this.signingProgress,
    required this.onSignTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ANIMATION_SPEED,
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
        title: Text(
          file.fileName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: file.isSigned
            ? const Text("✅ Signed Successfully",
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.w500))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: signingProgress,
                    backgroundColor: Colors.grey[300],
                    color: PRIMARY_COLOR,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(signingProgress * 100).toInt()}% completed",
                    style: TextStyle(
                        color: Colors.blueGrey.shade700, fontSize: 12),
                  ),
                ],
              ),
        trailing: file.isSigned
            ? IconButton(
                icon: const Icon(Icons.download, color: Colors.green),
                onPressed: () => esignerWeb.downloadFile(file, file.fileName),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: esignerWeb.pfxFile != null
                    ? onSignTap
                    : null, // Disable if no PFX
                child: const Text("Sign"),
              ),
      ),
    );
  }
}
