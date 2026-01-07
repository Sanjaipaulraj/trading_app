import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'models/models.dart';

Future<void> createExcelFile(List<DbReportModel> reports) async {
  // print(reports);

  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Sheet1'];

  if (reports.isEmpty) return;

  final headers = reports.first.toMap().keys.toList();

  for (int col = 0; col < headers.length; col++) {
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).value = TextCellValue(headers[col]);
  }

  for (int row = 0; row < reports.length; row++) {
    final values = reports[row].toMap().values.toList();

    for (int col = 0; col < values.length; col++) {
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1)).value = TextCellValue(
        values[col]?.toString() ?? '',
      );
    }
  }
  try {
    // var directory = await getProjectDirectory();
    var directory = await pickSaveDirectory();
    String filePath = '$directory/my_data.xlsx';
    File file = File(filePath);
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
      print('Excel file saved to: $filePath');
    }
  } catch (e) {
    print('Error saving file: $e');
    // Implement permission handling or a proper file picker here
  }
}

Future<Directory> getProjectDirectory() async {
  return Directory(Directory.current.path); // current Project folder path
}

Future<String> pickSaveDirectory() async {
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory != null) {
    print("Selected directory: $selectedDirectory");
    return selectedDirectory;
  } else {
    print("User canceled directory selection.");
    var directory = await getProjectDirectory();
    return directory.path;
  }
}
