import 'package:edtech_chat/data/datasources/firestore_chat_service.dart';
import '../models/room_model.dart';
import '../../domain/entities/message_entity.dart';

class ChatRepositoryImpl {
  final FirebaseChatService remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  Stream<List<RoomModel>> getRooms(String uid) => remoteDataSource.getRooms(uid);

  Stream<List<MessageEntity>> listenMessages(String roomId) =>
      remoteDataSource.listenMessages(roomId);

  Future<void> sendMessage(String roomId, MessageEntity message) async {
    await remoteDataSource.sendMessage(roomId, message);
  }
}
