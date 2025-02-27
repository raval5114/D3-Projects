// import 'package:flutter/material.dart';
// import 'package:pdf_esigner/test/repo_testing/pdf_esigner.dart';


// class MainTestingHomepage extends StatefulWidget {
//   const MainTestingHomepage({super.key});

//   @override
//   State<MainTestingHomepage> createState() => _MainTestingHomepageState();
// }

// class _MainTestingHomepageState extends State<MainTestingHomepage> {
//   String? pfxFileName;
//   Map<String, double> signingProgress = {};

//   void _pickPdfFiles() async {
//     await esignerWeb.pickFiles("pdf");
//     setState(() {});
//   }

//   void _pickPfxFile() async {
//     await esignerWeb.pickFiles("pfx");
//     setState(() {
//       pfxFileName = esignerWeb.pfxFile != null ? "✅ PFX File Selected" : null;
//     });
//   }

//   void showSnackbar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: const TextStyle(color: Colors.white)),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<bool> signPdfWithProgress(PdfFileForFlutter file) async {
//     for (double progress = 0.2; progress <= 1.0; progress += 0.2) {
//       await Future.delayed(const Duration(milliseconds: 400));
//       setState(() => signingProgress[file.fileName] = progress);
//     }
//     return await esignerWeb.signByPfx(file, '1234567890');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PDF Signer"),
//         backgroundColor: PRIMARY_COLOR,
//         centerTitle: true,
//         elevation: 4,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Column(
//           children: [
//             AnimatedOpacity(
//               opacity: pfxFileName != null ? 1.0 : 0.0,
//               duration: ANIMATION_SPEED,
//               child: PfxAcknowledgment(pfxFileName: pfxFileName),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: esignerWeb.pdfFiles.isEmpty
//                   ? const Center(
//                       child: Text(
//                         "No PDF files selected",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding:
//                           const EdgeInsets.only(bottom: 80), // 👈 Added Padding
//                       itemCount: esignerWeb.pdfFiles.length,
//                       itemBuilder: (context, index) {
//                         final file = esignerWeb.pdfFiles[index];
//                         return FileShowingTile(
//                           file: file,
//                           signingProgress:
//                               signingProgress[file.fileName] ?? 0.0,
//                           onSignTap: () async {
//                             if (!file.isSigned) {
//                               setState(
//                                   () => signingProgress[file.fileName] = 0.1);
//                               bool success = await signPdfWithProgress(file);
//                               if (success) {
//                                 showSnackbar(
//                                     "✅ Signing successful!", Colors.green);
//                               } else {
//                                 showSnackbar("❌ Signing failed!", Colors.red);
//                               }
//                             }
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 20),
// 👈 Moves FAB up
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FloatingActionButton.extended(
//               heroTag: "pdf",
//               onPressed: _pickPdfFiles,
//               icon: const Icon(Icons.picture_as_pdf),
//               label: const Text("Pick PDF"),
//               backgroundColor: PRIMARY_COLOR,
//             ),
//             const SizedBox(height: 10),
//             FloatingActionButton.extended(
//               heroTag: "pfx",
//               onPressed: _pickPfxFile,
//               icon: const Icon(Icons.security),
//               label: const Text("Pick PFX"),
//               backgroundColor: SECONDARY_COLOR,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

