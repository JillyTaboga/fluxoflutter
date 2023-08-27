import 'package:flutter/material.dart';
import 'package:fluxoflutter/domain/tool_entity.dart';
import 'package:fluxoflutter/presentation/panel/panel_controllers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tools_controller.g.dart';

@riverpod
class SelectedTool extends _$SelectedTool {
  @override
  Tool? build() {
    return null;
  }

  selectTool(Tool newTool) {
    state = newTool;
  }

  unselect() {
    ref.read(startLigatureProvider.notifier).clear();
    state = null;
  }
}

@riverpod
class MousePosition extends _$MousePosition {
  @override
  Offset build() {
    return Offset.zero;
  }

  update(Offset newOffset) {
    state = newOffset;
  }
}

@riverpod
class MouseInsidePosition extends _$MouseInsidePosition {
  @override
  Offset build() {
    return Offset.zero;
  }

  updatePosition(Offset position) {
    state = position;
  }
}
