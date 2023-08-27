import 'package:fluxoflutter/domain/chart_entity.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_item_controller.g.dart';

@riverpod
class SelectedItem extends _$SelectedItem {
  @override
  PanelEntity? build() {
    return null;
  }

  select(PanelEntity item) {
    ref.read(selectedLigatureProvider.notifier).unselect();
    state = item;
  }

  unselect() {
    state = null;
  }
}

@riverpod
class SelectedLigature extends _$SelectedLigature {
  @override
  LigatureEntity? build() {
    return null;
  }

  select(LigatureEntity ligature) {
    ref.read(selectedItemProvider.notifier).unselect();
    state = ligature;
  }

  unselect() {
    state = null;
  }
}
