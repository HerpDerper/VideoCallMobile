// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      id: json['id'] as int?,
      login: json['login'] as String?,
      email: json['email'] as String?,
      dateBirth: json['dateBirth'] as String?,
      password: json['password'] as String?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'email': instance.email,
      'dateBirth': instance.dateBirth,
      'password': instance.password,
      'status': instance.status,
    };
