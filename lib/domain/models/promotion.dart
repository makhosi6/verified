class Promotion {
  Promotion({
    this.id,
    this.name,
    this.displayText,
    this.credit,
    this.isActive,
    this.picture,
    this.promotionInfo,
    this.trigger,
  });

  Promotion.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    displayText = json['displayText'];
    credit = json['credit'];
    isActive = json['isActive'];
    picture = json['picture'];
    promotionInfo = json['promotionInfo'];
    if (json['trigger'] != null) {
      trigger = [];
      json['trigger'].forEach((v) {
        trigger?.add(v);
      });
    }
  }
  String? id;
  String? name;
  String? displayText;
  num? credit;
  bool? isActive;
  String? picture;
  String? promotionInfo;
  List<dynamic>? trigger;
  Promotion copyWith({
    String? id,
    String? name,
    String? displayText,
    num? credit,
    bool? isActive,
    String? picture,
    String? promotionInfo,
    List<String>? trigger,
  }) =>
      Promotion(
        id: id ?? this.id,
        name: name ?? this.name,
        displayText: displayText ?? this.displayText,
        credit: credit ?? this.credit,
        isActive: isActive ?? this.isActive,
        picture: picture ?? this.picture,
        promotionInfo: promotionInfo ?? this.promotionInfo,
        trigger: trigger ?? this.trigger,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['displayText'] = displayText;
    map['credit'] = credit;
    map['isActive'] = isActive;
    map['picture'] = picture;
    map['promotionInfo'] = promotionInfo;
    if (trigger != null) {
      map['trigger'] = trigger?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
