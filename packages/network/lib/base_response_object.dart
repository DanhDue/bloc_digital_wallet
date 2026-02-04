// Copyright (c) 2022, one of the D3F outsourcing projects. All rights reserved.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response_object.g.dart';

const String successStatus = "0000";

@JsonSerializable(genericArgumentFactories: true, includeIfNull: true)
class BaseResponseObject<T> extends Equatable {
  @JsonKey(name: 'success')
  final bool? success;
  @JsonKey(name: 'code')
  final String? code;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'data')
  final T? data;

  const BaseResponseObject({this.success, this.code, this.message, this.data});

  bool isSuccess() => code == null || code == successStatus;

  factory BaseResponseObject.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) jsonToT,
  ) {
    return _$BaseResponseObjectFromJson<T>(json, jsonToT);
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) {
    return _$BaseResponseObjectToJson<T>(this, toJsonT);
  }

  @override
  List<Object?> get props => [success, code, message, data];
}
