class UserModel {
  int? id;
  String? name;
  String? nickName;
  String? headImg;
  String? email;
  String? remark;
  int? status;
  String? createTime;
  String? updateTime;
  String? username;
  String? phone;
  String? roleName;
  String? roleId;
  String? roleLabel;
  String? departmentName;
  String? departmentId;

  UserModel({
    this.id,
    this.name,
    this.nickName,
    this.headImg,
    this.email,
    this.remark,
    this.status,
    this.createTime,
    this.updateTime,
    this.username,
    this.phone,
    this.roleName,
    this.roleId,
    this.roleLabel,
    this.departmentName,
    this.departmentId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickName = json['nickName'];
    headImg = json['headImg'];
    email = json['email'];
    remark = json['remark'];
    status = json['status'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    username = json['username'];
    phone = json['phone'];
    roleName = json['roleName'];
    roleId = json['roleId'];
    roleLabel = json['roleLabel'];
    departmentName = json['departmentName'];
    departmentId = json['departmentId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nickName'] = nickName;
    data['headImg'] = headImg;
    data['email'] = email;
    data['remark'] = remark;
    data['status'] = status;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['username'] = username;
    data['phone'] = phone;
    data['roleName'] = roleName;
    data['roleId'] = roleId;
    data['roleLabel'] = roleLabel;
    data['departmentName'] = departmentName;
    data['departmentId'] = departmentId;
    return data;
  }
}
