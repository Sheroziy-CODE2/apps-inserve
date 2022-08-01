import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';

class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  bill({
    required context,
    required String pathImage,
  }) async {
    //TableItemsProvidor tableItemsProvidor = Provider.of<TableItemsProvidor>(context, listen: false);
   // await tableItemsProvidor.loadAllProduct(tableName: "117");
    var now = DateTime.now();
    var formatter = DateFormat('hh:mm dd-MM-yyyy');
    String formattedDate = formatter.format(now);

    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

//     var response = await http.get("IMAGE_URL");
//     Uint8List bytes = response.bodyBytes;
    bluetooth.isConnected.then((isConnected) {
      if (isConnected ?? false) {
        bluetooth.printCustom("INSPARY", 2, 1);
        bluetooth.printImage(pathImage);
        bluetooth.printNewLine();
        bluetooth.printCustom("Rechnung/Bon-Nr:13", 0, 2);
        bluetooth.printCustom(formattedDate, 0, 2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("... Test ...", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("--------------------------------", 1, 0);
        bluetooth.printLeftRight("SUMME", "232,20", 3);
        bluetooth.printCustom("--------------------------------", 1, 0);
        bluetooth.printQRcode("https://www.inspery.com/", 150, 150, 1);

//      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//         bluetooth.printLeftRight("LEFT", "RIGHT", 0);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
//         bluetooth.printNewLine();
//         bluetooth.printLeftRight("LEFT", "RIGHT", 2);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 3);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 4);
//         bluetooth.printNewLine();
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1);
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1,
//             format: "%-10s %10s %10s %n");
//         bluetooth.printNewLine();
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
//             format: "%-8s %7s %7s %7s %n");
//         bluetooth.printNewLine();
//         String testString = " čĆžŽšŠ-H-ščđ";
//         bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
//         bluetooth.printLeftRight("Številka:", "18000001", 1,
//             charset: "windows-1250");
//         bluetooth.printCustom("Body left", 1, 0);
//         bluetooth.printCustom("Body right", 0, 2);
//         bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }
}
