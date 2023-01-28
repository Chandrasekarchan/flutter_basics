import 'package:isar/isar.dart';
part 'qr_model.g.dart';
@collection
class QrModel{
  Id? id;
  String data;
  String type;
  String formatName;
  List<int> bytes;
  QrModel(this.data,this.formatName,this.bytes,this.type);
}