import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluxoflutter/domain/chart_entity.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';
import 'package:fluxoflutter/presentation/tools/tools_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chart_itens.g.dart';

@riverpod
class ChartItens extends _$ChartItens {
  @override
  List<PanelEntity> build() {
    return [];
  }

  addItem(PanelEntity newItem) {
    state = [...state, newItem];
  }

  removeItem(PanelEntity item) {
    var items = [...state];
    items.removeWhere((element) => element.guid == item.guid);
    final ligatures = ref.read(ligaturesProvider);
    final ligaturesToRemove = ligatures.where(
      (element) =>
          element.endPanel.guid == item.guid ||
          element.startPanel.guid == item.guid,
    );
    for (final ligature in ligaturesToRemove) {
      ref.read(ligaturesProvider.notifier).removeItem(ligature);
    }

    state = items;
  }

  updateItem(PanelEntity newItem) {
    var items = [...state];
    final oldItemIndex =
        state.indexWhere((element) => element.guid == newItem.guid);
    if (oldItemIndex == -1) return;
    final ligatures = ref.read(ligaturesProvider);
    final ligaturesThatEnds = ligatures.where(
      (element) => element.endPanel.guid == newItem.guid,
    );
    for (final ligature in ligaturesThatEnds) {
      final newLigature = ligature.copyWith(endPanel: newItem);
      ref.read(ligaturesProvider.notifier).updateItem(newLigature);
    }
    final ligaturesThatStart = ligatures.where(
      (element) => element.startPanel.guid == newItem.guid,
    );
    for (final ligature in ligaturesThatStart) {
      final newLigature = ligature.copyWith(startPanel: newItem);
      ref.read(ligaturesProvider.notifier).updateItem(newLigature);
    }
    items.removeAt(oldItemIndex);
    items.insert(oldItemIndex, newItem);
    state = items;
  }
}

@Riverpod(keepAlive: true)
class CreatingTool extends _$CreatingTool {
  @override
  CreatingItem? build() {
    return null;
  }

  start(Offset position) {
    state = CreatingItem(pointA: position, pointB: position);
  }

  update(Offset endPoint) {
    state = state!.copyWith(pointB: endPoint);
  }

  create() {
    if (state == null) {
      return;
    } else {
      final newItem = PanelEntity(
        rect: Rect.fromLTWH(
          state!.left,
          state!.top,
          state!.size.width,
          state!.size.height,
        ),
        position: Offset(state!.left, state!.top),
        tool: ref.read(selectedToolProvider)!,
        guid: const Uuid().v4(),
      );
      ref.read(chartItensProvider.notifier).addItem(newItem);
      ref.read(selectedItemProvider.notifier).select(newItem);
    }
    ref.read(selectedToolProvider.notifier).unselect();
    state = null;
  }
}

class CreatingItem {
  final Offset pointA;
  final Offset pointB;
  const CreatingItem({
    required this.pointA,
    required this.pointB,
  });

  double get top => min(pointA.dy, pointB.dy);
  double get left => min(pointA.dx, pointB.dx);
  Size get size => Size(
        (pointA.dx - pointB.dx).abs(),
        (pointA.dy - pointB.dy).abs(),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatingItem &&
        other.pointA == pointA &&
        other.pointB == pointB;
  }

  @override
  int get hashCode => pointA.hashCode ^ pointB.hashCode;

  @override
  String toString() => 'CreatingItem(pointA: $pointA, pointB: $pointB)';

  CreatingItem copyWith({
    Offset? pointA,
    Offset? pointB,
  }) {
    return CreatingItem(
      pointA: pointA ?? this.pointA,
      pointB: pointB ?? this.pointB,
    );
  }
}

@riverpod
class Ligatures extends _$Ligatures {
  @override
  List<LigatureEntity> build() {
    return [];
  }

  addItem(LigatureEntity newItem) {
    state = [...state, newItem];
  }

  removeItem(LigatureEntity item) {
    var items = [...state];
    items.removeWhere((element) => element.guid == item.guid);
    state = items;
  }

  updateItem(LigatureEntity newItem) {
    var items = [...state];
    final oldItemIndex =
        state.indexWhere((element) => element.guid == newItem.guid);
    if (oldItemIndex == -1) return;
    items.removeAt(oldItemIndex);
    items.insert(oldItemIndex, newItem);
    state = items;
  }
}
