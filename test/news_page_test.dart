import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_example/article.dart';
import 'package:flutter_testing_example/news_change_notifier.dart';
import 'package:flutter_testing_example/news_page.dart';
import 'package:flutter_testing_example/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: "Test 1", content: "Test 1 content"),
    Article(title: "Test 2", content: "Test 2 content"),
    Article(title: "Test 3", content: "Test 3 content"),
  ];

  void arrangeNewsServiceReturn3Article() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    'title is displayed',
    (WidgetTester tester) async {
      arrangeNewsServiceReturn3Article();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("News"), findsOneWidget);
    },
  );
}
