class Component {
  int? id;
  String? createTime;
  String? updateTime;
  int? carID;
  String? disassmblingInformation;
  String? disassemblyDescription;
  String? disassemblyImages;
  String? disassemblyNumber;
  int? containerID;
  dynamic description;
  String? color;
  dynamic complete;
  dynamic turnsOver;
  dynamic missingParts;
  int? status;
  int? containerStatus;
  String? containerNumber;
  String? vin;
  String? registrationNumber;
  int? year;
  String? make;
  String? model;
  String? series;
  String? fuel;
  String? transmission;
  int? cylinders;
  String? engineNumber;
  String? engineCode;

  Component(
      {this.id,
      this.createTime,
      this.updateTime,
      this.carID,
      this.disassmblingInformation,
      this.disassemblyDescription,
      this.disassemblyImages,
      this.disassemblyNumber,
      this.containerID,
      this.description,
      this.color,
      this.complete,
      this.turnsOver,
      this.missingParts,
      this.status,
      this.containerStatus,
      this.containerNumber,
      this.vin,
      this.registrationNumber,
      this.year,
      this.make,
      this.model,
      this.series,
      this.fuel,
      this.transmission,
      this.cylinders,
      this.engineNumber,
      this.engineCode});

  Component.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    carID = json['carID'];
    disassmblingInformation = json['disassmblingInformation'];
    disassemblyDescription = json['disassemblyDescription'];
    disassemblyImages = json['disassemblyImages'];
    disassemblyNumber = json['disassemblyNumber'];
    containerID = json['containerID'];
    description = json['description'];
    color = json['color'];
    complete = json['complete'];
    turnsOver = json['turnsOver'];
    missingParts = json['missingParts'];
    status = json['status'];
    containerStatus = json['containerStatus'];
    containerNumber = json['containerNumber'];
    vin = json['vin'];
    registrationNumber = json['registrationNumber'];
    year = json['year'];
    make = json['make'];
    model = json['model'];
    series = json['series'];
    fuel = json['fuel'];
    transmission = json['transmission'];
    cylinders = json['cylinders'];
    engineNumber = json['engineNumber'];
    engineCode = json['engineCode'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['carID'] = carID;
    data['disassmblingInformation'] = disassmblingInformation;
    data['disassemblyDescription'] = disassemblyDescription;
    data['disassemblyImages'] = disassemblyImages;
    data['disassemblyNumber'] = disassemblyNumber;
    data['containerID'] = containerID;
    data['description'] = description;
    data['color'] = color;
    data['complete'] = complete;
    data['turnsOver'] = turnsOver;
    data['missingParts'] = missingParts;
    data['status'] = status;
    data['containerStatus'] = containerStatus;
    data['containerNumber'] = containerNumber;
    data['vin'] = vin;
    data['registrationNumber'] = registrationNumber;
    data['year'] = year;
    data['make'] = make;
    data['model'] = model;
    data['series'] = series;
    data['fuel'] = fuel;
    data['transmission'] = transmission;
    data['cylinders'] = cylinders;
    data['engineNumber'] = engineNumber;
    data['engineCode'] = engineCode;
    return data;
  }
}
