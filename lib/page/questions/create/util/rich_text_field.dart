import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import'package:flutter_quill/flutter_quill.dart';
import 'dart:core';

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
    _controller.document.changes.listen((_) {
      final String deltaString = jsonEncode(_controller.document.toDelta().toJson());
      widget.onContentChanged(deltaString);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();}

  Future<void> _insertMathEquation() async {
    if (!_focusNode.hasFocus && _controller.selection.isValid) {
      _focusNode.requestFocus();
    }

    final selection = _controller.selection;
    final int index = selection.isValid ? selection.baseOffset : _controller.document.length;

    const String mathPlaceholder = '[:]';
    _controller.replaceText(
      index,
      0,
      mathPlaceholder,
      TextSelection.collapsed(offset: index + '[:'.length),
    );
  }

  String _convertNumberToEmoji(String text) {
    final RegExp numberRegex = RegExp(r'\(([\d]+)\)');
    return text.replaceAllMapped(numberRegex, (match) {
      final number = int.tryParse(match.group(1) ?? '');
      if (number != null && number >= 1 && number <= 10) {
        // Only convert numbers 1-10
        switch (number) {
          case 1:
            return '1️⃣';
          case 2:return '2️⃣';
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
          default:
            return match.group(0)!; // Return original if not in range
        }
      }
      return match.group(0)!; // Return original if not a number
    });
  }

  Widget _buildEditorContent() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          border: Border.all(width: 1, color: Colors.white)),
      height: widget.height * 0.7,
      child: QuillEditor(
        controller: _controller,
        scrollController: _scrollController,
        focusNode: _focusNode,
        configurations: QuillEditorConfigurations(
          padding: const EdgeInsets.all(8.0),
          autoFocus: false,
          expands: false,
          scrollable: true,
        ),
      ),
    );
  }

  Widget _renderContent() {
    return StreamBuilder<DocChange>(
      stream: _controller.document.changes,
      builder: (context, snapshot) {
        final List<InlineSpan> inlineSpans = [];

        for (final operation in _controller.document.toDelta().toList()) {
          if (operation.value is String) {
            String text = operation.value as String;
            final Map<String, dynamic>? attributes = operation.attributes;

            // Convert numbers in parentheses to emojis
            text = _convertNumberToEmoji(text);

            // Define the regex to detect LaTeX equations
            final RegExp mathRegex = RegExp(r'\[:(.+?)\]');
            final Iterable<RegExpMatch> matches = mathRegex.allMatches(text);

            int currentIndex = 0;

            for (final match in matches) {
              if (match.start > currentIndex) {final String regularText =
              text.substring(currentIndex, match.start);
              TextStyle textStyle =
              const TextStyle(fontSize: 16, color: Colors.white);

              if (attributes != null) {
                if (attributes.containsKey('bold')) {
                  textStyle = textStyle
                      .merge(const TextStyle(fontWeight: FontWeight.bold));
                }
                if (attributes.containsKey('italic')) {
                  textStyle = textStyle
                      .merge(const TextStyle(fontStyle: FontStyle.italic));
                }
                if (attributes.containsKey('underline')) {
                  textStyle = textStyle.merge(
                      const TextStyle(decoration: TextDecoration.underline));
                }
              }

              inlineSpans.add(
                TextSpan(
                  text: regularText,
                  style: textStyle,
                ),
              );
              }

              final String latex = match.group(1) ?? '';
              inlineSpans.add(
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

            if (currentIndex < text.length) {
              final String remainingText = text.substring(currentIndex);
              TextStyle textStyle =
              const TextStyle(fontSize: 16, color: Colors.white);

              if (attributes != null) {
                if (attributes.containsKey('bold')) {
                  textStyle = textStyle
                      .merge(const TextStyle(fontWeight: FontWeight.bold));
                }
                if (attributes.containsKey('italic')) {
                  textStyle = textStyle
                      .merge(const TextStyle(fontStyle: FontStyle.italic));
                }
                if (attributes.containsKey('underline')) {
                  textStyle = textStyle.merge(
                      const TextStyle(decoration: TextDecoration.underline));
                }
              }

              inlineSpans.add(
                TextSpan(
                  text: remainingText,
                  style: textStyle,
                ),
              );
            }
          }
        }

        if (inlineSpans.isEmpty) {
          return const Text(
            'No content to display.',style: TextStyle(fontSize: 16, color: Colors.white),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.height / 2,
            maxWidth: double.infinity,
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              text: TextSpan(children: inlineSpans),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _textFieldWidgets() {
    return [
      Expanded(
        child: _buildEditorContent(),
      ),
      const Divider(),
      Expanded(
        child: _renderContent(),
      ),
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
                  (controller, toolbarIconSize, iconTheme, dialogTheme) {
                return IconButton(
                  icon: const Icon(Icons.calculate),
                  iconSize: toolbarIconSize,
                  color: Colors.white,
                  onPressed: _insertMathEquation,
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