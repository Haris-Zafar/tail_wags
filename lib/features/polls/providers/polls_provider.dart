import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poll_model.dart';
import '../services/poll_service.dart';

final pollServiceProvider = Provider<PollService>((ref) {
  return PollService();
});

/// Streams all created polls from Firestore
final allPollsProvider = StreamProvider<List<PollModel>>((ref) {
  final pollService = ref.watch(pollServiceProvider);
  return pollService.streamPolls();
});
