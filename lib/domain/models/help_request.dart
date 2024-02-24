// class HelpRequest {
//   HelpRequest({
//     this.profileId,
//     this.timestamp,
//     this.type,
//     this.comment,
//     this.preferredCommunicationChannel,
//   });

//   HelpRequest.fromJson(dynamic json) {
//     profileId = json['profileId'];
//     timestamp = json['timestamp'];
//     type = json['type'];
//     comment = json['comment'] != null ? Comment.fromJson(json['comment']) : null;
//     preferredCommunicationChannel = json['preferredCommunicationChannel'];
//   }
//   String? profileId;
//   num? timestamp;
//   String? type;
//   Comment? comment;
//   String? preferredCommunicationChannel;
//   HelpRequest copyWith({
//     String? profileId,
//     num? timestamp,
//     String? type,
//     Comment? comment,
//     String? preferredCommunicationChannel,
//   }) =>
//       HelpRequest(
//         profileId: profileId ?? this.profileId,
//         timestamp: timestamp ?? this.timestamp,
//         type: type ?? this.type,
//         comment: comment ?? this.comment,
//         preferredCommunicationChannel: preferredCommunicationChannel ?? this.preferredCommunicationChannel,
//       );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['profileId'] = profileId;
//     map['timestamp'] = timestamp;
//     map['type'] = type;
//     if (comment != null) {
//       map['comment'] = comment?.toJson();
//     }
//     map['preferredCommunicationChannel'] = preferredCommunicationChannel;
//     return map;
//   }
// }

// class Comment {
//   Comment({
//     this.title,
//     this.body,
//   });

//   Comment.fromJson(dynamic json) {
//     title = json['title'];
//     body = json['body'];
//   }
//   String? title;
//   String? body;
//   Comment copyWith({
//     String? title,
//     String? body,
//   }) =>
//       Comment(
//         title: title ?? this.title,
//         body: body ?? this.body,
//       );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['title'] = title;
//     map['body'] = body;
//     return map;
//   }
// }
