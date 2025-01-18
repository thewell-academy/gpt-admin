import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:core';

class MyAttributes {
  static final Attribute box =
  Attribute('box', AttributeScope.inline, 'true');
}

class _OpsGroup {
  final Map<String, dynamic>? attributes;
  final StringBuffer buffer = StringBuffer();

  _OpsGroup(this.attributes);

  void append(String text) {
    buffer.write(text);
  }

  String get text => buffer.toString();
}

class RichTextField extends StatefulWidget {
  final bool alignHorizontal;
  final double height;
  final Function(String) onContentChanged;

  const RichTextField({
    super.key,
    required this.alignHorizontal,
    required this.height,
    required this.onContentChanged,
  });

  @override
  State<RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  final QuillController _controller = QuillController.basic();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'QuillEditorFocusNode');

  @override
  void initState() {
    super.initState();
    // Whenever the document changes, we send the updated Delta JSON.
    _controller.document.changes.listen((_) {
      final String deltaString =
      jsonEncode(_controller.document.toDelta().toJson());
      widget.onContentChanged(deltaString);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _insertMathEquation() async {
    if (!_focusNode.hasFocus && _controller.selection.isValid) {
      _focusNode.requestFocus();
    }

    final selection = _controller.selection;
    final int index =
    selection.isValid ? selection.baseOffset : _controller.document.length;

    const String mathPlaceholder = '[:]';
    _controller.replaceText(
      index,
      0,
      mathPlaceholder,
      TextSelection.collapsed(offset: index + mathPlaceholder.length),
    );
  }

  List<InlineSpan> _buildSpansForGroup(_OpsGroup group) {
    final spans = <InlineSpan>[];
    final text = group.text;
    final attrs = group.attributes;

    final replacedText = _convertNumberToEmoji(text);

    final RegExp mathRegex = RegExp(r'\[:(.+?)\]');
    final List<RegExpMatch> matchList = mathRegex.allMatches(replacedText).toList();

    int currentIndex = 0;

    while (true) {
      RegExpMatch? match;
      try {
        match = matchList.firstWhere((m) => m.start >= currentIndex);
      } catch (e) {
        match = null;
      }

      if (match == null) {
        if (currentIndex < replacedText.length) {
          final trailingText = replacedText.substring(currentIndex);
          spans.addAll(_buildTextOrBoxSpans(trailingText, attrs));
        }
        break;
      } else {
        if (match.start > currentIndex) {
          final segment = replacedText.substring(currentIndex, match.start);
          spans.addAll(_buildTextOrBoxSpans(segment, attrs));
        }
        final latex = match.group(1) ?? '';
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              latex,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        );
        currentIndex = match.end;
      }
    }

    final bool hasBox = attrs?.containsKey(MyAttributes.box.key) ?? false;
    if (hasBox && spans.isNotEmpty) {
      return [
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: RichText(
              text: TextSpan(children: spans),
            ),
          ),
        ),
      ];
    }

    return spans;
  }


  List<InlineSpan> _buildTextOrBoxSpans(String text, Map<String, dynamic>? attributes) {
    TextStyle textStyle = const TextStyle(fontSize: 16, color: Colors.white);

    if (attributes != null) {
      if (attributes.containsKey('bold')) {
        textStyle = textStyle.merge(const TextStyle(fontWeight: FontWeight.bold));
      }
      if (attributes.containsKey('italic')) {
        textStyle = textStyle.merge(const TextStyle(fontStyle: FontStyle.italic));
      }
      if (attributes.containsKey('underline')) {
        textStyle = textStyle.merge(
          const TextStyle(decoration: TextDecoration.underline),
        );
      }
    }
    if (text.isEmpty) return [];
    return [
      TextSpan(text: text, style: textStyle),
    ];
  }

  String _convertNumberToEmoji(String text) {
    final RegExp numberRegex = RegExp(r'\(([\d]+)\)');
    return text.replaceAllMapped(numberRegex, (match) {
      final number = int.tryParse(match.group(1) ?? '');
      if (number != null && number >= 1 && number <= 10) {
        switch (number) {
          case 1:
            return '1️⃣';
          case 2:
            return '2️⃣';
          case 3:
            return '3️⃣';
          case 4:
            return '4️⃣';
          case 5:
            return '5️⃣';
          case 6:
            return '6️⃣';
          case 7:
            return '7️⃣';
          case 8:
            return '8️⃣';
          case 9:
            return '9️⃣';
          case 10:
            return '🔟';
        }
      }
      return match.group(0)!;
    });
  }

  void _addTextWithBoxCheck(
      List<InlineSpan> inlineSpans,
      String textSegment,
      Map<String, dynamic>? attributes,
      ) {
    TextStyle textStyle = const TextStyle(fontSize: 16, color: Colors.white);

    if (attributes != null) {
      if (attributes.containsKey('bold')) {
        textStyle = textStyle.merge(const TextStyle(fontWeight: FontWeight.bold));
      }
      if (attributes.containsKey('italic')) {
        textStyle = textStyle.merge(const TextStyle(fontStyle: FontStyle.italic));
      }
      if (attributes.containsKey('underline')) {
        textStyle = textStyle.merge(
          const TextStyle(decoration: TextDecoration.underline),
        );
      }
    }

    final bool hasBox = attributes?.containsKey(MyAttributes.box.key) ?? false;

    if (hasBox) {
      inlineSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              textSegment,
              style: textStyle,
            ),
          ),
        ),
      );
    } else {
      inlineSpans.add(
        TextSpan(
          text: textSegment,
          style: textStyle,
        ),
      );
    }
  }

  Widget _renderContent() {
    return StreamBuilder<DocChange>(
      stream: _controller.document.changes,
      builder: (context, snapshot) {
        final deltaOps = _controller.document.toDelta().toList();
        final List<_OpsGroup> groupedOps = [];

        for (final op in deltaOps) {
          if (op.value is! String) continue;

          final text = op.value as String;
          final opAttributes = op.attributes;

          if (groupedOps.isEmpty) {
            final group = _OpsGroup(opAttributes);
            group.append(text);
            groupedOps.add(group);
          } else {
            final lastGroup = groupedOps.last;
            final sameAttributes =
            _attributesEqual(lastGroup.attributes, opAttributes);

            if (sameAttributes) {
              lastGroup.append(text);
            } else {
              final group = _OpsGroup(opAttributes);
              group.append(text);
              groupedOps.add(group);
            }
          }
        }

        final allSpans = <InlineSpan>[];
        for (final group in groupedOps) {
          allSpans.addAll(_buildSpansForGroup(group));
        }

        if (allSpans.isEmpty) {
          return const Text(
            'No content to display.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.height / 2,
            maxWidth: double.infinity,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(children: allSpans),
            ),
          ),
        );
      },
    );
  }

  bool _attributesEqual(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  Widget _buildEditorContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        border: Border.all(width: 1, color: Colors.white),
      ),
      height: widget.height * 0.7,
      child: QuillEditor(
        controller: _controller,
        scrollController: _scrollController,
        focusNode: _focusNode,
        configurations: const QuillEditorConfigurations(
          padding: EdgeInsets.all(8.0),
          autoFocus: false,
          expands: false,
          scrollable: true,
        ),
      ),
    );
  }

  List<Widget> _textFieldWidgets() {
    return [
      Expanded(child: _buildEditorContent()),
      const Divider(),
      Expanded(child: _renderContent()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.simple(
          controller: _controller,
          configurations: QuillSimpleToolbarConfigurations(
            showFontFamily: false,
            showFontSize: false,
            showStrikeThrough: false,
            showInlineCode: false,
            showSubscript: false,
            showSuperscript: false,
            showClearFormat: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showHeaderStyle: false,
            showListNumbers: false,
            showListBullets: false,
            showListCheck: false,
            showCodeBlock: false,
            showQuote: false,
            showLink: false,
            showSearchButton: false,
            embedButtons: [
              // Math equation button
                  (controller, toolbarIconSize, iconTheme, dialogTheme) {
                return IconButton(
                  icon: const Icon(Icons.calculate),
                  iconSize: toolbarIconSize,
                  color: Colors.white,
                  onPressed: _insertMathEquation,
                );
              },
                  (controller, toolbarIconSize, iconTheme, dialogTheme) {
                return IconButton(
                  icon: const Icon(Icons.add_box),
                  iconSize: toolbarIconSize,
                  color: Colors.white,
                  onPressed: () {
                    final selectionStyle = _controller.getSelectionStyle();
                    final hasBox = selectionStyle.attributes
                        .containsKey(MyAttributes.box.key);
                    if (hasBox) {
                      _controller.formatSelection(
                        Attribute.clone(MyAttributes.box, null),
                      );
                    } else {
                      _controller.formatSelection(MyAttributes.box);
                    }
                  },
                );
              },
            ],
          ),
        ),
        widget.alignHorizontal
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _textFieldWidgets(),
        )
            : Column(
          children: _textFieldWidgets(),
        ),
      ],
    );
  }
}