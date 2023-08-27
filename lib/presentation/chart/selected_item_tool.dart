import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/domain/chart_entity.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:fluxoflutter/presentation/chart/chart_itens.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';

class SelectedLigatureTool extends ConsumerWidget {
  const SelectedLigatureTool({
    super.key,
    required this.ligature,
  });

  final LigatureEntity ligature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text('Espessura:'),
        Slider(
          value: ligature.thickness,
          min: 0.1,
          max: 20,
          onChanged: (value) {
            final newItem = ligature.copyWith(thickness: value);
            ref.read(selectedLigatureProvider.notifier).select(newItem);
            ref.read(ligaturesProvider.notifier).updateItem(newItem);
          },
        ),
        const SizedBox(
          height: 15,
        ),
        const Text('Cor:'),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () async {
            final newColor = await showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Selecione uma cor:'),
                            MaterialColorPicker(
                              onColorChange: (value) {
                                Navigator.pop(context, value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
            if (context.mounted) {
              final newItem = ligature.copyWith(
                color:
                    newColor ?? Theme.of(context).colorScheme.primaryContainer,
              );
              ref.read(selectedLigatureProvider.notifier).select(newItem);
              ref.read(ligaturesProvider.notifier).updateItem(newItem);
            }
          },
          child: CircleColor(
            color: ligature.color,
            circleSize: 50,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
          onPressed: () {
            final points = ligature.middlePoints;
            final pointsWithStart = [
              ligature.startPoint,
              ...ligature.middlePoints
            ];
            final newPoint = Offset(
              (ligature.endpoint.dx + pointsWithStart.last.dx) / 2,
              (ligature.endpoint.dy + pointsWithStart.last.dy) / 2,
            );
            final newItem =
                ligature.copyWith(middlePoints: [...points, newPoint]);
            ref.read(selectedLigatureProvider.notifier).select(newItem);
            ref.read(ligaturesProvider.notifier).updateItem(newItem);
          },
          child: const Text('Adicionar ponto'),
        ),
        const SizedBox(
          height: 15,
        ),
        if (ligature.middlePoints.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              var points = [...ligature.middlePoints];
              points.removeLast();
              final newItem = ligature.copyWith(middlePoints: points);
              ref.read(selectedLigatureProvider.notifier).select(newItem);
              ref.read(ligaturesProvider.notifier).updateItem(newItem);
            },
            child: const Text('Remover ponto'),
          ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            ref.read(selectedLigatureProvider.notifier).unselect();
            ref.read(ligaturesProvider.notifier).removeItem(ligature);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Remover'),
        ),
      ],
    );
  }
}

class SeletedPanelTool extends ConsumerWidget {
  const SeletedPanelTool({super.key, required this.selectedPanel});

  final PanelEntity selectedPanel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text('Arredondamento:'),
        Slider(
          value: selectedPanel.radius,
          min: 0,
          max: 100,
          onChanged: (value) {
            final newItem = selectedPanel.copyWith(radius: value);
            ref.read(selectedItemProvider.notifier).select(newItem);
            ref.read(chartItensProvider.notifier).updateItem(newItem);
          },
        ),
        const SizedBox(
          height: 15,
        ),
        const Text('Cor:'),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () async {
            final newColor = await showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Selecione uma cor:'),
                            MaterialColorPicker(
                              onColorChange: (value) {
                                Navigator.pop(context, value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
            if (context.mounted) {
              final newItem = selectedPanel.copyWith(
                color:
                    newColor ?? Theme.of(context).colorScheme.primaryContainer,
              );
              ref.read(selectedItemProvider.notifier).select(newItem);
              ref.read(chartItensProvider.notifier).updateItem(newItem);
            }
          },
          child: CircleColor(
            color: selectedPanel.color ??
                Theme.of(context).colorScheme.primaryContainer,
            circleSize: 50,
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () {
            ref.read(selectedItemProvider.notifier).unselect();
            ref.read(chartItensProvider.notifier).removeItem(selectedPanel);
          },
          icon: const Icon(Icons.delete),
          label: const Text('Remover'),
        ),
      ],
    );
  }
}
