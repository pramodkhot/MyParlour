import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Lays out and paints [child] away from the screen and returns it as an
/// image [pixelRatio] times its logical size. The child is given
/// [maxWidth] × up to [maxHeight] and sized to its content.
Future<ui.Image> renderOffscreen(
  Widget child, {
  required double maxWidth,
  double maxHeight = 20000,
  double pixelRatio = 3,
}) async {
  final boundary = RenderRepaintBoundary();
  final view =
      WidgetsBinding.instance.platformDispatcher.implicitView ??
      WidgetsBinding.instance.platformDispatcher.views.first;
  final renderView = RenderView(
    view: view,
    child: RenderPositionedBox(alignment: Alignment.topLeft, child: boundary),
    configuration: ViewConfiguration(
      logicalConstraints: BoxConstraints.tight(Size(maxWidth, maxHeight)),
      physicalConstraints: BoxConstraints.tight(Size(maxWidth, maxHeight)),
    ),
  );
  final pipeline = PipelineOwner()..rootNode = renderView;
  renderView.prepareInitialFrame();

  final buildOwner = BuildOwner(focusManager: FocusManager());
  final root = RenderObjectToWidgetAdapter<RenderBox>(
    container: boundary,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
          style: const TextStyle(color: Color(0xFF000000)),
          child: child,
        ),
      ),
    ),
  ).attachToRenderTree(buildOwner);
  buildOwner
    ..buildScope(root)
    ..finalizeTree();
  pipeline
    ..flushLayout()
    ..flushCompositingBits()
    ..flushPaint();
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  pipeline
    ..rootNode = null
    ..dispose();
  return image;
}
