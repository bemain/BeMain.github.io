import 'package:flutter/material.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article_list.dart';
import 'package:portfolio/writing/article_pane.dart';
import 'package:portfolio/writing/writing_scaffold.dart';

class WritingPage extends StatelessWidget {
  const WritingPage({
    super.key,
    this.article,
  });

  /// The article that is currently open, if any.
  final Article? article;

  @override
  Widget build(BuildContext context) {
    return WritingScaffold(
      body: Padding(
        padding: WindowSize.of(context).padding,
        child: <Widget>() {
          switch (WindowSize.of(context)) {
            case WindowSize.compact:
            case WindowSize.medium:
            case WindowSize.expanded:
              return article != null
                  ? ArticlePane(article: article)
                  : ArticleList();

            case WindowSize.large:
            case WindowSize.extraLarge:
              return Row(
                children: [
                  ArticleList(),
                  SizedBox(width: 24),
                  Expanded(
                    child: Card(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ArticlePane(article: article),
                      ),
                    ),
                  ),
                ],
              );
          }
        }(),
      ),
    );
  }
}
