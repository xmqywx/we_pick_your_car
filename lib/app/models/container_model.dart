class ContainerModel {
  int? id;
  String? createTime;
  String? updateTime;
  String? containerNumber;
  String? sealNumber;
  String? startDeliverTime;
  int? status;
  String? sealDate;
  String? photo;
  String? departmentId;

  ContainerModel({
    this.id,
    this.createTime,
    this.updateTime,
    this.containerNumber,
    this.sealNumber,
    this.startDeliverTime,
    this.status,
    this.sealDate,
    this.photo,
    this.departmentId,
  });

  ContainerModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    containerNumber = json['containerNumber'];
    sealNumber = json['sealNumber'];
    startDeliverTime = json['startDeliverTime'];
    status = json['status'];
    sealDate = json['sealDate'];
    photo = json['photo'];
    departmentId = json['departmentId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['containerNumber'] = containerNumber;
    data['sealNumber'] = sealNumber;
    data['startDeliverTime'] = startDeliverTime;
    data['status'] = status;
    data['sealDate'] = sealDate;
    data['photo'] = photo;
    data['departmentId'] = departmentId;
    return data;
  }
}
