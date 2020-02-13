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

  set type(MessageType messageType){
    switch(messageType){
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

  MessageModel(this.userId, MessageType messageType, this.content){
    this.type = messageType;
  }

  MessageModel.fromJson(Map<String, dynamic> item){
    this.userId = item['userId'];
    this._type = item['type'];
    this.content = item['content'];
  }


  Map<String, dynamic> toJson() =>{
    'userId':userId,
    'type':_type,
    'content':content,
  };
}