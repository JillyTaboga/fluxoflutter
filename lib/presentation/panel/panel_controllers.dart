import 'package:fluxoflutter/domain/chart_entity.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'panel_controllers.g.dart';

@riverpod
class PanelWidth extends _$PanelWidth {
  @override
  double build() {
    return 200;
  }

  update(double newValue) {
    state = newValue.clamp(50, 400);
  }
}

@riverpod
class ViewSettingsHover extends _$ViewSettingsHover {
  @override
  bool build() {
    return false;
  }

  hover(bool onHover) {
    state = onHover;
  }
}

@riverpod
class PanelZoom extends _$PanelZoom {
  @override
  double build() {
    return 1;
  }

  changeZoom(double newZoom) {
    state = newZoom.clamp(minZoom, maxZoom);
  }
}

const double minZoom = 0.1;
const double maxZoom = 5;

const double panelWidth = 1000;
const double panelHeight = 1000;

@riverpod
class GridView extends _$GridView {
  @override
  bool build() {
    return true;
  }

  change() {
    state = !state;
  }
}

@riverpod
class StartLigature extends _$StartLigature {
  @override
  CreatingLigature? build() {
    return null;
  }

  start(CreatingLigature start) {
    state = start;
  }

  clear() {
    state = null;
  }
}

class CreatingLigature {
  final AnchorPoint startAnchor;
  final PanelEntity startPanel;
  const CreatingLigature({
    required this.startAnchor,
    required this.startPanel,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatingLigature &&
        other.startAnchor == startAnchor &&
        other.startPanel == startPanel;
  }

  @override
  int get hashCode => startAnchor.hashCode ^ startPanel.hashCode;
}
