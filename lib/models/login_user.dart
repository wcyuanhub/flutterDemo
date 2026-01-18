import 'package:flutter_project/utils/json_util.dart';

class LoginUser {
  int? id;
  String? userName;
  String? userAvatar;
  String? userProfile;
  String? userAccount;
  String? userRole;
  DateTime? createTime;
  DateTime? updateTime;

  /// 全参构造函数
  LoginUser({
    this.id,
    this.userName,
    this.userAvatar,
    this.userProfile,
    this.userAccount,
    this.userRole,
    this.createTime,
    this.updateTime,
  });

  /// 从JSON Map创建LoginUser实例
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] as int?,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      userProfile: json['userProfile'] as String?,
      userAccount: json['userAccount'] as String?,
      userRole: json['userRole'] as String?,
      createTime: json['createTime'] != null
          ? DateTime.parse(json['createTime'] as String)
          : null,
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'] as String)
          : null,
    );
  }

  /// 从JSON字符串创建LoginUser实例（便捷方法）
  factory LoginUser.fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = JsonUtil.parse(jsonString);
    return LoginUser.fromJson(jsonMap);
  }

  /// 将LoginUser实例转换为JSON Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    if (userName != null) data['userName'] = userName;
    if (userAvatar != null) data['userAvatar'] = userAvatar;
    if (userProfile != null) data['userProfile'] = userProfile;
    if (userAccount != null) data['userAccount'] = userAccount;
    if (userRole != null) data['userRole'] = userRole;
    if (createTime != null) data['createTime'] = createTime?.toIso8601String();
    if (updateTime != null) data['updateTime'] = updateTime?.toIso8601String();
    return data;
  }
}
