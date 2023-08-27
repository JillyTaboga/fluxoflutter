import 'package:flutter/material.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:fluxoflutter/domain/tool_entity.dart';

class PanelEntity {
  final Rect rect;
  final Offset position;
  final Tool tool;
  final Color? color;
  final double opacity;
  final double radius;
  final String guid;
  const PanelEntity({
    required this.rect,
    required this.position,
    required this.tool,
    this.color,
    this.opacity = 1,
    this.radius = 5,
    required this.guid,
  });

  Offset anchoPosition(AnchorPoint anchor) {
    return switch (anchor) {
      AnchorPoint.top => topAnchor,
      AnchorPoint.bottom => bottomAnchor,
      AnchorPoint.left => leftAnchor,
      AnchorPoint.right => rightAnchor,
    };
  }

  Offset get bottomRightPosition => Offset(
        position.dx + rect.size.width,
        position.dy + rect.size.height,
      );

  Offset get topAnchor => Offset(
        position.dx + (rect.size.width / 2),
        position.dy,
      );

  Offset get leftAnchor => Offset(
        position.dx,
        position.dy + (rect.size.height / 2),
      );

  Offset get rightAnchor => Offset(
        position.dx + rect.width,
        position.dy + (rect.size.height / 2),
      );

  Offset get bottomAnchor => Offset(
        position.dx + (rect.size.width / 2),
        position.dy + rect.size.height,
      );

  PanelEntity copyWith({
    Rect? rect,
    Offset? position,
    Tool? tool,
    Color? color,
    double? opacity,
    double? radius,
    String? guid,
  }) {
    return PanelEntity(
      rect: rect ?? this.rect,
      position: position ?? this.position,
      tool: tool ?? this.tool,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      radius: radius ?? this.radius,
      guid: guid ?? this.guid,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PanelEntity && other.guid == guid;
  }

  @override
  int get hashCode {
    return guid.hashCode;
  }

  @override
  String toString() {
    return 'PanelEntity(rect: $rect, position: $position, tool: $tool, color: $color, opacity: $opacity, radius: $radius, guid: $guid)';
  }
}
