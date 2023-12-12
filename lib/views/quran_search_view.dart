import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import '../../../widgets/custom_search_bar.dart';
import '../controllers/quran_search_controller.dart';
import '../widgets/surah_verse.dart';

class QuranSearchView extends GetView<QuranSearchController> {
  const QuranSearchView({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text(
            'بحث في القرآن',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // CustomSearchBar for user input
              CustomSearchBar(
                onChanged: controller.onSearchTextChanged,
                hintText: 'ابحث عن آية ...',
              ),
              const SizedBox(height: 10),
              // Obx for reacting to changes in the search results
              Obx(() {
                final searchResults = controller.searchResults;
                if (searchResults.isEmpty && controller.searchText != '') {
                  return const Center(child: Text('No results found.'));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        var quranVerse = searchResults[index];
                        return Column(
                          children: [
                            // ListTile for each search result
                            ListTile(
                              onTap: () =>
                                  controller.onVersePressed(quranVerse),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SearchHighlightText(
                                  searchResults[index].textUthmaniSimple,
                                  searchText: controller.searchText.value,
                                ),
                              ),
                              subtitle: SurahVerseWidget(
                                  surah: quranVerse.surahNumber,
                                  verse: quranVerse.verseNumber),
                            ),
                            // Divider between search results
                            if (index < searchResults.length - 1)
                              const Divider(
                                height: 1,
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchHighlightText extends StatelessWidget {
  const SearchHighlightText(
    this.text, {
    Key? key,
    this.searchText,
    this.searchRegExp,
    this.style,
    this.highlightStyle,
  })  : assert(searchText == null || searchRegExp == null),
        super(key: key);

  final String text;
  final String? searchText;
  final RegExp? searchRegExp;
  final TextStyle? style;
  final TextStyle? highlightStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inheritedWidget = SearchTextInheritedWidget.maybeOf(context);
    RegExp? searchRegExp = searchText != null
        ? RegExp(searchText!)
        : (this.searchRegExp ?? inheritedWidget?.searchRegExp);

    if (searchRegExp == null || searchRegExp.pattern.isEmpty) {
      return Text(
        text,
      );
    }

    final highlightStyle = this.highlightStyle ??
        ((inheritedWidget?.highlightStyle) ??
            (style != null
                ? style!.copyWith(
                    color: inheritedWidget?.highlightColor ??
                        theme.colorScheme.onBackground,
                  )
                : DefaultTextStyle.of(context).style.copyWith(
                      color: inheritedWidget?.highlightColor ??
                          theme.colorScheme.onBackground,
                    )));

    final textSpans = <TextSpan>[];
    var lastEnd = 0;
    for (final match in searchRegExp.allMatches(text)) {
      if (match.start > lastEnd) {
        textSpans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: style ?? DefaultTextStyle.of(context).style,
          ),
        );
      }
      textSpans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: highlightStyle.copyWith(
              backgroundColor: theme.colorScheme.surfaceVariant),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: style ?? DefaultTextStyle.of(context).style,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
