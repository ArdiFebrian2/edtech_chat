// TODO Implement this library.
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/models/room_model.dart';

class GetRoomsUseCase {
  final ChatRepositoryImpl repository;
  GetRoomsUseCase(this.repository);

  Stream<List<RoomModel>> call(String uid) {
    return repository.getRooms(uid);
  }
}
