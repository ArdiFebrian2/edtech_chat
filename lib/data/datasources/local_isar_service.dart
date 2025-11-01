import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/message_entity.dart';

class LocalIsarService {
  static Isar? _isar;

  static Future<void> init() async {
    if (_isar != null && _isar!.isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [MessageModelSchema],
      directory: dir.path,
      inspector: true,
    );
  }

  static Isar get isar {
    if (_isar == null) {
      throw Exception('Isar not initialized. Call LocalIsarService.init() first.');
    }
    return _isar!;
  }

  Future<void> cacheMessages(List<MessageEntity> entities) async {
    final models = entities.map((e) => MessageModel.fromEntity(e)).toList();

    await isar.writeTxn(() async {
      await isar.messageModels.putAll(models);
    });
  }

  Future<List<MessageEntity>> getCachedMessages(String roomId) async {
    final results = await isar.messageModels
        .filter()
        .roomIdEqualTo(roomId)
        .sortByCreatedAtDesc()
        .limit(20)
        .findAll();

    return results.map((m) => m.toEntity()).toList();
  }

  Future<void> clearCache() async {
    await isar.writeTxn(() async {
      await isar.messageModels.clear();
    });
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
