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
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['nickName'] = nickName;
    _data['headImg'] = headImg;
    _data['email'] = email;
    _data['remark'] = remark;
    _data['status'] = status;
    _data['createTime'] = createTime;
    _data['updateTime'] = updateTime;
    _data['username'] = username;
    _data['phone'] = phone;
    _data['roleName'] = roleName;
    _data['roleId'] = roleId;
    _data['roleLabel'] = roleLabel;
    _data['departmentName'] = departmentName;
    _data['departmentId'] = departmentId;
    return _data;
  }
}
