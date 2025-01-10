import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:core';

class TextFieldWidget extends StatefulWidget {
  final bool alignHorizontal;
  final double height; // Add height parameter

  const TextFieldWidget({
    super.key,
    required this.alignHorizontal,
    required this.height, // Make height required
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final QuillController _controller = QuillController.basic();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(debugLabel: 'QuillEditorFocusNode');

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _insertMathEquation() async {
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    final selection = _controller.selection;
    final int index =
    selection.isValid ? selection.baseOffset : _controller.document.length;

    const String mathPlaceholder = '[Math:]';
    _controller.replaceText(
      index,
      0,
      mathPlaceholder,
      TextSelection.collapsed(offset: index + '[Math:'.length),
    );
  }

  Widget _buildEditorContent() {
    return SizedBox(
      height: widget.height / 2, // Dynamically use half the height
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
        final RegExp mathRegex = RegExp(r'\[Math:(.+?)\]');
        final List<InlineSpan> inlineSpans = [];

        for (final operation in _controller.document.toDelta().toList()) {
          if (operation.value is String) {
            final String text = operation.value as String;
            final Iterable<RegExpMatch> matches = mathRegex.allMatches(text);

            int currentIndex = 0;
            for (final match in matches) {
              if (match.start > currentIndex) {
                final regularText = text.substring(currentIndex, match.start);
                inlineSpans.add(
                  TextSpan(
                    text: regularText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
              final remainingText = text.substring(currentIndex);
              inlineSpans.add(
                TextSpan(
                  text: remainingText,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }
          }
        }

        if (inlineSpans.isEmpty) {
          return const Text(
            'No content to display.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.height / 2, // Dynamically use half the height
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