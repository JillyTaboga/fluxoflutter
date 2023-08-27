import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/domain/tool_entity.dart';
import 'package:fluxoflutter/presentation/chart/chart_itens.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';
import 'package:fluxoflutter/presentation/chart/selected_item_tool.dart';
import 'package:fluxoflutter/presentation/ligature/ligature_widget.dart';
import 'package:fluxoflutter/presentation/panel/panel_controllers.dart';
import 'package:fluxoflutter/presentation/panel/panel_item_widget.dart';
import 'package:fluxoflutter/presentation/theme/change_theme_button.dart';
import 'package:fluxoflutter/presentation/tools/tools_bar.dart';
import 'package:fluxoflutter/presentation/tools/tools_controller.dart';
import 'package:intl/intl.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  late TransformationController panelController;

  @override
  void initState() {
    super.initState();
    panelController = TransformationController(
      Matrix4.identity().scaled(
        ref.read(panelZoomProvider),
      ),
    );
    panelController.addListener(() {
      if (panelController.value.row2.p != ref.read(panelZoomProvider)) {
        ref.read(panelZoomProvider.notifier).changeZoom(
              panelController.value.row2.p,
            );
      }
    });
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mousePosition = ref.watch(mousePositionProvider);
    final tool = ref.watch(selectedToolProvider);
    final hasTool = tool != null;
    final creatingPanel = ref.watch(creatingToolProvider);
    final selectedPanel = ref.watch(selectedItemProvider);
    final selectedLigature = ref.watch(selectedLigatureProvider);
    final creatingLigatureStartPoint = ref.watch(startLigatureProvider);
    final insideMousePosition = ref.watch(mouseInsidePositionProvider);
    ref.listen(panelZoomProvider, (previous, next) {
      if (previous != next && panelController.value.row2.p != next) {
        Future(() {
          setState(() {
            panelController.value.setEntry(0, 0, next);
            panelController.value.setEntry(1, 1, next);
            panelController.value.setEntry(2, 2, next);
            panelController.value.setEntry(3, 3, 1 / next);
          });
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluxo Flutter'),
        actions: const [
          ChangeThemeButton(),
        ],
      ),
      body: MouseRegion(
        onHover: (event) {
          ref.read(mousePositionProvider.notifier).update(event.position);
        },
        onExit: (event) {
          ref.read(selectedToolProvider.notifier).unselect();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: ref.watch(panelWidthProvider),
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        boxShadow: kElevationToShadow[3],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Ferramentas:',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Expanded(
                                  child: ToolsBar(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: (selectedPanel != null ||
                                    selectedLigature != null)
                                ? Column(
                                    children: [
                                      Text(
                                        'Propriedades:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: selectedPanel != null
                                            ? SeletedPanelTool(
                                                selectedPanel: selectedPanel,
                                              )
                                            : SelectedLigatureTool(
                                                ligature: selectedLigature!,
                                              ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    MouseRegion(
                      cursor: MaterialStateMouseCursor.clickable,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          if (details.globalPosition.dx <
                              constraints.maxWidth - 5) {
                            ref
                                .read(panelWidthProvider.notifier)
                                .update(details.globalPosition.dx);
                          }
                        },
                        onDoubleTap: () {
                          ref.read(panelWidthProvider.notifier).update(200);
                        },
                        child: Container(
                          height: double.maxFinite,
                          width: 5,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap:
                            (selectedPanel != null || selectedLigature != null)
                                ? () {
                                    ref
                                        .read(selectedToolProvider.notifier)
                                        .unselect();
                                    ref
                                        .read(selectedLigatureProvider.notifier)
                                        .unselect();
                                    ref
                                        .read(selectedItemProvider.notifier)
                                        .unselect();
                                  }
                                : null,
                        child: Stack(
                          children: [
                            InteractiveViewer(
                              constrained: false,
                              boundaryMargin: const EdgeInsets.all(1000),
                              maxScale: maxZoom,
                              minScale: minZoom,
                              scaleFactor: kDefaultMouseScrollToScaleFactor * 5,
                              transformationController: panelController,
                              panEnabled: !hasTool,
                              child: GestureDetector(
                                onSecondaryTap: hasTool
                                    ? () {
                                        ref
                                            .read(selectedToolProvider.notifier)
                                            .unselect();
                                        ref
                                            .read(selectedLigatureProvider
                                                .notifier)
                                            .unselect();
                                        ref
                                            .read(selectedItemProvider.notifier)
                                            .unselect();
                                      }
                                    : null,
                                onPanStart: hasTool
                                    ? (details) {
                                        switch (tool) {
                                          case Tool.rectagular:
                                            ref
                                                .read(creatingToolProvider
                                                    .notifier)
                                                .start(details.localPosition);
                                            break;
                                          default:
                                        }
                                      }
                                    : null,
                                onPanEnd: hasTool
                                    ? (details) {
                                        switch (tool) {
                                          case Tool.rectagular:
                                            ref
                                                .read(creatingToolProvider
                                                    .notifier)
                                                .create();
                                            break;
                                          default:
                                        }
                                      }
                                    : null,
                                onPanUpdate: hasTool
                                    ? (details) {
                                        switch (tool) {
                                          case Tool.rectagular:
                                            ref
                                                .read(creatingToolProvider
                                                    .notifier)
                                                .update(details.localPosition);
                                            break;
                                          default:
                                        }
                                      }
                                    : null,
                                child: MouseRegion(
                                  onHover: (event) {
                                    ref
                                        .read(mouseInsidePositionProvider
                                            .notifier)
                                        .updatePosition(event.localPosition);
                                  },
                                  child: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    width: panelWidth,
                                    height: panelHeight,
                                    child: Stack(
                                      children: [
                                        GridPaper(
                                          divisions: 1,
                                          color: ref.watch(gridViewProvider)
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.3)
                                              : Colors.transparent,
                                          child: const SizedBox.expand(),
                                        ),
                                        ...ref
                                            .watch(ligaturesProvider)
                                            .map(
                                              (e) => LigatureWidget(
                                                ligature: e,
                                              ),
                                            )
                                            .toList(),
                                        if (creatingPanel != null)
                                          Positioned(
                                            top: creatingPanel.top,
                                            left: creatingPanel.left,
                                            child: Container(
                                              width: creatingPanel.size.width,
                                              height: creatingPanel.size.height,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ...ref.watch(chartItensProvider).map(
                                          (e) {
                                            final isSelected =
                                                selectedPanel == e;
                                            return Positioned(
                                              top: e.position.dy,
                                              left: e.position.dx,
                                              child: Opacity(
                                                opacity: isSelected ? 0.2 : 1,
                                                child:
                                                    PanelItemWidget(panel: e),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                        if (selectedPanel != null)
                                          Positioned(
                                            top: selectedPanel.position.dy,
                                            left: selectedPanel.position.dx,
                                            child: PanelItemWidget(
                                              panel: selectedPanel,
                                            ),
                                          ),
                                        if (creatingLigatureStartPoint != null)
                                          LigatureCreatingDraw(
                                            end: insideMousePosition,
                                            start: creatingLigatureStartPoint
                                                .startPanel
                                                .anchoPosition(
                                              creatingLigatureStartPoint
                                                  .startAnchor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 15,
                              top: 15,
                              child: ViewTool(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (hasTool && creatingPanel == null)
                  Positioned(
                    top: mousePosition.dy - 35,
                    left: mousePosition.dx + 5,
                    child: PhysicalModel(
                      color: Colors.transparent,
                      elevation: 3,
                      child: ToolIcon(
                        tool.icon,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LigatureCreatingDraw extends StatelessWidget {
  const LigatureCreatingDraw({
    super.key,
    required this.end,
    required this.start,
  });

  final Offset start;
  final Offset end;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LigatureCreatingPainter(
        end: end,
        start: start,
        ligatureColor: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class LigatureCreatingPainter extends CustomPainter {
  LigatureCreatingPainter({
    required this.end,
    required this.start,
    required this.ligatureColor,
  });
  final Offset start;
  final Offset end;
  final Color ligatureColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ligatureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LigatureCreatingPainter oldDelegate) {
    if (oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.ligatureColor != ligatureColor) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool shouldRebuildSemantics(LigatureCreatingPainter oldDelegate) => false;
}

class ViewTool extends ConsumerWidget {
  const ViewTool({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHover = ref.watch(viewSettingsHoverProvider);
    return MouseRegion(
      onEnter: (event) {
        ref.read(viewSettingsHoverProvider.notifier).hover(true);
      },
      onExit: (event) {
        ref.read(viewSettingsHoverProvider.notifier).hover(false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withOpacity(isHover ? 1 : 0.3),
          boxShadow: isHover ? kElevationToShadow[3] : [],
          borderRadius: BorderRadius.circular(150),
        ),
        padding: const EdgeInsets.all(10),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: isHover
                ? Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(gridViewProvider.notifier).change();
                        },
                        icon: const Icon(Icons.grid_4x4_rounded),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(panelZoomProvider.notifier).changeZoom(1);
                        },
                        icon: const Icon(
                          Icons.refresh,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.search,
                        size: 15,
                      ),
                      Text(
                        NumberFormat.decimalPercentPattern(decimalDigits: 2)
                            .format(ref.watch(panelZoomProvider)),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
