// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chat _$$_ChatFromJson(Map<String, dynamic> json) => _$_Chat(
      id: json['id'] as int?,
      lastMessageTime: json['lastMessageTime'] as String?,
      meetingID: json['meetingID'] as String?,
    );

Map<String, dynamic> _$$_ChatToJson(_$_Chat instance) => <String, dynamic>{
      'id': instance.id,
      'lastMessageTime': instance.lastMessageTime,
      'meetingID': instance.meetingID,
    };
