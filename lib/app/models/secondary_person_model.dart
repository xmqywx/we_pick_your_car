class SecondaryPerson {
  int? id;
  String? createTime;
  String? updateTime;
  String? personName;
  String? surname;
  String? personPhone;
  String? personEmail;
  String? personLicense;
  String? personABN;
  String? personAddress;
  String? personLocation;
  String? customerAt;
  dynamic personRelation;
  String? personSecNumber;
  dynamic licenseClass;
  dynamic cardNumber;
  dynamic dateOfBirth;
  dynamic expiryDate;
  dynamic backCardNumber;

  SecondaryPerson(
      {this.id,
      this.createTime,
      this.updateTime,
      this.personName,
      this.surname,
      this.personPhone,
      this.personEmail,
      this.personLicense,
      this.personABN,
      this.personAddress,
      this.personLocation,
      this.customerAt,
      this.personRelation,
      this.personSecNumber,
      this.licenseClass,
      this.cardNumber,
      this.dateOfBirth,
      this.expiryDate,
      this.backCardNumber});

  SecondaryPerson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    personName = json['personName'];
    surname = json['surname'];
    personPhone = json['personPhone'];
    personEmail = json['personEmail'];
    personLicense = json['personLicense'];
    personABN = json['personABN'];
    personAddress = json['personAddress'];
    personLocation = json['personLocation'];
    customerAt = json['customerAt'];
    personRelation = json['personRelation'];
    personSecNumber = json['personSecNumber'];
    licenseClass = json['licenseClass'];
    cardNumber = json['cardNumber'];
    dateOfBirth = json['dateOfBirth'];
    expiryDate = json['expiryDate'];
    backCardNumber = json['backCardNumber'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['personName'] = personName;
    data['surname'] = surname;
    data['personPhone'] = personPhone;
    data['personEmail'] = personEmail;
    data['personLicense'] = personLicense;
    data['personABN'] = personABN;
    data['personAddress'] = personAddress;
    data['personLocation'] = personLocation;
    data['customerAt'] = customerAt;
    data['personRelation'] = personRelation;
    data['personSecNumber'] = personSecNumber;
    data['licenseClass'] = licenseClass;
    data['cardNumber'] = cardNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['expiryDate'] = expiryDate;
    data['backCardNumber'] = backCardNumber;
    return data;
  }
}
