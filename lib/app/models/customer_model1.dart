class Customer {
  int? id;
  String? createTime;
  String? updateTime;
  String? firstName;
  dynamic yardID;
  dynamic surname;
  String? emailAddress;
  String? phoneNumber;
  String? secNumber;
  String? address;
  String? licence;
  String? departmentId;
  bool? isDel;
  String? abn;
  String? workLocation;
  List<void>? car;

  Customer(
      {this.id,
      this.createTime,
      this.updateTime,
      this.firstName,
      this.yardID,
      this.surname,
      this.emailAddress,
      this.phoneNumber,
      this.secNumber,
      this.address,
      this.licence,
      this.departmentId,
      this.isDel,
      this.abn,
      this.workLocation,
      this.car});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    firstName = json['firstName'];
    yardID = json['yardID'];
    surname = json['surname'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    secNumber = json['secNumber'];
    address = json['address'];
    licence = json['licence'];
    departmentId = json['departmentId'];
    isDel = json['isDel'];
    abn = json['abn'];
    workLocation = json['workLocation'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['firstName'] = firstName;
    data['yardID'] = yardID;
    data['surname'] = surname;
    data['emailAddress'] = emailAddress;
    data['phoneNumber'] = phoneNumber;
    data['secNumber'] = secNumber;
    data['address'] = address;
    data['licence'] = licence;
    data['departmentId'] = departmentId;
    data['isDel'] = isDel;
    data['abn'] = abn;
    data['workLocation'] = workLocation;
    return data;
  }
}
