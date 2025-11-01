import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/message_model.dart';
import '../../data/models/user_model.dart';

class IsarService {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MessageModelSchema, UserModelSchema],
      directory: dir.path,
    );
  }
}
