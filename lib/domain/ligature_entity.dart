import 'package:flutter/material.dart';
import 'package:fluxoflutter/domain/chart_entity.dart';

class LigatureEntity {
  final PanelEntity startPanel;
  final AnchorPoint startAnchor;
  final PanelEntity endPanel;
  final AnchorPoint endAnchor;
  final List<Offset> middlePoints;
  final String guid;
  final Color color;
  final double thickness;
  const LigatureEntity({
    required this.startPanel,
    required this.startAnchor,
    required this.endPanel,
    required this.endAnchor,
    required this.middlePoints,
    required this.guid,
    required this.color,
    this.thickness = 1,
  });

  Offset get startPoint => startPanel.anchoPosition(startAnchor);
  Offset get endpoint => endPanel.anchoPosition(endAnchor);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LigatureEntity && other.guid == guid;
  }

  @override
  int get hashCode {
    return guid.hashCode;
  }

  LigatureEntity copyWith({
    PanelEntity? startPanel,
    AnchorPoint? startAnchor,
    PanelEntity? endPanel,
    AnchorPoint? endAnchor,
    List<Offset>? middlePoints,
    String? guid,
    Color? color,
    double? thickness,
  }) {
    return LigatureEntity(
      startPanel: startPanel ?? this.startPanel,
      startAnchor: startAnchor ?? this.startAnchor,
      endPanel: endPanel ?? this.endPanel,
      endAnchor: endAnchor ?? this.endAnchor,
      middlePoints: middlePoints ?? this.middlePoints,
      guid: guid ?? this.guid,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
    );
  }
}

enum AnchorPoint {
  top,
  bottom,
  left,
  right;
}
