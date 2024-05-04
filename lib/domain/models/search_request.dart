class SearchPerson {
  SearchPerson({
    this.name,
    this.idNumber,
    this.phoneNumber,
    this.bankAccountNumber,
    this.email,
    this.description,
    this.selectedServices,
  });

  SearchPerson.fromJson(dynamic json) {
    name = json['name'];
    idNumber = json['idNumber'];
    phoneNumber = json['phoneNumber'];
    bankAccountNumber = json['bankAccountNumber'];
    email = json['email'];
    description = json['description'];
    selectedServices = json['selectedServices'];
  }

  String? name;
  String? idNumber;
  String? phoneNumber;
  String? bankAccountNumber;
  String? email;
  String? description;
  List<String>? selectedServices;

  SearchPerson copyWith({
    String? name,
    String? idNumber,
    String? phoneNumber,
    String? bankAccountNumber,
    String? email,
    String? description,
    List<String>? selectedServices,
  }) =>
      SearchPerson(
        name: name ?? this.name,
        idNumber: idNumber ?? this.idNumber,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
        email: email ?? this.email,
        description: description ?? this.description,
        selectedServices: selectedServices ?? this.selectedServices,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['idNumber'] = idNumber;
    map['phoneNumber'] = phoneNumber;
    map['bankAccountNumber'] = bankAccountNumber;
    map['email'] = email;
    map['description'] = description;
    map['selectedServices'] = selectedServices;
    return map;
  }
}
