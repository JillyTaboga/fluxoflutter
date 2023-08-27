import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/domain/tool_entity.dart';
import 'package:fluxoflutter/presentation/chart/select_item_controller.dart';
import 'package:fluxoflutter/presentation/tools/tools_controller.dart';

class ToolsBar extends ConsumerWidget {
  const ToolsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.start,
      children: Tool.values
          .map(
            (e) => SizedBox(
              width: 50,
              child: GestureDetector(
                onTapDown: (detail) {
                  ref.read(selectedItemProvider.notifier).unselect();
                  final tool = ref.read(selectedToolProvider);
                  if (e == tool) {
                    ref.read(selectedToolProvider.notifier).unselect();
                  } else {
                    ref.read(selectedToolProvider.notifier).selectTool(e);
                    ref
                        .read(mousePositionProvider.notifier)
                        .update(detail.globalPosition);
                  }
                },
                child: Column(
                  children: [
                    ToolIcon(e.icon),
                    Text(
                      e.label,
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class ToolIcon extends StatelessWidget {
  const ToolIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(icon),
    );
  }
}
