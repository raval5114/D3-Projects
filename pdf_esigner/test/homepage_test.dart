import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Create an interface for the file picker service
abstract class IFilePickerService {
  Future<FilePickerResult?> pickFile(
      {FileType type, List<String>? allowedExtensions});
}

// FilePickerService that calls FilePicker.platform.pickFiles
class FilePickerService implements IFilePickerService {
  @override
  Future<FilePickerResult?> pickFile(
      {FileType type = FileType.custom, List<String>? allowedExtensions}) {
    return FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );
  }
}

// Homepage widget where we integrate the file picker
class Homepage extends StatefulWidget {
  final IFilePickerService filePickerService;

  const Homepage({super.key, required this.filePickerService});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await widget.filePickerService.pickFile(
      type: FileType.custom, // Ensure type is non-nullable
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pdf e-Signer')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Add Pdf'),
          ),
          if (_selectedFile != null)
            Text('Selected File: ${_selectedFile!.path.split('/').last}'),
        ],
      ),
    );
  }
}

// Mock the IFilePickerService
class MockFilePickerService extends Mock implements IFilePickerService {}

void main() {
  testWidgets('Homepage widget test', (WidgetTester tester) async {
    // Create a mock file picker service
    final mockFilePickerService = MockFilePickerService();

    // Mock the behavior of pickFile to return a FilePickerResult
    when(mockFilePickerService
            .pickFile(type: FileType.custom, allowedExtensions: ['pdf']))
        .thenAnswer((_) async => FilePickerResult([
              PlatformFile(
                  path: '/mockFile.pdf', name: 'mockFile.pdf', size: 123),
            ]));

    // Build the Homepage widget with the mock file picker service
    await tester.pumpWidget(
      MaterialApp(home: Homepage(filePickerService: mockFilePickerService)),
    );

    // Verify that the "Add Pdf" button is present
    expect(find.text('Add Pdf'), findsOneWidget);

    // Simulate a tap on the "Add Pdf" button
    await tester.tap(find.text('Add Pdf'));
    await tester.pump();

    // Check if the file is selected
    expect(find.text('Selected File: mockFile.pdf'), findsOneWidget);
  });
}
