import 'package:flutter/material.dart';
import 'pages/menu_page.dart';
import 'pages/home_page.dart';
import 'pages/exercise_library_page.dart';
import 'pages/goals_page.dart';
import 'pages/profile_page.dart';
import 'pages/exercise_guide_page.dart';
import 'pages/notice_page.dart';
import 'pages/analysis_page.dart';
import 'pages/rest_timer_page.dart';
import 'widgets/shared_widgets.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  final PageController _pages = PageController(initialPage: 1);
  late final AnimationController _exploreEntrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
    value: 1,
  );
  late final AnimationController _timerEntrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
    value: 1,
  );
  int _selectedPage = 0;
  int _settledPage = 1;
  final Set<String> _completed = {};
  final List<RestSession> _restSessions = [];

  void _selectPage(int index) {
    setState(() => _selectedPage = index);
    _pages.animateToPage(index + 1, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
  }

  void _openExercise(int index) {
    Navigator.of(context).push(_slideRoute(ExerciseGuide(
      initialIndex: index,
      completed: _completed,
      onCompleted: (name) => setState(() => _completed.add(name)),
    )));
  }

  void _openNotices() {
    Navigator.of(context).push(noticeFoldRoute());
  }

  @override
  void dispose() {
    _pages.dispose();
    _exploreEntrance.dispose();
    _timerEntrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(fit: StackFit.expand, children: [
            Positioned.fill(child: Opacity(opacity: .13, child: Image.asset('assets/images/sports.jpg', fit: BoxFit.cover))),
            NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if (notification.depth == 0) {
                  final page = _pages.hasClients ? (_pages.page?.round() ?? _settledPage) : _settledPage;
                  if (page != _settledPage) {
                    final previousPage = _settledPage;
                    setState(() => _settledPage = page);
                    if (previousPage == 1 && page == 0) _exploreEntrance.forward(from: 0);
                    if (previousPage == 5 && page == 6) _timerEntrance.forward(from: 0);
                  }
                }
                return false;
              },
              child: PageView(
                controller: _pages,
                physics: const _SensitivePagePhysics(),
                onPageChanged: (index) => setState(() => _selectedPage = index - 1),
                children: [
                _ExploreArrivalZoom(animation: _exploreEntrance, child: MenuRevealPage(controller: _pages, onNavigate: _selectPage)),
                HomePage(title: 'Welcome back', subtitle: 'Ready to move today?', image: 'assets/images/download (2).jpg', icon: Icons.home_rounded, action: () => _selectPage(2), actionText: 'VIEW TODAY’S PLAN'),
                ExerciseLibraryPage(completed: _completed, onOpen: _openExercise),
                GoalsPage(completed: _completed, onOpen: _openExercise),
                AnalysisPage(completedSessions: _completed.length, restSessions: _restSessions),
                ProfilePage(onOpenNotices: _openNotices),
                _ExploreArrivalZoom(animation: _timerEntrance, child: RestTimerPage(onSave: (session) => setState(() => _restSessions.insert(0, session)))),
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: BottomBar(selected: _selectedPage.clamp(0, 4), onSelect: _selectPage),
      );
}

class _ExploreArrivalZoom extends StatelessWidget {
  const _ExploreArrivalZoom({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final scale = .82 + .18 * Curves.easeOutBack.transform(animation.value);
          final opacity = const Interval(0, .72, curve: Curves.easeOut).transform(animation.value);
          return Opacity(
            opacity: opacity,
            child: Transform.scale(scale: scale, child: child),
          );
        },
      );
}

class _ArrivalZoomPage extends StatefulWidget {
  const _ArrivalZoomPage({required this.page, required this.settledPage, required this.child});

  final int page;
  final int settledPage;
  final Widget child;

  @override
  State<_ArrivalZoomPage> createState() => _ArrivalZoomPageState();
}

class _ArrivalZoomPageState extends State<_ArrivalZoomPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 560),
  );
  late final Animation<double> _scale = Tween<double>(begin: .82, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, .72, curve: Curves.easeOut),
  );

  @override
  void didUpdateWidget(covariant _ArrivalZoomPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settledPage != widget.settledPage && widget.settledPage == widget.page) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _controller.isAnimating ? _opacity.value : 1,
          child: Transform.scale(scale: _controller.isAnimating ? _scale.value : 1, child: child),
        ),
      );
}

Route<void> _slideRoute(Widget child) => PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (_, _, _) => child,
      transitionsBuilder: (_, animation, _, child) {
        final slide = Tween<Offset>(begin: const Offset(0.16, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(position: animation.drive(slide), child: child),
        );
      },
    );
class _SensitivePagePhysics extends PageScrollPhysics {
  const _SensitivePagePhysics({super.parent});

  @override
  _SensitivePagePhysics applyTo(ScrollPhysics? ancestor) =>
      _SensitivePagePhysics(parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final tolerance = toleranceFor(position);
    if (position.outOfRange || velocity.abs() >= tolerance.velocity) {
      return super.createBallisticSimulation(position, velocity);
    }

    final page = position.pixels / position.viewportDimension;
    final lowerPage = page.floorToDouble();
    final fraction = page - lowerPage;
    final targetPage = velocity > 0
        ? (fraction > .28 ? lowerPage + 1 : lowerPage)
        : velocity < 0
            ? (fraction < .72 ? lowerPage : lowerPage + 1)
            : page.roundToDouble();
    final targetPixels = targetPage * position.viewportDimension;
    if (targetPixels == position.pixels) return null;
    return ScrollSpringSimulation(spring, position.pixels, targetPixels, velocity, tolerance: tolerance);
  }
}
