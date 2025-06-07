import 'package:flutter/material.dart';
import 'package:mini_socil_rifa_2242067/controllers/post_controller.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController();
    final content = TextEditingController();
    final postController = PostController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.post_add,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                'Share Your Thoughts',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: content,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (title.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  if (content.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter some content')),
                    );
                    return;
                  }

                  final success = await postController.createPost(
                    title: title.text,
                    content: content.text,
                  );

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post created successfully')),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to create post')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 