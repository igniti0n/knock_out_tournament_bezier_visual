import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class ElementPair extends Equatable {
  final String id = const Uuid().v1();
  final WidgetScreenData first;
  final WidgetScreenData second;

  ElementPair(this.first, this.second);

  @override
  List<Object?> get props => [id, first, second];
}

class WidgetScreenData extends Equatable {
  final Offset position;
  final Size size;
  final String name;

  const WidgetScreenData(
    this.position,
    this.size,
    this.name,
  );

  @override
  List<Object?> get props => [position, size];
}
