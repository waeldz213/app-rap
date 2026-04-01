// Stub — Firebase Messaging désactivé pour les tests mock
class NotificationService {
  Future<void> initialize() async {}
  Future<void> requestPermission() async {}
  Future<String?> getToken() async => null;
  Future<void> subscribeToTopic(String topic) async {}
  Future<void> unsubscribeFromTopic(String topic) async {}
}
