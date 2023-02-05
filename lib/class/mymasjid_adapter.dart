import 'package:hive/hive.dart';
import 'package:prayertime/class/hive_masjid.dart';

class HiveMasjidAdapter extends TypeAdapter<HiveMasjid> {
  @override
  final typeId = 1;

  @override
  HiveMasjid read(BinaryReader reader) {
    final map = reader.readMap();
    return HiveMasjid.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, HiveMasjid obj) {
    writer.writeMap(obj.toMap());
  }
}
