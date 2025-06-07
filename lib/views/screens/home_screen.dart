import 'package:flutter/material.dart';
import 'package:mini_socil_rifa_2242067/controllers/post_controller.dart';
import 'package:mini_socil_rifa_2242067/controllers/auth_controller.dart';
import 'package:mini_socil_rifa_2242067/views/widgets/bottom_nav_bar.dart';
import 'package:mini_socil_rifa_2242067/views/screens/create_post_screen.dart';
import 'package:mini_socil_rifa_2242067/views/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const CreatePostScreen(),
    const ProfileScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Social'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authController = AuthController();
              final success = await authController.logout();

              if (success && context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _postController = PostController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    final posts = await _postController.getPosts();

    if (mounted) {
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_posts.isEmpty) {
      return const Center(child: Text('No posts yet. Be the first to post!'));
    }

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: post['user']['avatar_url'] != null
                            ? NetworkImage(post['user']['avatar_url'])
                            : null,
                        child: post['user']['avatar_url'] == null
                            ? Text(post['user']['name'][0].toUpperCase())
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['user']['name'],
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            post['created_at'],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post['title'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post['content'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (post['image_url'] != null) ...[
                    const SizedBox(height: 8),
                    Image.network(
                      post['image_url'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final success = post['is_liked']
                              ? await _postController.unlikePost(post['id'])
                              : await _postController.likePost(post['id']);

                          if (success) {
                            _loadPosts();
                          }
                        },
                        // icon: Icon(
                        //   post['is_liked']
                        //       ? Icons.favorite
                        //       : Icons.favorite_border,
                        //   color: post['is_liked'] ? Colors.red : null,
                        // ),
                        // label: Text('${post['likes_count']}'),
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Like'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Implement comment functionality
                        },
                        icon: const Icon(Icons.comment_outlined),
                        // label: Text('${post['comments_count']}'),
                        label: const Text('Comment'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Implement share functionality
                        },
                        icon: const Icon(Icons.share_outlined),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
