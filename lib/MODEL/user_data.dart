class UserDataModel {
  bool? status;
  String? message;
  List<Data>? data;

  UserDataModel({this.status, this.message, this.data});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? userName;
  String? profilePicture;
  List<Stories>? stories;

  Data({this.userId, this.userName, this.profilePicture, this.stories});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    profilePicture = json['profile_picture'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['profile_picture'] = this.profilePicture;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  int? storyId;
  String? mediaUrl;
  String? mediaType;
  String? timestamp;
  String? text;
  String? textDescription;

  Stories(
      {this.storyId,
        this.mediaUrl,
        this.mediaType,
        this.timestamp,
        this.text,
        this.textDescription});

  Stories.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    timestamp = json['timestamp'];
    text = json['text'];
    textDescription = json['text_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['story_id'] = this.storyId;
    data['media_url'] = this.mediaUrl;
    data['media_type'] = this.mediaType;
    data['timestamp'] = this.timestamp;
    data['text'] = this.text;
    data['text_description'] = this.textDescription;
    return data;
  }
}
