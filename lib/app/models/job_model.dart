class Job {
  int? id;
  String? createTime;
  String? updateTime;
  int? orderID;
  int? driverID;
  dynamic yardID;
  int? status;
  String? schedulerStart;
  String? schedulerEnd;
  dynamic start;
  dynamic end;
  bool? isAccept;
  dynamic note;
  String? color;
  String? departmentId;

  Job(
      {this.id,
      this.createTime,
      this.updateTime,
      this.orderID,
      this.driverID,
      this.yardID,
      this.status,
      this.schedulerStart,
      this.schedulerEnd,
      this.start,
      this.end,
      this.isAccept,
      this.note,
      this.color,
      this.departmentId});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    orderID = json['orderID'];
    driverID = json['driverID'];
    yardID = json['yardID'];
    status = json['status'];
    schedulerStart = json['schedulerStart'];
    schedulerEnd = json['schedulerEnd'];
    start = json['start'];
    end = json['end'];
    isAccept = json['isAccept'];
    note = json['note'];
    color = json['color'];
    departmentId = json['departmentId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['orderID'] = orderID;
    data['driverID'] = driverID;
    data['yardID'] = yardID;
    data['status'] = status;
    data['schedulerStart'] = schedulerStart;
    data['schedulerEnd'] = schedulerEnd;
    data['start'] = start;
    data['end'] = end;
    data['isAccept'] = isAccept;
    data['note'] = note;
    data['color'] = color;
    data['departmentId'] = departmentId;
    return data;
  }
}
