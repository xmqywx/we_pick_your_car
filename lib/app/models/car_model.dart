class Car {
  int? id;
  String? createTime;
  String? updateTime;
  int? customerID;
  dynamic yardID;
  String? name;
  int? year;
  String? brand;
  String? model;
  String? colour;
  String? image;
  String? vinNumber;
  String? series;
  String? registrationNumber;
  String? state;
  String? bodyStyle;
  String? engine;
  dynamic doors;
  dynamic seats;
  dynamic fuelType;
  dynamic engineSizeCc;
  dynamic cylinders;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic tareWeight;
  String? carInfo;
  int? status;
  dynamic platesReturned;
  dynamic registered;
  dynamic identificationSighted;
  String? departmentId;
  dynamic carWreckedInfo;
  bool? isVFP;

  Car(
      {this.id,
      this.createTime,
      this.updateTime,
      this.customerID,
      this.yardID,
      this.name,
      this.year,
      this.brand,
      this.model,
      this.colour,
      this.image,
      this.vinNumber,
      this.series,
      this.registrationNumber,
      this.state,
      this.bodyStyle,
      this.engine,
      this.doors,
      this.seats,
      this.fuelType,
      this.engineSizeCc,
      this.cylinders,
      this.length,
      this.width,
      this.height,
      this.tareWeight,
      this.carInfo,
      this.status,
      this.platesReturned,
      this.registered,
      this.identificationSighted,
      this.departmentId,
      this.carWreckedInfo,
      this.isVFP});

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    customerID = json['customerID'];
    yardID = json['yardID'];
    name = json['name'];
    year = json['year'];
    brand = json['brand'];
    model = json['model'];
    colour = json['colour'];
    image = json['image'];
    vinNumber = json['vinNumber'];
    series = json['series'];
    registrationNumber = json['registrationNumber'];
    state = json['state'];
    bodyStyle = json['bodyStyle'];
    engine = json['engine'];
    doors = json['doors'];
    seats = json['seats'];
    fuelType = json['fuelType'];
    engineSizeCc = json['engineSizeCc'];
    cylinders = json['cylinders'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    tareWeight = json['tareWeight'];
    carInfo = json['carInfo'];
    status = json['status'];
    platesReturned = json['platesReturned'];
    registered = json['registered'];
    identificationSighted = json['identificationSighted'];
    departmentId = json['departmentId'];
    carWreckedInfo = json['CarWreckedInfo'];
    isVFP = json['isVFP'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['customerID'] = customerID;
    data['yardID'] = yardID;
    data['name'] = name;
    data['year'] = year;
    data['brand'] = brand;
    data['model'] = model;
    data['colour'] = colour;
    data['image'] = image;
    data['vinNumber'] = vinNumber;
    data['series'] = series;
    data['registrationNumber'] = registrationNumber;
    data['state'] = state;
    data['bodyStyle'] = bodyStyle;
    data['engine'] = engine;
    data['doors'] = doors;
    data['seats'] = seats;
    data['fuelType'] = fuelType;
    data['engineSizeCc'] = engineSizeCc;
    data['cylinders'] = cylinders;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['tareWeight'] = tareWeight;
    data['carInfo'] = carInfo;
    data['status'] = status;
    data['platesReturned'] = platesReturned;
    data['registered'] = registered;
    data['identificationSighted'] = identificationSighted;
    data['departmentId'] = departmentId;
    data['CarWreckedInfo'] = carWreckedInfo;
    data['isVFP'] = isVFP;
    return data;
  }
}
