import 'dart:collection';

import 'package:flutter/material.dart';

abstract class BaseModel<T> {
  T copyWith(Map<String, dynamic> newData);

  @protected
  final UnmodifiableMapView<String, dynamic> data;
  BaseModel(Map<String, dynamic> jSON) : data = UnmodifiableMapView(jSON);
  Map<String, dynamic> toMap() => {...data};

  @protected
  dynamic get primaryField;

  @override
  bool operator ==(other) => other is T && other.hashCode == hashCode;

  @override
  int get hashCode => primaryField.hashCode;
}
