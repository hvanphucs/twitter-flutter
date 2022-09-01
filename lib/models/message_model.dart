class MessageModel {
  String? key;
  String? senderId;
  String? message;
  bool? seen;
  String? createdAt;
  String? timeStamp;
  String? senderName;
  String? receiverId;

  MessageModel({
    this.key,
    this.senderId,
    this.message,
    this.seen,
    this.createdAt,
    this.timeStamp,
    this.senderName,
    this.receiverId,
  });

  static fromJson(Map<String, dynamic> map) {
    return MessageModel(
      key: map["key"],
      senderId: map["senderId"],
      message: map["message"],
      seen: map["seen"],
      createdAt: map["createdAt"],
      timeStamp: map['timeStamp'],
    );
  }

  toJson() => {
        "key": key,
        "senderId": senderId,
        "message": message,
        "receiverId": receiverId,
        "seen": seen,
        "createdAt": createdAt,
        "senderName": senderName,
        "timeStamp": timeStamp
      };
}
