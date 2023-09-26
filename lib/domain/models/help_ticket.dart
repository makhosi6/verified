class HelpTicket {
  HelpTicket({
    this.id,
    this.profileId,
    this.timestamp,
    this.isResolved,
    this.type,
    this.comment,
    this.preferredCommunicationChannel,
    this.response,
  });

  HelpTicket.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    timestamp = json['timestamp'];
    isResolved = json['isResolved'];
    type = json['type'];
    comment =
    json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    preferredCommunicationChannel = json['preferredCommunicationChannel'];
    if (json['response'] != null) {
      response = [];
      json['response'].forEach((v) {
        response?.add(Comment.fromJson(v));
      });
    }
  }

  num? id;
  num? profileId;
  num? timestamp;
  bool? isResolved;
  String? type;
  Comment? comment;
  String? preferredCommunicationChannel;
  List<Comment>? response;

  HelpTicket copyWith({ num? id,
    num? profileId,
    num? timestamp,
    bool? isResolved,
    String? type,
    Comment? comment,
    String? preferredCommunicationChannel,
    List<Comment>? response,
  }) =>
      HelpTicket(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        timestamp: timestamp ?? this.timestamp,
        isResolved: isResolved ?? this.isResolved,
        type: type ?? this.type,
        comment: comment ?? this.comment,
        preferredCommunicationChannel: preferredCommunicationChannel ??
            this.preferredCommunicationChannel,
        response: response ?? this.response,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['timestamp'] = timestamp;
    map['isResolved'] = isResolved;
    map['type'] = type;
    if (comment != null) {
      map['comment'] = comment?.toJson();
    }
    map['preferredCommunicationChannel'] = preferredCommunicationChannel;
    if (response != null) {
      map['response'] = response?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Comment {
  Comment({
      this.title, 
      this.body,});

  Comment.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
  }
  String? title;
  String? body;
Comment copyWith({  String? title,
  String? body,
}) => Comment(  title: title ?? this.title,
  body: body ?? this.body,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    return map;
  }

}