import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:tawakkal/constants/json_path.dart';

import '../../../data/models/quran_simple.dart';
import '../../../widgets/custom_search_bar.dart';
import '../controllers/quran_reading_controller.dart';
import '../widgets/surah_verse.dart';

class QuranSearchController extends GetxController {
  var searchText = ''.obs;
  var searchResults = <QuranSimple>[].obs;

  void updateSearchText(String text) {
    searchText.value = text;
    // Trigger a search when the text changes
    performSearch(text);
  }

  void performSearch(String searchText) async {
    if (searchText.isEmpty) {
      searchResults.clear();
      return;
    }

    final quranData = await readQuranSimpleData();

    final filteredResults = quranData
        .where((quran) => quran.textUthmaniSimple!.contains(searchText))
        .toList();

    searchResults.assignAll(filteredResults);
  }

  Future<List<QuranSimple>> readQuranSimpleData() async {
    final jsonString = await rootBundle.loadString(JsonPaths.quranSimple);
    return (json.decode(jsonString) as List<dynamic>)
        .map((e) => QuranSimple.fromJson(e))
        .toList();
  }
}

// ignore: use_key_in_widget_constructors
class QuranSearchView extends StatelessWidget {
  final controller = Get.put(QuranSearchController());
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 1,
          shadowColor: Theme.of(context).shadowColor,
          elevation: 1,
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
              CustomSearchBar(
                onChanged: (value) {
                  controller.updateSearchText(value);
                },
                hintText: 'ابحث عن آية ...',
              ),
              const SizedBox(height: 10),
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
                        int verse = int.parse(controller
                            .searchResults[index].verseKey
                            .toString()
                            .split(':')[1]);
                        int surah = int.parse(controller
                            .searchResults[index].verseKey
                            .toString()
                            .split(':')[0]);
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                final quranPageViewController =
                                    Get.find<QuranReadingController>();
                                await quranPageViewController.goTo(
                                    pageIndex: getPageNumber(surah, verse));
                                quranPageViewController.highlightAyah(
                                    surah, verse);
                              },
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SearchHighlightText(
                                  searchResults[index].textUthmaniSimple!,
                                  searchText: controller.searchText.value,
                                ),
                              ),
                              subtitle:
                                  SurahVerseWidget(surah: surah, verse: verse),
                            ),
                            if (index < searchResults.length - 1)
                              Divider(
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
