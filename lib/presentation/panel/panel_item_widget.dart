import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/domain/chart_entity.dart';
import 'package:fluxoflutter/domain/ligature_entity.dart';
import 'package:fluxoflutter/domain/tool_entity.dart';
import 'package:fluxoflutter/presentation/chart/chart_itens.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';
import 'package:fluxoflutter/presentation/panel/panel_controllers.dart';
import 'package:fluxoflutter/presentation/tools/tools_controller.dart';
import 'package:uuid/uuid.dart';

class PanelItemWidget extends ConsumerWidget {
  const PanelItemWidget({super.key, required this.panel});

  final PanelEntity panel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedItemProvider) == panel;
    final color = panel.color ?? Theme.of(context).colorScheme.primaryContainer;
    final onLigature = ref.watch(selectedToolProvider) == Tool.ligature;

    ligatureAnchorTap(AnchorPoint anchor) {
      final creatingLigature = ref.read(startLigatureProvider);
      if (creatingLigature == null) {
        ref.read(startLigatureProvider.notifier).start(
              CreatingLigature(
                startAnchor: anchor,
                startPanel: panel,
              ),
            );
      } else {
        if (panel.guid == creatingLigature.startPanel.guid) {
          ref.read(startLigatureProvider.notifier).clear();
          ref.read(selectedToolProvider.notifier).unselect();
        } else {
          ref.read(ligaturesProvider.notifier).addItem(
                LigatureEntity(
                  startPanel: creatingLigature.startPanel,
                  startAnchor: creatingLigature.startAnchor,
                  endAnchor: anchor,
                  endPanel: panel,
                  middlePoints: [],
                  guid: const Uuid().v4(),
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
          ref.read(startLigatureProvider.notifier).clear();
          ref.read(selectedToolProvider.notifier).unselect();
        }
      }
    }

    return InkWell(
      onTap: () {
        ref.read(selectedItemProvider.notifier).select(panel);
      },
      child: SizedBox(
        width: panel.rect.size.width,
        height: panel.rect.size.height,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: Alignment.topLeft,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: panel.rect.size.width,
                height: panel.rect.size.height,
                decoration: BoxDecoration(
                  boxShadow: isSelected ? kElevationToShadow[3] : [],
                  color: color,
                  borderRadius: BorderRadius.circular(panel.radius),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : color,
                  ),
                ),
              ),
              if (onLigature) ...[
                Positioned(
                  top: -5,
                  left: (constraints.maxWidth / 2) - 5,
                  child: GestureDetector(
                    onTapDown: (details) {
                      ligatureAnchorTap(AnchorPoint.top);
                    },
                    child: const Anchor(),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  left: (constraints.maxWidth / 2) - 5,
                  child: GestureDetector(
                    onTapDown: (details) {
                      ligatureAnchorTap(AnchorPoint.bottom);
                    },
                    child: const Anchor(),
                  ),
                ),
                Positioned(
                  top: (constraints.maxHeight / 2) - 5,
                  left: -5,
                  child: GestureDetector(
                    onTapDown: (details) {
                      ligatureAnchorTap(AnchorPoint.left);
                    },
                    child: const Anchor(),
                  ),
                ),
                Positioned(
                  top: (constraints.maxHeight / 2) - 5,
                  right: -5,
                  child: GestureDetector(
                    onTapDown: (details) {
                      ligatureAnchorTap(AnchorPoint.right);
                    },
                    child: const Anchor(),
                  ),
                ),
              ],
              if (isSelected)
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final basePosition = ref
                          .watch(chartItensProvider)
                          .firstWhere((element) => element.guid == panel.guid)
                          .bottomRightPosition;
                      final newPosition = basePosition + details.localPosition;
                      final newItem = panel.copyWith(
                        rect: Rect.fromPoints(
                          panel.position,
                          normalizeOffset(newPosition),
                        ),
                      );
                      ref
                          .read(selectedItemProvider.notifier)
                          .select(normalizePanel(newItem));
                    },
                    onPanEnd: (details) {
                      ref.read(chartItensProvider.notifier).updateItem(panel);
                    },
                    child: const Nod(
                      isActive: false,
                      icon: Icons.aspect_ratio,
                    ),
                  ),
                ),
              if (isSelected)
                Positioned(
                  left: -10,
                  top: -10,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      final basePosition = ref
                          .watch(chartItensProvider)
                          .firstWhere((element) => element.guid == panel.guid)
                          .position;
                      final newPosition = basePosition + details.localPosition;
                      final newItem = panel.copyWith(
                        position: newPosition,
                      );
                      ref
                          .read(selectedItemProvider.notifier)
                          .select(normalizePanel(newItem));
                    },
                    onPanEnd: (details) {
                      ref.read(chartItensProvider.notifier).updateItem(panel);
                    },
                    child: const Nod(
                      isActive: false,
                      icon: Icons.control_camera,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

Offset normalizeOffset(Offset point) {
  final double realDx = point.dx < 0
      ? 0
      : point.dx > panelWidth
          ? panelWidth
          : point.dx;
  final double realDy = point.dy < 0
      ? 0
      : point.dy > panelHeight
          ? panelHeight
          : point.dy;
  return Offset(realDx, realDy);
}

PanelEntity normalizePanel(PanelEntity panel) {
  final double realDx = panel.position.dx < 0
      ? 0
      : panel.position.dx + panel.rect.width > panelWidth
          ? panelWidth - panel.rect.size.width
          : panel.position.dx;
  final double realDy = panel.position.dy < 0
      ? 0
      : panel.position.dy + panel.rect.height > panelHeight
          ? panelHeight - panel.rect.size.height
          : panel.position.dy;
  return panel.copyWith(position: Offset(realDx, realDy));
}

class Nod extends StatelessWidget {
  const Nod({
    super.key,
    required this.icon,
    this.isActive = false,
  });

  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        borderRadius: BorderRadius.circular(2),
        color: isActive
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Icon(icon),
    );
  }
}

class Anchor extends StatefulWidget {
  const Anchor({super.key});

  @override
  State<Anchor> createState() => _AnchorState();
}

class _AnchorState extends State<Anchor> {
  bool hasHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          hasHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          hasHover = false;
        });
      },
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: hasHover ? 20 : 10,
          height: hasHover ? 20 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasHover
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
            boxShadow: kElevationToShadow[1],
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
