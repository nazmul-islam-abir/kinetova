import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../widgets/shared_widgets.dart';

class MenuRevealPage extends StatelessWidget {
  const MenuRevealPage({super.key, required this.controller, required this.onNavigate});
  final PageController controller;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        child: ExplorerPage(onNavigate: onNavigate),
        builder: (context, child) {
          final page = controller.hasClients ? (controller.page ?? 1.0) : 1.0;
          final progress = page.clamp(0.0, 1.0).toDouble();
          final reveal = 1.0 - progress;
          final scale = .52 + .48 * Curves.easeOutBack.transform(reveal);
          final matrix = Matrix4.identity()
            ..translateByDouble(0.0, progress * 30.0, 0.0, 1.0)
            ..scaleByDouble(scale, scale, 1.0, 1.0);
          return Transform(
            alignment: Alignment.center,
            transform: matrix,
            child: Opacity(opacity: .42 + reveal * .58, child: child),
          );
        },
      );
}

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final Set<int> _likedPosts = {};
  int _nextId = 4;
  late final List<_ExplorerPostData> _posts = [
    const _ExplorerPostData(id: 1, author: 'Alex Morgan', initials: 'AM', time: '24 min ago', message: 'Wrapped up my first full week back at the gym. Showing up really is the hardest part.', image: 'assets/images/sports.jpg', likes: 18),
    const _ExplorerPostData(id: 2, author: 'Sam Rivera', initials: 'SR', time: '1 hr ago', message: 'A reminder for today: your pace is allowed to be your own. One small step still counts.', image: null, likes: 12),
    const _ExplorerPostData(id: 3, author: 'Jamie Lee', initials: 'JL', time: '3 hrs ago', message: 'Found a little extra energy after work and went for a walk. Glad I did 🌿', image: 'assets/images/download (3).jpg', likes: 27),
  ];

  Future<void> _composePost() async {
    final controller = TextEditingController();
    final message = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: panel,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewInsetsOf(sheetContext).bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Create a post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            minLines: 3,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: 'Share a win, a thought, or a little motivation…',
              filled: true,
              fillColor: ink,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () => Navigator.pop(sheetContext, controller.text),
              style: FilledButton.styleFrom(backgroundColor: lime, foregroundColor: ink),
              child: const Text('SHARE POST', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: .8)),
            ),
          ),
        ]),
      ),
    );
    controller.dispose();
    final trimmed = message?.trim();
    if (trimmed == null || trimmed.isEmpty || !mounted) return;
    setState(() {
      _posts.insert(0, _ExplorerPostData(
        id: _nextId++,
        author: 'You',
        initials: 'YO',
        time: 'Just now',
        message: trimmed,
        image: null,
        likes: 0,
      ));
    });
  }

  void _toggleLike(int id) {
    setState(() {
      if (!_likedPosts.add(id)) _likedPosts.remove(id);
    });
  }

  void _showComments(_ExplorerPostData post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comments for ${post.author} are coming soon'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Explore',
        eyebrow: 'KINETOVA COMMUNITY',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: .06))),
            child: Row(children: [
              const CircleAvatar(radius: 20, backgroundColor: Color(0xFF24414A), child: Icon(Icons.person, color: Colors.white, size: 21)),
              const SizedBox(width: 11),
              Expanded(
                child: InkWell(
                  onTap: _composePost,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                    decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(12)),
                    child: const Text('Share something with your community…', style: TextStyle(color: muted, fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: _composePost,
                tooltip: 'Create post',
                style: IconButton.styleFrom(backgroundColor: lime.withValues(alpha: .14), foregroundColor: lime),
                icon: const Icon(Icons.add_rounded),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('Your community', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
            TextButton.icon(
              onPressed: () => widget.onNavigate(1),
              icon: const Icon(Icons.bolt_rounded, size: 16),
              label: const Text('Train'),
              style: TextButton.styleFrom(foregroundColor: lime),
            ),
          ]),
          const SizedBox(height: 3),
          ..._posts.map((post) => _ExplorerPostCard(
                post: post,
                liked: _likedPosts.contains(post.id),
                onLike: () => _toggleLike(post.id),
                onComment: () => _showComments(post),
              )),
        ]),
      );
}

class _ExplorerPostData {
  const _ExplorerPostData({required this.id, required this.author, required this.initials, required this.time, required this.message, required this.image, required this.likes});
  final int id;
  final String author;
  final String initials;
  final String time;
  final String message;
  final String? image;
  final int likes;
}

class _ExplorerPostCard extends StatelessWidget {
  const _ExplorerPostCard({required this.post, required this.liked, required this.onLike, required this.onComment});
  final _ExplorerPostData post;
  final bool liked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 9),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: .06))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: lime.withValues(alpha: .16),
              child: Text(post.initials, style: const TextStyle(color: lime, fontSize: 11, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(post.author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(post.time, style: const TextStyle(color: muted, fontSize: 10)),
            ])),
            const Icon(Icons.more_horiz_rounded, color: muted),
          ]),
          const SizedBox(height: 12),
          Text(post.message, style: const TextStyle(fontSize: 13, height: 1.4)),
          if (post.image != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: AspectRatio(aspectRatio: 1.5, child: Image.asset(post.image!, fit: BoxFit.cover)),
            ),
          ],
          const SizedBox(height: 5),
          Row(children: [
            const Icon(Icons.favorite_rounded, color: lime, size: 14),
            const SizedBox(width: 5),
            Text('${post.likes + (liked ? 1 : 0)}', style: const TextStyle(color: muted, fontSize: 11)),
            const Spacer(),
            TextButton.icon(
              onPressed: onLike,
              icon: Icon(liked ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 17),
              label: Text(liked ? 'Liked' : 'Like'),
              style: TextButton.styleFrom(foregroundColor: liked ? lime : muted, visualDensity: VisualDensity.compact),
            ),
            TextButton.icon(
              onPressed: onComment,
              icon: const Icon(Icons.mode_comment_outlined, size: 16),
              label: const Text('Comment'),
              style: TextButton.styleFrom(foregroundColor: muted, visualDensity: VisualDensity.compact),
            ),
          ]),
        ]),
      );
}
