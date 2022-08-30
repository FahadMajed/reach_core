import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BaseModel<T> extends Equatable {
  T copyWith(Map<String, dynamic> newData);

  @protected
  final UnmodifiableMapView<String, dynamic> data;
  @protected
  BaseModel(Map<String, dynamic> jSON) : data = UnmodifiableMapView(jSON);

  Map<String, dynamic> toMap() => {...data};

  @override
  String toString() => '$data';
}
