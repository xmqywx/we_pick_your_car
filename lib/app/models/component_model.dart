class Component {
  int? id;
  String? createTime;
  String? updateTime;
  int? carID;
  dynamic disassemblyDescription;
  String? disassemblyCategory;
  String? disassemblyNumber;
  dynamic disassemblyImages;
  String? disassmblingInformation;
  dynamic catalyticConverterName;
  dynamic catalyticConverterNumber;
  String? containerNumber;
  dynamic description;
  int? containerStatus;

  Component(
      {this.id,
      this.createTime,
      this.updateTime,
      this.carID,
      this.disassemblyDescription,
      this.disassemblyCategory,
      this.disassemblyNumber,
      this.disassemblyImages,
      this.disassmblingInformation,
      this.catalyticConverterName,
      this.catalyticConverterNumber,
      this.containerNumber,
      this.description,
      this.containerStatus});

  Component.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    carID = json['carID'];
    disassemblyDescription = json['disassemblyDescription'];
    disassemblyCategory = json['disassemblyCategory'];
    disassemblyNumber = json['disassemblyNumber'];
    disassemblyImages = json['disassemblyImages'];
    disassmblingInformation = json['disassmblingInformation'];
    catalyticConverterName = json['catalyticConverterName'];
    catalyticConverterNumber = json['catalyticConverterNumber'];
    containerNumber = json['containerNumber'];
    description = json['description'];
    containerStatus = json['containerStatus'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['carID'] = carID;
    data['disassemblyDescription'] = disassemblyDescription;
    data['disassemblyCategory'] = disassemblyCategory;
    data['disassemblyNumber'] = disassemblyNumber;
    data['disassemblyImages'] = disassemblyImages;
    data['disassmblingInformation'] = disassmblingInformation;
    data['catalyticConverterName'] = catalyticConverterName;
    data['catalyticConverterNumber'] = catalyticConverterNumber;
    data['containerNumber'] = containerNumber;
    data['description'] = description;
    data['containerStatus'] = containerStatus;
    return data;
  }
}
