import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatGPTStyleRenderer extends StatefulWidget {
  final String message;
  final String strFontName;
  final String? messageIdForAssistant;

  final bool isStreaming;

  const ChatGPTStyleRenderer({
    super.key,
    required this.message,
    required this.strFontName,
    required this.messageIdForAssistant,
    this.isStreaming = false,
  });

  @override
  State<ChatGPTStyleRenderer> createState() => _ChatGPTStyleRendererState();
}

class _ChatGPTStyleRendererState extends State<ChatGPTStyleRenderer> {
  final Map<String, bool> _copiedStates = {};

  // Create a transparent version of vs2015 theme
  Map<String, TextStyle> _getTransparentTheme() {
    final theme = Map<String, TextStyle>.from(vs2015Theme);
    // Remove any background color from the theme
    theme['root'] = TextStyle(
      backgroundColor: Colors.transparent,
      color: Colors.white.withOpacity(0.95),
    );
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 1, minWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _parseAndRender(widget.message),
      ),
    );
  }

  List<Widget> _parseAndRender(String text) {
    if (text.isEmpty) return [];

    final List<Widget> widgets = [];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle code blocks (```language)
      if (line.startsWith('```')) {
        final codeBlock = _extractCodeBlock(lines, i);
        if (codeBlock != null) {
          widgets.add(
            _buildCodeBlock(
              codeBlock['code']!,
              codeBlock['language']!,
              widget.messageIdForAssistant,
            ),
          );
          i = codeBlock['endIndex']!;
          continue;
        }
      }

      // Handle multi-line math blocks (\[ ... \])
      // Handle single-line display math \[ ... \]
      if (line.trim().startsWith(r'\[') && line.trim().endsWith(r'\]')) {
        final mathContent =
            line
                .trim()
                .substring(2, line.trim().length - 2)
                .trim(); // remove \[ and \]
        widgets.add(_buildMathBlock(mathContent)); // show in block
        continue;
      }

      // Optional: handle inline math \(...\) within text
      final inlineMathRegex = RegExp(r'\\\((.+?)\\\)');
      final inlineMatches = inlineMathRegex.allMatches(line);
      if (inlineMatches.isNotEmpty) {
        int lastIndex = 0;
        for (final match in inlineMatches) {
          final before = line.substring(lastIndex, match.start).trim();
          if (before.isNotEmpty) widgets.add(_buildParagraph(before));

          final mathContent = match.group(1)!.trim();
          widgets.add(_buildMathBlock(mathContent));

          lastIndex = match.end;
        }
        if (lastIndex < line.length) {
          final remaining = line.substring(lastIndex).trim();
          if (remaining.isNotEmpty) widgets.add(_buildParagraph(remaining));
        }
        continue;
      }

      // Handle multi-line math blocks ($$)
      if (line.trim().startsWith('\$\$')) {
        final mathBlock = _extractMathBlock(lines, i, '\$\$', '\$\$');
        if (mathBlock != null) {
          widgets.add(_buildMathBlock(mathBlock['content']!));
          i = mathBlock['endIndex']!;
          continue;
        }
      }

      // Handle single-line math blocks
      if (line.trim().startsWith(r'\[') && line.trim().endsWith(r'\]')) {
        final mathContent =
            line.trim().substring(2, line.trim().length - 2).trim();
        widgets.add(_buildMathBlock(mathContent));
        continue;
      }

      if (line.trim().startsWith('\$\$') && line.trim().endsWith('\$\$')) {
        final mathContent = line.trim().substring(2, line.trim().length - 2);
        widgets.add(_buildMathBlock(mathContent));
        continue;
      } // Handle lists

      if (_isListItem(line)) {
        final list = _extractList(lines, i);
        if (list != null) {
          widgets.add(_buildList(list['items']!, list['isOrdered']!));
          i = list['endIndex']!;
          continue;
        }
      }

      // Handle tables
      if (line.contains('|') && _isTableRow(line)) {
        final table = _extractTable(lines, i);
        if (table != null) {
          widgets.add(_buildTable(table['rows']!, context));
          i = table['endIndex']!;
          continue;
        }
      }

      // Handle JSON blocks
      if (line.trim().startsWith('{') || line.trim().startsWith('[')) {
        final jsonBlock = _extractJsonBlock(lines, i);
        if (jsonBlock != null) {
          widgets.add(
            _buildCodeBlock(
              jsonBlock['content']!,
              'json',
              widget.messageIdForAssistant,
            ),
          );
          i = jsonBlock['endIndex']!;
          continue;
        }
      }

      // Handle headers
      if (line.startsWith('#')) {
        widgets.add(_buildHeader(line));
        continue;
      }

      // Handle horizontal rules
      if (line.trim() == '---' || line.trim() == '***') {
        widgets.add(_buildHorizontalRule());
        continue;
      }

      // Handle block quotes
      if (line.startsWith('>')) {
        final quote = _extractBlockQuote(lines, i);
        if (quote != null) {
          widgets.add(_buildBlockQuote(quote['content']!));
          i = quote['endIndex']!;
          continue;
        }
      }

      // Handle regular paragraphs with inline formatting
      if (line.trim().isNotEmpty) {
        widgets.add(_buildParagraph(line));
      } else {
        widgets.add(SizedBox(height: 8)); // Empty line spacing
      }
    }

    return widgets;
  }

  Widget _buildCodeBlock(
    String code,
    String language,
    String? messageIdForAssistant,
  ) {
    final codeId = DateTime.now().millisecondsSinceEpoch.toString();
    final isCopied = _copiedStates[messageIdForAssistant] ?? false;

    // Map language names to highlight.js identifiers
    final mappedLanguage = _mapLanguageName(language);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language and copy button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.isNotEmpty ? language.toLowerCase() : 'code',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap:
                      () =>
                          _copyToClipboard(code, codeId, messageIdForAssistant),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCopied ? Icons.check : Icons.copy,
                          size: 14,
                          color:
                              isCopied
                                  ? Colors.green
                                  : Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(width: 4),
                        Text(
                          isCopied ? 'Copied!' : 'Copy',
                          style: TextStyle(
                            color:
                                isCopied
                                    ? Colors.green
                                    : Colors.white.withOpacity(0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content with syntax highlighting
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            child: HighlightView(
              code,
              language: mappedLanguage,
              theme: _getTransparentTheme(),
              padding: EdgeInsets.zero,
              textStyle: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'SF Mono',
                height: 1.4,
                color: Colors.white.withOpacity(
                  0.95,
                ), // High contrast for readability
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Map common language names to highlight.js identifiers
  String _mapLanguageName(String language) {
    final lang = language.toLowerCase().trim();

    // Common language mappings
    switch (lang) {
      case 'js':
      case 'javascript':
        return 'javascript';
      case 'ts':
      case 'typescript':
        return 'typescript';
      case 'py':
      case 'python':
        return 'python';
      case 'java':
        return 'java';
      case 'c':
        return 'c';
      case 'cpp':
      case 'c++':
        return 'cpp';
      case 'cs':
      case 'csharp':
      case 'c#':
        return 'csharp';
      case 'php':
        return 'php';
      case 'rb':
      case 'ruby':
        return 'ruby';
      case 'go':
      case 'golang':
        return 'go';
      case 'rs':
      case 'rust':
        return 'rust';
      case 'kt':
      case 'kotlin':
        return 'kotlin';
      case 'swift':
        return 'swift';
      case 'dart':
        return 'dart';
      case 'sql':
      case 'mysql':
      case 'postgresql':
      case 'sqlite':
        return 'sql';
      case 'json':
        return 'json';
      case 'xml':
        return 'xml';
      case 'html':
        return 'xml'; // HTML is handled by XML highlighter
      case 'css':
        return 'css';
      case 'scss':
      case 'sass':
        return 'scss';
      case 'md':
      case 'markdown':
        return 'markdown';
      case 'yaml':
      case 'yml':
        return 'yaml';
      case 'bash':
      case 'shell':
      case 'sh':
        return 'bash';
      case 'powershell':
      case 'ps1':
        return 'powershell';
      case 'dockerfile':
      case 'docker':
        return 'dockerfile';
      case 'makefile':
      case 'make':
        return 'makefile';
      case 'r':
        return 'r';
      case 'matlab':
        return 'matlab';
      case 'tex':
      case 'latex':
        return 'latex';
      case 'diff':
        return 'diff';
      case 'ini':
        return 'ini';
      case 'toml':
        return 'toml';
      case 'perl':
        return 'perl';
      case 'lua':
        return 'lua';
      case 'scala':
        return 'scala';
      case 'clojure':
        return 'clojure';
      case 'haskell':
        return 'haskell';
      case 'erlang':
        return 'erlang';
      case 'elixir':
        return 'elixir';
      case 'f#':
      case 'fsharp':
        return 'fsharp';
      case 'vb':
      case 'vbnet':
        return 'vbnet';
      case 'apache':
        return 'apache';
      case 'nginx':
        return 'nginx';
      default:
        // Return the original language if no mapping found
        return lang.isNotEmpty ? lang : 'plaintext';
    }
  }

  Widget _buildMathBlock(String mathContent) {
    print('mathContent: $mathContent');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // flat dark gray like OneBrain
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Center(child: _buildMathWidget(mathContent)),
    );
  }

  Widget _buildMathWidget(String mathContent) {
    print('mathContent in buildMathWidget: $mathContent');
    try {
      final cleanedContent = _cleanMathContent(mathContent);
      return Math.tex(
        cleanedContent,
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        mathStyle: MathStyle.display,
      );
    } catch (e) {
      // Fallback for LaTeX error
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[900]?.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Math Error: $mathContent',
          style: TextStyle(
            color: Colors.red[300],
            fontSize: 14.sp,
            fontFamily: 'SF Mono',
          ),
        ),
      );
    }
  }

  String _cleanMathContent(String content) {
    print('Original math content: $content');
    String cleaned = content.trim();

    // Simplify LaTeX adjustments
    cleaned = cleaned.replaceAll(r'\text{', r'\mathrm{');
    cleaned = cleaned.replaceAll(r'\\', r'\\\\');
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'([a-zA-Z])_{([^}]+)}'),
      (m) => '${m.group(1)}_{${m.group(2)}}',
    );

    return cleaned;
  }

  // Widget _buildTable(List<List<String>> rows, BuildContext context) {
  //   if (rows.isEmpty) return Container();

  //   print(rows);
  //   print(rows.length);
  //   for (int i = 0; i < rows.length; i++) {
  //     print(rows[i].length);
  //   }

  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 8.0),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[900]?.withOpacity(0.3),
  //       border: Border.all(color: Colors.grey[700]!, width: 1),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Container(
  //         constraints: BoxConstraints(
  //           minWidth: MediaQuery.of(context).size.width - 32,
  //         ),
  //         child: Table(
  //           border: TableBorder.all(color: Colors.grey[600]!, width: 0.5),
  //           columnWidths: _generateColumnWidths(rows),
  //           children:
  //               rows.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final row = entry.value;
  //                 final isHeader = index == 0;

  //                 return TableRow(
  //                   decoration:
  //                       isHeader
  //                           ? BoxDecoration(
  //                             color: Colors.grey[800]?.withValues(alpha: 0.7),
  //                           )
  //                           : null,
  //                   children:
  //                       row
  //                           .map(
  //                             (cell) => Container(
  //                               padding: EdgeInsets.all(12),
  //                               child: _buildTableCell(cell.trim(), isHeader),
  //                             ),
  //                           )
  //                           .toList(),
  //                 );
  //               }).toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTable(List<List<String>> rows, BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    // Normalize all rows to the same column count
    final int columnCount = rows
        .map((r) => r.length)
        .fold(0, (a, b) => a > b ? a : b);
    final normalizedRows =
        rows.map((r) {
          if (r.length < columnCount) {
            return [...r, ...List.generate(columnCount - r.length, (_) => '')];
          }
          return r;
        }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 32,
          ),
          child: Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey[600]!, width: 0.5),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: _generateColumnWidths(normalizedRows),
            children:
                normalizedRows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final isHeader = index == 0;

                  return TableRow(
                    decoration: BoxDecoration(
                      color:
                          isHeader
                              ? Colors.grey[800]?.withOpacity(0.7)
                              : index.isEven
                              ? Colors.transparent
                              : Colors.transparent,
                    ),
                    children:
                        row.map((cell) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: _buildTableCell(cell.trim(), isHeader),
                          );
                        }).toList(),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String cellContent, bool isHeader) {
    final cleanedContent = cellContent.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );

    final baseStyle = TextStyle(
      color: isHeader ? Colors.white : Colors.white.withOpacity(0.9),
      fontSize: isHeader ? 14.sp : 13.sp,
      fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
      height: 1.4,
    );

    return SelectableText.rich(
      TextSpan(style: baseStyle, children: _parseInlineStyles(cleanedContent)),
      textAlign: TextAlign.left,
    );
  }

  // Widget _buildTableCell(String cellContent, bool isHeader) {
  //   if (isHeader) {
  //     return SelectableText.rich(
  //       TextSpan(
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 14.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //         children: _parseInlineStyles(cellContent),
  //       ),
  //       textAlign: TextAlign.left,
  //     );
  //   } else {
  //     return SelectableText.rich(
  //       TextSpan(
  //         style: TextStyle(
  //           color: Colors.white.withOpacity(0.9),
  //           fontSize: 13.sp,
  //           fontWeight: FontWeight.w400,
  //         ),
  //         children: _parseInlineStyles(cellContent),
  //       ),
  //       textAlign: TextAlign.left,
  //     );
  //   }
  // }

  // Map<int, TableColumnWidth> _generateColumnWidths(List<List<String>> rows) {
  //   final columnWidths = <int, TableColumnWidth>{};
  //   if (rows.isEmpty) return columnWidths;

  //   final columnCount = rows.first.length;
  //   for (int i = 0; i < columnCount; i++) {
  //     columnWidths[i] = FixedColumnWidth(120);
  //   }
  //   return columnWidths;
  // }
  Map<int, TableColumnWidth> _generateColumnWidths(List<List<String>> rows) {
    if (rows.isEmpty) return {};
    final columnCount = rows
        .map((r) => r.length)
        .fold(0, (a, b) => a > b ? a : b);
    return {
      for (int i = 0; i < columnCount; i++) i: const IntrinsicColumnWidth(),
    };
  }

  Widget _buildHeader(String line) {
    final level = line.indexOf(' ');
    final text = line.substring(level + 1);
    final fontSize =
        level > 0
            ? [
                  24.0,
                  20.0,
                  18.0,
                  16.0,
                  14.0,
                  12.0,
                ].elementAtOrNull(level - 1)?.sp ??
                16.0.sp
            : 16.0.sp;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildList(List<String> items, bool isOrdered) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final prefix = isOrdered ? '${index + 1}.' : '•';

              return Padding(
                padding: EdgeInsets.only(bottom: 6.0, left: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      child: Text(
                        prefix,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 1),
                        child: _buildInlineText(item),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBlockQuote(String content) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.3),
        border: Border(left: BorderSide(color: Colors.grey[600]!, width: 4)),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: _buildInlineText(content),
    );
  }

  Widget _buildHorizontalRule() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      height: 1,
      decoration: BoxDecoration(color: Colors.grey[700]),
    );
  }

  Widget _buildParagraph(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: _buildInlineText(text),
    );
  }

  List<InlineSpan> _parseInlineWithMath(String text) {
    final spans = <InlineSpan>[];

    // Match either \[...\] or $...$
    final regex = RegExp(r'(\\\[.*?\\\]|\$.*?\$)');

    int currentIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > currentIndex) {
        String subText = text.substring(currentIndex, match.start);
        // Add normal text before formula
        spans.add(
          TextSpan(
            text: subText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      final raw = match.group(0) ?? "";
      String mathContent;

      if (raw.startsWith(r'\[') && raw.endsWith(r'\]')) {
        mathContent = raw.substring(2, raw.length - 2).trim();
      } else if (raw.startsWith(r'$') && raw.endsWith(r'$')) {
        mathContent = raw.substring(1, raw.length - 1).trim();
      } else {
        mathContent = raw;
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(
            mathContent,
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );

      currentIndex = match.end;
    }

    // Add leftover normal text
    if (currentIndex < text.length) {
      final bool isBold = text.startsWith('**');

      if (isBold) {
        text = text.replaceAll("**", "");
      }
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: TextStyle(
            color: Colors.white,
            fontSize: isBold ? 17.sp : null,
            fontWeight: isBold ? FontWeight.w700 : null,
          ),
        ),
      );
    }

    return spans;
  }

  Widget _buildInlineText(String text) {
    final spans = _parseInlineWithMath(text);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SelectableText.rich(
        TextSpan(
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Text',
            height: 1.6,
          ),
          children: spans,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  List<InlineSpan> _parseInlineStyles(String text) {
    final List<InlineSpan> spans = [];

    // NOTE: changed \( ... \) part to (.+?) so it can include ')'
    final RegExp pattern = RegExp(
      r'(\*\*[^*]+\*\*|\*[^*]+\*|_[^_]+_|~~[^~]+~~|`[^`]+`|\$[^$]+\$|\\\((.+?)\\\)|\[([^\]]+)\]\(([^)]+)\))',
    );

    int currentIndex = 0;
    final matches = pattern.allMatches(text);

    for (final match in matches) {
      // Add plain text before match
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }

      final matchText = match.group(0)!;

      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        // **bold**
        spans.add(
          TextSpan(
            text: matchText.substring(2, matchText.length - 2),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        );
      } else if (matchText.startsWith('*') && matchText.endsWith('*')) {
        // *italic*
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (matchText.startsWith('_') && matchText.endsWith('_')) {
        // _italic_
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (matchText.startsWith('~~') && matchText.endsWith('~~')) {
        // ~~strike~~
        spans.add(
          TextSpan(
            text: matchText.substring(2, matchText.length - 2),
            style: const TextStyle(decoration: TextDecoration.lineThrough),
          ),
        );
      } else if (matchText.startsWith('`') && matchText.endsWith('`')) {
        // `code`
        spans.add(
          TextSpan(
            text: matchText.substring(1, matchText.length - 1),
            style: const TextStyle(
              fontFamily: 'monospace',
              backgroundColor: Color(0xFF2E2E2E),
            ),
          ),
        );
      } else if (matchText.startsWith(r'\(') && matchText.endsWith(r'\)')) {
        final mathContent = matchText.substring(2, matchText.length - 2);
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              mathContent,
              textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        );
      } else if (matchText.startsWith('\$') && matchText.endsWith('\$')) {
        // $ ... $  (inline math dollars)
        final mathContent = matchText.substring(1, matchText.length - 1);
        spans.add(_buildInlineMathSpan(mathContent));
      } else if (matchText.startsWith(r'\(') && matchText.endsWith(r'\)')) {
        // \( ... \)  (inline LaTeX)
        final mathContent = matchText.substring(2, matchText.length - 2);
        spans.add(_buildInlineMathSpan(mathContent));
      } else if (matchText.contains('](')) {
        // [text](url)
        final linkMatch = RegExp(
          r'\[([^\]]+)\]\(([^)]+)\)',
        ).firstMatch(matchText);
        if (linkMatch != null) {
          final linkText = linkMatch.group(1)!;
          final linkUrl = linkMatch.group(2)!;
          spans.add(
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                decoration: TextDecoration.underline,
              ),
              recognizer:
                  TapGestureRecognizer()..onTap = () => _launchUrl(linkUrl),
            ),
          );
        } else {
          spans.add(TextSpan(text: matchText));
        }
      } else {
        spans.add(TextSpan(text: matchText));
      }

      currentIndex = match.end;
    }

    // Add any trailing text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }

  TextSpan _buildInlineMathSpan(String mathContent) {
    try {
      // For inline math, we'll use a styled text approach since TextSpan doesn't support widgets
      return TextSpan(
        text: mathContent,
        style: TextStyle(
          fontFamily: 'SF Mono',
          fontSize: 14.sp,
          backgroundColor: Colors.blue[900]?.withOpacity(0.6),
          color: Colors.blue[200],
          fontStyle: FontStyle.italic,
        ),
      );
    } catch (e) {
      return TextSpan(
        text: mathContent,
        style: TextStyle(
          fontFamily: 'SF Mono',
          fontSize: 14.sp,
          backgroundColor: Colors.red[900]?.withOpacity(0.6),
          color: Colors.red[200],
        ),
      );
    }
  }

  // Helper methods for parsing different content types
  Map<String, dynamic>? _extractCodeBlock(List<String> lines, int startIndex) {
    final startLine = lines[startIndex];
    String language = startLine.substring(3).trim();

    // If no language specified, try to auto-detect from content
    if (language.isEmpty) {
      language = _detectLanguageFromContent(lines, startIndex);
    }

    for (int i = startIndex + 1; i < lines.length; i++) {
      if (lines[i].startsWith('```')) {
        final code = lines.sublist(startIndex + 1, i).join('\n');
        return {'code': code, 'language': language, 'endIndex': i};
      }
    }
    return null;
  }

  /// Auto-detect language from code content
  String _detectLanguageFromContent(List<String> lines, int startIndex) {
    if (startIndex + 1 >= lines.length) return '';

    // Get the first few lines of code content
    final codeLines = <String>[];
    for (int i = startIndex + 1; i < lines.length && i < startIndex + 6; i++) {
      if (lines[i].startsWith('```')) break;
      codeLines.add(lines[i].trim());
    }

    final codeContent = codeLines.join('\n').toLowerCase();

    // JSON detection
    if (codeContent.contains('{') &&
        codeContent.contains('}') &&
        (codeContent.contains('"') || codeContent.contains('['))) {
      if (codeContent.startsWith('{') || codeContent.startsWith('[')) {
        return 'json';
      }
    }

    // SQL detection
    if (codeContent.contains('select ') ||
        codeContent.contains('insert ') ||
        codeContent.contains('update ') ||
        codeContent.contains('delete ') ||
        codeContent.contains('create table') ||
        codeContent.contains('alter table') ||
        codeContent.contains('from ') ||
        codeContent.contains('where ')) {
      return 'sql';
    }

    // XML/HTML detection
    if (codeContent.contains('<') &&
        codeContent.contains('>') &&
        (codeContent.contains('</') || codeContent.contains('/>'))) {
      if (codeContent.contains('<!doctype html') ||
          codeContent.contains('<html')) {
        return 'html';
      }
      return 'xml';
    }

    // CSS detection
    if (codeContent.contains('{') &&
        codeContent.contains('}') &&
        (codeContent.contains(':') &&
            (codeContent.contains('px') ||
                codeContent.contains('color') ||
                codeContent.contains('margin')))) {
      return 'css';
    }

    // JavaScript detection
    if (codeContent.contains('function') ||
        codeContent.contains('const ') ||
        codeContent.contains('let ') ||
        codeContent.contains('var ') ||
        codeContent.contains('=>') ||
        codeContent.contains('console.log')) {
      return 'javascript';
    }

    // Python detection
    if (codeContent.contains('def ') ||
        codeContent.contains('import ') ||
        codeContent.contains('from ') ||
        codeContent.contains('print(') ||
        codeContent.contains('if __name__')) {
      return 'python';
    }

    // Shell/Bash detection
    if (codeContent.startsWith('#!/bin/bash') ||
        codeContent.startsWith('#!/bin/sh') ||
        codeContent.contains('echo ') ||
        codeContent.contains('export ') ||
        codeContent.contains('cd ') ||
        codeContent.contains('ls ')) {
      return 'bash';
    }

    // YAML detection
    if (codeContent.contains('---') ||
        (codeContent.contains(':') &&
            !codeContent.contains(';') &&
            !codeContent.contains('{'))) {
      return 'yaml';
    }

    return 'plaintext';
  }

  bool _isTableRow(String line) {
    final trimmed = line.trim();
    if (!trimmed.contains('|')) return false;

    // Skip separator rows like |-------------|-----------|-------|
    if (RegExp(r'^\|?\s*[-:]+\s*(\|\s*[-:]+\s*)*\|?$').hasMatch(trimmed)) {
      return false;
    }

    // Check if it's a valid table row (has at least 2 columns)
    final parts = trimmed.split('|');
    final nonEmptyParts =
        parts.where((part) => part.trim().isNotEmpty).toList();

    return nonEmptyParts.length >= 2;
  }

  Map<String, dynamic>? _extractTable(List<String> lines, int startIndex) {
    final rows = <List<String>>[];
    int i = startIndex;

    while (i < lines.length && lines[i].trim().isNotEmpty) {
      final line = lines[i].trim();

      // Skip separator rows like |-------------|-----------|-------|
      if (line.contains('|') &&
          RegExp(r'^\|?\s*[-:]+\s*(\|\s*[-:]+\s*)*\|?$').hasMatch(line)) {
        i++;
        continue;
      }

      if (_isTableRow(line)) {
        final cells =
            line
                .split('|')
                .map((cell) => cell.trim())
                .where((cell) => cell.isNotEmpty)
                .toList();
        if (cells.isNotEmpty) {
          rows.add(cells);
        }
      } else {
        // End of table
        break;
      }
      i++;
    }

    if (rows.isNotEmpty) {
      return {'rows': rows, 'endIndex': i - 1};
    }
    return null;
  }

  // Helper method to extract JSON blocks
  Map<String, dynamic>? _extractJsonBlock(List<String> lines, int startIndex) {
    final content = <String>[];
    int i = startIndex;
    int braceCount = 0;
    int bracketCount = 0;
    bool inString = false;
    bool escaped = false;

    while (i < lines.length) {
      final line = lines[i];
      content.add(line);

      // Count braces and brackets to find the end of JSON
      for (int j = 0; j < line.length; j++) {
        final char = line[j];

        if (escaped) {
          escaped = false;
          continue;
        }

        if (char == '\\') {
          escaped = true;
          continue;
        }

        if (char == '"' && !escaped) {
          inString = !inString;
          continue;
        }

        if (!inString) {
          if (char == '{')
            braceCount++;
          else if (char == '}')
            braceCount--;
          else if (char == '[')
            bracketCount++;
          else if (char == ']')
            bracketCount--;
        }
      }

      // Check if we've closed all braces/brackets
      if (i > startIndex && braceCount == 0 && bracketCount == 0) {
        final jsonContent = content.join('\n');
        // Validate if it's actually JSON-like
        if (_looksLikeJson(jsonContent)) {
          return {'content': jsonContent, 'endIndex': i};
        }
      }

      i++;

      // Safety check - don't go beyond reasonable JSON size
      if (i - startIndex > 50) break;
    }

    return null;
  }

  bool _looksLikeJson(String content) {
    final trimmed = content.trim();
    return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'));
  }

  bool _isListItem(String line) {
    final trimmed = line.trim();
    return trimmed.startsWith('- ') ||
        trimmed.startsWith('* ') ||
        trimmed.startsWith('+ ') ||
        RegExp(r'^\d+\.\s').hasMatch(trimmed);
  }

  Map<String, dynamic>? _extractList(List<String> lines, int startIndex) {
    final items = <String>[];
    int i = startIndex;
    bool isOrdered = RegExp(r'^\d+\.\s').hasMatch(lines[startIndex].trim());

    while (i < lines.length && _isListItem(lines[i])) {
      final line = lines[i].trim();
      String item;
      if (isOrdered) {
        item = line.replaceFirst(RegExp(r'^\d+\.\s'), '');
      } else {
        item = line.replaceFirst(RegExp(r'^[-*+]\s'), '');
      }
      items.add(item);
      i++;
    }

    if (items.isNotEmpty) {
      print('Extracted list: ${items.join(', ')} - Ordered: $isOrdered');
      return {'items': items, 'isOrdered': isOrdered, 'endIndex': i - 1};
    }
    return null;
  }

  Map<String, dynamic>? _extractBlockQuote(List<String> lines, int startIndex) {
    final content = <String>[];
    int i = startIndex;

    while (i < lines.length && lines[i].startsWith('>')) {
      content.add(lines[i].substring(1).trim());
      i++;
    }

    if (content.isNotEmpty) {
      return {'content': content.join('\n'), 'endIndex': i - 1};
    }
    return null;
  }

  void _copyToClipboard(
    String text,
    String id,
    String? messageIdForAssistant,
  ) async {
    setState(() {
      _copiedStates[messageIdForAssistant ?? id] = true;
    });
    await Clipboard.setData(ClipboardData(text: text));

    // Reset after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copiedStates[messageIdForAssistant ?? id] = false;
        });
      }
    });
  }

  // Helper method to extract multi-line math blocks
  Map<String, dynamic>? _extractMathBlock(
    List<String> lines,
    int startIndex,
    String startDelim,
    String endDelim,
  ) {
    final content = <String>[];
    int i = startIndex;

    // Check if it's a single line block
    final startLine = lines[startIndex].trim();
    if (startLine.startsWith(startDelim) && startLine.endsWith(endDelim)) {
      final mathContent =
          startLine
              .substring(startDelim.length, startLine.length - endDelim.length)
              .trim();
      return {'content': mathContent, 'endIndex': startIndex};
    }

    // Multi-line block
    if (startLine.startsWith(startDelim)) {
      // Add content from first line if any
      final firstLineContent = startLine.substring(startDelim.length).trim();
      if (firstLineContent.isNotEmpty && !firstLineContent.endsWith(endDelim)) {
        content.add(firstLineContent);
      }

      i++;
      while (i < lines.length) {
        final line = lines[i].trim();
        if (line.endsWith(endDelim)) {
          // Found end delimiter
          final lastLineContent =
              line.substring(0, line.length - endDelim.length).trim();
          if (lastLineContent.isNotEmpty) {
            content.add(lastLineContent);
          }
          return {'content': content.join('\n'), 'endIndex': i};
        } else {
          content.add(line);
        }
        i++;
      }
    }

    return null;
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
