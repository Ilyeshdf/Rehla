import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';

class FeedProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<PostModel> _posts = [];
  bool _isLoading = true;

  final List<PostModel> _localPosts = [];

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;

  FeedProvider() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {

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

      if (_posts.isEmpty && _localPosts.isEmpty) {
        _posts = _getMockPosts();
      }
    } finally {

      if (_localPosts.isNotEmpty) {
        final remoteIds = _posts.map((p) => p.id).toSet();
        final newLocals = _localPosts.where((p) => !remoteIds.contains(p.id)).toList();
        _posts = [...newLocals, ..._posts];
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPost(PostModel post) async {

    _localPosts.insert(0, post);

    _posts.insert(0, post);
    notifyListeners();

    try {

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

    }
  }

  Future<void> toggleLike(String postId) async {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final post = _posts[idx];

    if (post.isLiked) {
      post.isLiked = false;
      post.likes--;
    } else {
      post.isLiked = true;
      post.likes++;
    }
    notifyListeners();

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      if (!post.isLiked) {
        await _supabase.from('post_likes').delete().match({'post_id': postId, 'user_id': userId});
      } else {
        await _supabase.from('post_likes').insert({'post_id': postId, 'user_id': userId});
      }
    } catch (e) {

      debugPrint('Like sync error: $e');
    }
  }

  List<PostModel> _getMockPosts() {
    return [
      PostModel(
        id: 'mock_1',
        userId: 'u1',
        username: 'أحمد الجزائري',
        wilayaBadge: 'Constantine',
        journeyId: 'j1',
        photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Palais_ahmed_bey.jpg/960px-Palais_ahmed_bey.jpg',
        caption: 'جسر سيدي مسيد — منظر لا يُنسى! 🌉🇩🇿 #قسنطينة #اكتشف_الجزائر',
        tags: ['#قسنطينة', '#اكتشف_الجزائر'],
        likes: 42,
        comments: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        distanceKm: 3.5,
        time: const Duration(minutes: 45),
        difficulty: 'Easy',
      ),
      PostModel(
        id: 'mock_2',
        userId: 'u2',
        username: 'سارة المستكشفة',
        wilayaBadge: 'Djanet',
        journeyId: 'j2',
        photoUrl: 'https://cdn.pixabay.com/photo/2021/04/01/14/06/sahara-6142345_1280.jpg',
        caption: 'الطاسيلي ناجر — لوحة فنية من صنع الطبيعة! 🏜️✨ #جانت #صحراء',
        tags: ['#جانت', '#صحراء'],
        likes: 128,
        comments: 23,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        distanceKm: 12.0,
        time: const Duration(hours: 3),
        difficulty: 'Hard',
      ),
      PostModel(
        id: 'mock_3',
        userId: 'u3',
        username: 'كريم الرحال',
        wilayaBadge: 'Algiers',
        journeyId: 'j3',
        photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/La_Casbah_d%27Alger_2.jpg/1200px-La_Casbah_d%27Alger_2.jpg',
        caption: 'القصبة العتيقة — تاريخ حي في كل زاوية 🏛️ #الجزائر_العاصمة',
        tags: ['#الجزائر', '#القصبة'],
        likes: 87,
        comments: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        distanceKm: 2.0,
        time: const Duration(minutes: 90),
        difficulty: 'Medium',
      ),
    ];
  }
}
