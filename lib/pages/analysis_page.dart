import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'rest_timer_page.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key, required this.completedSessions, required this.restSessions});
  final int completedSessions;
  final List<RestSession> restSessions;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: ink,
        body: Stack(fit: StackFit.expand, children: [
          Positioned.fill(child: Opacity(opacity: .22, child: Image.asset('assets/images/sports.jpg', fit: BoxFit.cover))),
          SafeArea(child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 18, 12),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: lime.withValues(alpha: .14), borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.auto_graph_rounded, color: lime, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Your analysis', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('Sample movement insights', style: TextStyle(color: muted, fontSize: 11)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                  decoration: BoxDecoration(color: lime.withValues(alpha: .12), borderRadius: BorderRadius.circular(18)),
                  child: const Text('DEMO', style: TextStyle(color: lime, fontSize: 8, letterSpacing: .9, fontWeight: FontWeight.w900)),
                ),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                children: [
                  _AnalysisHero(completedSessions: completedSessions),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _MetricCard(icon: Icons.bolt_rounded, value: '$completedSessions', label: 'SESSIONS')),
                    const SizedBox(width: 9),
                    const Expanded(child: _MetricCard(icon: Icons.schedule_rounded, value: '41m', label: 'AVG. MOVE')),
                    const SizedBox(width: 9),
                    const Expanded(child: _MetricCard(icon: Icons.local_fire_department_rounded, value: '3 days', label: 'STREAK')),
                  ]),
                  const SizedBox(height: 19),
                  const _SectionTitle(title: 'Weekly activity', subtitle: 'Minutes moved · last 7 days'),
                  const SizedBox(height: 12),
                  const _WeeklyActivityChart(),
                  const SizedBox(height: 19),
                  const _SectionTitle(title: 'Training balance', subtitle: 'Where your sessions are going'),
                  const SizedBox(height: 12),
                  const _BalanceCard(),
                  const SizedBox(height: 19),
                  const _SectionTitle(title: 'Consistency', subtitle: 'A small check-in beats an all-or-nothing week'),
                  const SizedBox(height: 12),
                  const _ConsistencyCard(),
                  const SizedBox(height: 19),
                  const _SectionTitle(title: 'Rest & breathing', subtitle: 'Saved sessions from your quiet timer page'),
                  const SizedBox(height: 12),
                  _RestSessionsCard(sessions: restSessions),
                ],
              ),
            ),
          ])),
        ]),
      );
}

class _AnalysisHero extends StatelessWidget {
  const _AnalysisHero({required this.completedSessions});
  final int completedSessions;

  @override
  Widget build(BuildContext context) => Container(
        height: 155,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: const AssetImage('assets/images/sports.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(ink.withValues(alpha: .45), BlendMode.darken),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text('YOUR WEEK IN MOTION', style: TextStyle(color: lime, fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
          const SizedBox(height: 7),
          Text(completedSessions == 0 ? 'A fresh week starts\nwith one move.' : 'You showed up\n$completedSessions times.', style: const TextStyle(fontSize: 24, height: 1.05, fontWeight: FontWeight.w800)),
        ]),
      );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(15)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: lime, size: 17),
          const SizedBox(height: 9),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: muted, fontSize: 8, letterSpacing: .7, fontWeight: FontWeight.w800)),
        ]),
      );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: muted, fontSize: 11)),
      ]);
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart();

  static const _bars = [.35, .54, .26, .82, .47, .95, .4];
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) => Container(
        height: 190,
        padding: const EdgeInsets.fromLTRB(16, 17, 16, 12),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17)),
        child: Column(children: [
          Row(children: [
            const Expanded(child: Text('You moved more on Saturday', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(color: lime.withValues(alpha: .13), borderRadius: BorderRadius.circular(20)),
              child: const Text('+12%', style: TextStyle(color: lime, fontSize: 9, fontWeight: FontWeight.w900)),
            ),
          ]),
          const SizedBox(height: 13),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_bars.length, (index) => Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Expanded(child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: _bars[index],
                      child: Container(
                        decoration: BoxDecoration(
                          color: index == 5 ? lime : lime.withValues(alpha: .30 + _bars[index] * .34),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 7),
                  Text(_days[index], style: TextStyle(color: index == 5 ? lime : muted, fontSize: 9, fontWeight: FontWeight.w800)),
                ]),
              ))),
            ),
          ),
        ]),
      );
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17)),
        child: Column(children: const [
          _BalanceRow(label: 'Strength', value: .76, amount: '3 sessions'),
          SizedBox(height: 15),
          _BalanceRow(label: 'Cardio', value: .48, amount: '2 sessions'),
          SizedBox(height: 15),
          _BalanceRow(label: 'Mobility', value: .3, amount: '1 session'),
        ]),
      );
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.label, required this.value, required this.amount});
  final String label;
  final double value;
  final String amount;

  @override
  Widget build(BuildContext context) => Row(children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: value, color: lime, backgroundColor: Colors.white12, minHeight: 7),
        )),
        const SizedBox(width: 10),
        SizedBox(width: 70, child: Text(amount, textAlign: TextAlign.right, style: const TextStyle(color: muted, fontSize: 9))),
      ]);
}

class _ConsistencyCard extends StatelessWidget {
  const _ConsistencyCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.calendar_month_rounded, color: lime, size: 17),
            const SizedBox(width: 8),
            const Expanded(child: Text('Your last 7 days', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
            Text('4 active days', style: const TextStyle(color: muted, fontSize: 10)),
          ]),
          const SizedBox(height: 13),
          Row(children: List.generate(7, (index) => Expanded(child: Container(
            height: 31,
            margin: EdgeInsets.only(right: index == 6 ? 0 : 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: [0, 2, 4, 5].contains(index) ? lime.withValues(alpha: .85) : Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][index], style: TextStyle(color: [0, 2, 4, 5].contains(index) ? ink : muted, fontSize: 9, fontWeight: FontWeight.w800)),
          )))),
        ]),
      );
}

class _RestSessionsCard extends StatelessWidget {
  const _RestSessionsCard({required this.sessions});

  final List<RestSession> sessions;

  String _duration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return minutes > 0 ? '${minutes}m ${seconds.toString().padLeft(2, '0')}s' : '${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final total = sessions.fold<int>(0, (sum, session) => sum + session.duration.inSeconds);
    final totalLabel = total >= 60 ? '${total ~/ 60}m ${(total % 60).toString().padLeft(2, '0')}s' : '${total}s';
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(17)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(color: lime.withValues(alpha: .13), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.spa_rounded, color: lime, size: 19),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text('Time you gave yourself', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
          Text(totalLabel, style: const TextStyle(color: lime, fontSize: 13, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 7),
        Text('${sessions.length} saved ${sessions.length == 1 ? 'session' : 'sessions'}', style: const TextStyle(color: muted, fontSize: 10)),
        if (sessions.isEmpty) ...[
          const SizedBox(height: 13),
          const Text('Your saved break, breath and rest sessions will appear here.', style: TextStyle(color: muted, fontSize: 11, height: 1.35)),
        ] else ...[
          const SizedBox(height: 12),
          ...sessions.take(5).map((session) => Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, color: lime, size: 15),
              const SizedBox(width: 8),
              Expanded(child: Text(session.kind, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
              Text(_duration(session.duration), style: const TextStyle(color: Colors.white70, fontSize: 10)),
              const SizedBox(width: 9),
              Text('${session.savedAt.month}/${session.savedAt.day}', style: const TextStyle(color: muted, fontSize: 9)),
            ]),
          )),
        ],
      ]),
    );
  }
}
