enum MessageType { String, Image, Sticker }

class MessageModel {
  String userId;
  String peerId;
  DateTime datetime;
  String _type;
  String content;

  get type {
    if (_type == "String") {
      return MessageType.String;
    } else if (_type == "Image") {
      return MessageType.Image;
    } else if (_type == "Sticker") {
      return MessageType.Sticker;
    }
  }

  set type(MessageType messageType) {
    switch (messageType) {
      case MessageType.String:
        _type = "String";
        break;
      case MessageType.Image:
        _type = "Image";
        break;
      case MessageType.Sticker:
        _type = "Sticker";
    }
  }

  MessageModel.all(this.userId, this.peerId, MessageType messageType,
      this.content, this.datetime) {
    this.type = messageType;
  }

  MessageModel(
      this.userId, this.peerId, MessageType messageType, this.content) {
    this.type = messageType;
    this.datetime = DateTime.now();
  }

  MessageModel.fromJson(Map<String, dynamic> item) {
    this.userId = item['userId'];
    this.peerId = item['peerId'];
    this.datetime = DateTime.parse(item["dateTime"]).toLocal();
    this._type = item['type'];
    this.content = item['content'];
    print(this);
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'peerId': peerId,
        'type': _type,
        'content': content,
        'dateTime': datetime.toUtc().toIso8601String(),
      };

  @override
  String toString() {
    return 'userId:$userId, '
        'peerId:$peerId, '
        'type:$_type, '
        'content:$content, '
        'dateTime:${datetime.toString()}';
  }
}
