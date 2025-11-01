import '../entities/message_entity.dart';
import '../../data/repositories/chat_repository_impl.dart';

class SendMessageUseCase {
  final ChatRepositoryImpl repository;

  SendMessageUseCase(this.repository);

  Future<void> call(String roomId, MessageEntity message) async {
    await repository.sendMessage(roomId, message);
  }
}
