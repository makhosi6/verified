class HelpTicket {
  HelpTicket({
    this.id,
    this.profileId,
    this.timestamp,
    this.isResolved,
    this.type,
    this.comment,
    this.uploads,
    this.preferredCommunicationChannel,
    this.responses,
  });

  HelpTicket.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    timestamp = json['timestamp'];
    isResolved = json['isResolved'];
    type = json['type'];
    uploads = json['uploads'];
    comment = json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    preferredCommunicationChannel = json['preferredCommunicationChannel'];
    if (json['responses'] != null) {
      responses = [];
      json['responses'].forEach((v) {
        responses?.add(Comment.fromJson(v));
      });
    }
  }

  String? id;
  String? profileId;
  num? timestamp;
  bool? isResolved;
  String? type;
  List<Upload>? uploads;
  Comment? comment;
  String? preferredCommunicationChannel;
  List<Comment>? responses;

  HelpTicket copyWith({
    String? id,
    String? profileId,
    num? timestamp,
    bool? isResolved,
    String? type,
    List<Upload>? uploads,
    Comment? comment,
    String? preferredCommunicationChannel,
    List<Comment>? responses,
  }) =>
      HelpTicket(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        timestamp: timestamp ?? this.timestamp,
        isResolved: isResolved ?? this.isResolved,
        type: type ?? this.type,
        uploads: uploads ?? this.uploads,
        comment: comment ?? this.comment,
        preferredCommunicationChannel: preferredCommunicationChannel ?? this.preferredCommunicationChannel,
        responses: responses ?? this.responses,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['timestamp'] = timestamp;
    map['isResolved'] = isResolved;
    map['type'] = type;
    map['uploads'] = uploads;
    if (comment != null) {
      map['comment'] = comment?.toJson();
    }
    map['preferredCommunicationChannel'] = preferredCommunicationChannel;
    if (responses != null) {
      map['responses'] = responses?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comment {
  Comment({
    this.title,
    this.body,
    this.upload,
  });

  Comment.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'];
    upload = json['upload'];
  }
  String? title;
  String? body;
  Upload? upload;
  Comment copyWith({
    String? title,
    String? body,
    Upload? upload,
  }) =>
      Comment(
        title: title ?? this.title,
        body: body ?? this.body,
        upload: upload ?? this.upload,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['body'] = body;
    map['upload'] = upload;
    return map;
  }
}

class Upload {
  Upload({
    this.filename,
    this.size,
    this.mimetype,
  });

  Upload.fromJson(dynamic json) {
    filename = json['filename'];
    size = json['size'];
    mimetype = json['mimetype'];
  }
  String? filename;
  num? size;
  String? mimetype;
  Upload copyWith({
    String? filename,
    num? size,
    String? mimetype,
  }) =>
      Upload(
        filename: filename ?? this.filename,
        size: size ?? this.size,
        mimetype: mimetype ?? this.mimetype,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['filename'] = filename;
    map['size'] = size;
    map['mimetype'] = mimetype;
    return map;
  }
}
