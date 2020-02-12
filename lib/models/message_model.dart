enum MessageType { String, Image, Sticker }

class MessageModel{
  String userId;
  String _type;
  String content;

  get type {
    if (_type == "String") {
      return MessageType.String;
    }else if (_type == "Image") {
      return MessageType.Image;
    }else if (_type == "Sticker") {
      return MessageType.Sticker;
    }
  }
}