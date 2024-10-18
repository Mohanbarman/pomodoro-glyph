import 'package:flutter/material.dart';
import 'package:pomodoro_glyph/models/settings.dart';
import 'package:pomodoro_glyph/screens/home.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            /// [PageView.scrollDirection] defaults to [Axis.horizontal].
            /// Use [Axis.vertical] to scroll vertically.
            controller: _pageViewController,
            onPageChanged: _handlePageViewChanged,
            children: <Widget>[
              Column(
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/NothingPhone2ProgressGlyph.png',
                    ),
                  ),
                  Text('Lap Timer Indicator', style: textTheme.headlineMedium),
                ],
              ),
              Column(
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/NothingPhone2ShortBreakGlyph.png',
                    ),
                  ),
                  Text(
                    'Short Break Indicator',
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
              Column(
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/NothingPhone2LongBreakGlyph.png',
                    ),
                  ),
                  Text('Long Break Indicator', style: textTheme.headlineMedium),
                  Container(height: 20),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      final perfs = await SharedPreferences.getInstance();
                      perfs.setBool(INTRODUCTION_SEEN, true);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TimerPage(),
                        ),
                      );
                    },
                    label: const Text('Start Using'),
                    icon: const Icon(Icons.navigate_next_rounded),
                  )
                ],
              ),
            ],
          ),
          PageIndicator(
            tabController: _tabController,
            currentPageIndex: _currentPageIndex,
            onUpdateCurrentPageIndex: _updateCurrentPageIndex,
          ),
        ],
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
    required this.onUpdateCurrentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;
  final void Function(int) onUpdateCurrentPageIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            controller: tabController,
            color: colorScheme.surface,
            selectedColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
