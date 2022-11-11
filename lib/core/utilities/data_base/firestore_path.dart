class FirestorePath {
  static String research(String researchId) => 'researchs/$researchId';
  // static String enrolledTo(String researchId) => 'enrolledTo/$researchId';

  static String researcher(String uid) => 'researchers/$uid';
  static String researchers(String researchId) => 'researchers';

  static String participant(String uid) => 'participants/$uid';
  static String participants() => 'participants';

  static String chat(String chatId) => 'chats/$chatId';
  static String chats() => 'chats';

  static String messages(String chatId) => 'chats/$chatId/messages';

  static String message(String chatId, String messageId) =>
      'chats/$chatId/messages/$messageId';

  static String answers(String uid) => 'participants/$uid/answers';

  static String tokens(String collectionName, String uid) =>
      '$collectionName/tokens/$uid';

  static String feedbacks() => 'feedbacks';
}
