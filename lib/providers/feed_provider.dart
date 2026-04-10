import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class FeedProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<PostModel> _posts = [];
  bool _isLoading = true;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch posts with associated profile data using a join
      final data = await _supabase
          .from('posts')
          .select('*, profiles(username, wilaya)')
          .order('created_at', ascending: false);

      _posts = (data as List).map((post) {
        return PostModel(
          id: post['id'],
          userId: post['user_id'],
          username: post['profiles']?['username'] ?? 'Explorer',
          wilayaBadge: post['profiles']?['wilaya'] ?? 'Algeria',
          journeyId: post['journey_id'],
          photoUrl: post['photo_url'] ?? '',
          caption: post['caption'] ?? '',
          tags: List<String>.from(post['tags'] ?? []),
          likes: post['likes_count'] ?? 0,
          comments: post['comments_count'] ?? 0,
          createdAt: DateTime.parse(post['created_at']),
          isLiked: false,
          distanceKm: (post['distance_km'] ?? 0.0).toDouble(),
          time: Duration(seconds: post['duration_seconds'] ?? 0),
          difficulty: post['difficulty'] ?? 'Easy',
        );
      }).toList();
      
      // Secondary check for current user's likes
      if (_supabase.auth.currentUser != null) {
        final userId = _supabase.auth.currentUser!.id;
        final likesData = await _supabase
            .from('post_likes')
            .select('post_id')
            .eq('user_id', userId);
        
        final likedPostIds = (likesData as List).map((l) => l['post_id'] as String).toSet();
        for (var post in _posts) {
          if (likedPostIds.contains(post.id)) {
            post.isLiked = true;
          }
        }
      }
    } catch (e) {
      debugPrint('Supabase Feed Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(PostModel post) async {
    // Add to local list immediately for better UX
    _posts.insert(0, post);
    notifyListeners();

    try {
      // Sync with Supabase
      await _supabase.from('posts').insert({
        'id': post.id,
        'user_id': post.userId,
        'journey_id': post.journeyId,
        'photo_url': post.photoUrl,
        'caption': post.caption,
        'tags': post.tags,
        'distance_km': post.distanceKm,
        'duration_seconds': post.time.inSeconds,
        'difficulty': post.difficulty,
        'created_at': post.createdAt.toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error syncing post to Supabase: $e');
      // Optional: remove if failed, but usually we want to keep it locally if it's transient
    }
  }

  Future<void> toggleLike(String postId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = _posts[idx];
    final originalLiked = post.isLiked;

    try {
      if (originalLiked) {
        // Unlike
        await _supabase.from('post_likes').delete().match({'post_id': postId, 'user_id': userId});
        post.isLiked = false;
        post.likes--;
      } else {
        // Like
        await _supabase.from('post_likes').insert({'post_id': postId, 'user_id': userId});
        post.isLiked = true;
        post.likes++;
      }
      notifyListeners();
    } catch (e) {
      // Revert on error
      post.isLiked = originalLiked;
      if (originalLiked) {
        post.likes++;
      } else {
        post.likes--;
      }
      notifyListeners();
    }
  }
}
