class MessageModel {
  String? key;
  String? senderId;
  String? message;
  bool? seen;
  String? createdAt;
  String? timeStamp;
  String? senderName;
  String? receiverId;
  String? fileUrl;
  String? fileType;

  MessageModel({
    this.key,
    this.senderId,
    this.message,
    this.fileUrl,
    this.fileType,
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
      receiverId: map["receiverId"],
      message: map["message"],
      fileUrl: map["fileUrl"],
      fileType: map["fileType"],
      seen: map["seen"],
      createdAt: map["createdAt"],
      timeStamp: map['timeStamp'],
    );
  }

  toJson() => {
        "key": key,
        "senderId": senderId,
        "message": message,
        "fileUrl": fileUrl,
        "fileType": fileType,
        "receiverId": receiverId,
        "seen": seen,
        "createdAt": createdAt,
        "senderName": senderName,
        "timeStamp": timeStamp
      };
}
