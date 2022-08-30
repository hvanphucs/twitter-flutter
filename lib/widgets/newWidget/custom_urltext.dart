import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UrlText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextStyle? urlStyle;

  const UrlText({Key? key, this.text, this.style, this.urlStyle})
      : super(key: key);

  List<InlineSpan> getTextSpans() {
    List<InlineSpan> widgets = <InlineSpan>[];
    RegExp reg = RegExp(
        r"(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
    Iterable<Match> matches = reg.allMatches(text!);
    List<_ResultMatch> resultMatches = [];
    int start = 0;
    for (Match match in matches) {
      if (match.group(0)!.isNotEmpty) {
        if (start != match.start) {
          _ResultMatch result1 = _ResultMatch();
          result1.isUrl = false;
          result1.text = text!.substring(start, match.start);
          resultMatches.add(result1);
        }

        _ResultMatch result2 = _ResultMatch();
        result2.isUrl = true;
        result2.text = match.group(0)!;
        resultMatches.add(result2);
        start = match.end;
      }
    }
    if (start < text!.length) {
      _ResultMatch result1 = _ResultMatch();
      result1.isUrl = false;
      result1.text = text!.substring(start);
      resultMatches.add(result1);
    }

    for (var result in resultMatches) {
      if (result.isUrl == true) {
        widgets.add(_LinkTextSpan(
            text: result.text,
            style: urlStyle ?? const TextStyle(color: Colors.blue)));
      } else {
        widgets.add(TextSpan(
            text: result.text,
            style: style ?? const TextStyle(color: Colors.black)));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: getTextSpans()),
    );
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle? style, String? text})
      : super(
            style: style,
            text: text,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                //launchURL(text);
              });
}

class _ResultMatch {
  bool? isUrl;
  String? text;
}
