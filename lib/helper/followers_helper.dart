class Follow {
  final String id;
  final String? createdAt;
  final dynamic artist;
  final dynamic follower;

  Follow(
      {required this.id,
      required this.artist,
      required this.follower,
      required this.createdAt});

  factory Follow.fromJson(Map<String, dynamic> json) {
    // print(json['user']['id']);
    return Follow(
      id: json['id'],
      createdAt: json['created_at'],
      artist: json['artist'],
      follower: json['follower'],
    );
  }
}

class FollowList {
  final List<Follow> followList;

  FollowList({
    required this.followList,
  });
}

class FollowHelper {
  static FollowList filterEventsByType(List<dynamic> follows) {
    List<Follow> followlst = [];

    for (var ticket in follows) {
      Follow newFoll = Follow.fromJson(ticket);
      followlst.add(newFoll);
    }

    return FollowList(followList: followlst);
  }
}
