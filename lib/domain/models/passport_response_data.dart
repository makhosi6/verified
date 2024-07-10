
class PassportResponseData {
  String? error;
  List<String>? data;
  String? message;

  PassportResponseData({this.error, this.data, this.message});

  PassportResponseData.fromJson(Map<String, dynamic> json) {
    error = json["error"];
    data = json["data"] == null ? null : List<String>.from(json["data"]);
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["error"] = error;
    if(data != null) {
      _data["data"] = data;
    }
    _data["message"] = message;
    return _data;
  }
}