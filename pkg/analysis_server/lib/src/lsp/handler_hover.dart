// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analysis_server/lsp_protocol/protocol_generated.dart';
import 'package:analysis_server/protocol/protocol_generated.dart';
import 'package:analysis_server/src/computer/computer_hover.dart';
import 'package:analysis_server/src/lsp/dartdoc.dart';
import 'package:analysis_server/src/lsp/handlers/handlers.dart';
import 'package:analysis_server/src/lsp/lsp_analysis_server.dart';
import 'package:analysis_server/src/lsp/mapping.dart';
import 'package:analyzer/source/line_info.dart';

class HoverHandler extends MessageHandler<TextDocumentPositionParams, Hover> {
  HoverHandler(LspAnalysisServer server) : super(server);
  String get handlesMessage => 'textDocument/hover';

  @override
  TextDocumentPositionParams convertParams(Map<String, dynamic> json) =>
      TextDocumentPositionParams.fromJson(json);

  Future<Hover> handle(TextDocumentPositionParams params) async {
    final path = pathOf(params.textDocument);
    final result = await requireUnit(path);
    final offset = toOffset(result.lineInfo, params.position);

    final hover = new DartUnitHoverComputer(result.unit, offset).compute();
    return toHover(result.lineInfo, hover);
  }

  Hover toHover(LineInfo lineInfo, HoverInformation hover) {
    if (hover == null) {
      return null;
    }

    // Import prefix tooltips are not useful currently.
    // https://github.com/dart-lang/sdk/issues/32735
    if (hover.elementKind == 'import prefix') {
      return null;
    }

    final content = new StringBuffer();

    // Description.
    if (hover.elementDescription != null) {
      content.writeln('```dart');
      if (hover.isDeprecated) {
        content.write('(deprecated) ');
      }
      content..writeln(hover.elementDescription)..writeln('```')..writeln();
    }

    // Source library.
    if (hover.containingLibraryName != null &&
        hover.containingLibraryName.isNotEmpty) {
      content..writeln('*${hover.containingLibraryName}*')..writeln();
    } else if (hover.containingLibraryPath != null) {
      // TODO(dantup): Support displaying the package name (probably by adding
      // containingPackageName to the main hover?) once the analyzer work to
      // support this (inc Bazel/Gn) is done.
      // content..writeln('*${hover.containingPackageName}*')..writeln();
    }

    // Doc comments.
    if (hover.dartdoc != null) {
      content.writeln(cleanDartdoc(hover.dartdoc));
    }

    final formats =
        server?.clientCapabilities?.textDocument?.hover?.contentFormat;
    return new Hover(
      asStringOrMarkupContent(formats, content.toString().trimRight()),
      toRange(lineInfo, hover.offset, hover.length),
    );
  }
}
