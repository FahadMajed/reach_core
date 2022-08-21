import 'dart:collection';

import 'package:flutter/material.dart';

abstract class BaseModel<T> {
  T copyWith(Map<String, dynamic> newData);

  @protected
  final UnmodifiableMapView<String, dynamic> data;
  @protected
  BaseModel(Map<String, dynamic> jSON) : data = UnmodifiableMapView(jSON);

  Map<String, dynamic> toMap() => {...data};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseModel<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}
