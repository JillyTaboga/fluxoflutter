import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:fluxoflutter/presentation/chart/chart_itens.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';
import 'package:fluxoflutter/presentation/panel/panel_controllers.dart';

class LigatureWidget extends ConsumerWidget {
  const LigatureWidget({
    super.key,
    required this.ligature,
  });

  final LigatureEntity ligature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedLigatureProvider) == ligature;
    return SizedBox(
      width: panelWidth,
      height: panelHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              ref.read(selectedLigatureProvider.notifier).select(ligature);
            },
            child: CustomPaint(
              painter: LigatureWidgetPainter(
                ligature: ligature,
                isSelected: isSelected,
              ),
            ),
          ),
          if (isSelected)
            ...ligature.middlePoints
                .map(
                  (e) => Positioned(
                    top: e.dy - 5,
                    left: e.dx - 5,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        var points = [...ligature.middlePoints];
                        final index = points.indexOf(e);
                        points.removeAt(index);
                        points.insert(index, e + (details.delta * 3.5));
                        final newItem = ligature.copyWith(middlePoints: points);
                        ref
                            .read(selectedLigatureProvider.notifier)
                            .select(newItem);
                        ref
                            .read(ligaturesProvider.notifier)
                            .updateItem(newItem);
                      },
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          border: Border.all(),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }
}

class LigatureWidgetPainter extends CustomPainter {
  LigatureWidgetPainter({
    required this.ligature,
    required this.isSelected,
  });
  final LigatureEntity ligature;
  final bool isSelected;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ligature.color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = ligature.thickness;
    final path = Path();
    final startOffset = ligature.startPanel.anchoPosition(ligature.startAnchor);
    final endOffset = ligature.endPanel.anchoPosition(ligature.endAnchor);
    path.moveTo(startOffset.dx, startOffset.dy);
    for (final point in ligature.middlePoints) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(endOffset.dx, endOffset.dy);
    final selectedPath = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 1;
    canvas.drawPath(path, paint);
    if (isSelected) {
      canvas.drawPath(
        path,
        selectedPath,
      );
    }
  }

  Path hitBox() {
    final startOffset = ligature.startPanel.anchoPosition(ligature.startAnchor);
    final endOffset = ligature.endPanel.anchoPosition(ligature.endAnchor);
    final path2 = Path();
    path2.moveTo(startOffset.dx - 10, startOffset.dy + 10);
    path2.lineTo(endOffset.dx - 10, endOffset.dy + 10);
    for (final point in ligature.middlePoints) {
      path2.lineTo(point.dx - 10, point.dy + 10);
    }
    path2.lineTo(endOffset.dx + 10, endOffset.dy - 10);
    for (final point in [...ligature.middlePoints.reversed]) {
      path2.lineTo(point.dx + 10, point.dy - 10);
    }
    path2.lineTo(startOffset.dx + 10, startOffset.dy - 10);
    path2.close();
    return path2;
  }

  @override
  bool? hitTest(Offset position) {
    return hitBox().contains(position);
  }

  @override
  bool shouldRepaint(LigatureWidgetPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(LigatureWidgetPainter oldDelegate) => false;
}
