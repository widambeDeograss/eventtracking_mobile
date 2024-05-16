class Artist {
  final String? id;
  final String? username;
  final String? email;
  final int? role;
  final String? createdAt;
  final String? biography;
  final dynamic? profile;

  Artist(
      {required this.id,
      required this.createdAt,
      required this.email,
      required this.username,
      required this.role,
      required this.profile,
      required this.biography});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        profile: json['profile'],
        createdAt: json['created_at'],
        role: json['role'],
        biography: json['biography']);
  }
}

class ArtistList {
  final List<Artist> artistList;
  final List<Artist> userList;

  ArtistList({
    required this.artistList,
    required this.userList,
  });
}

class ArtistHelper {
  static ArtistList filterEventsByType(List<dynamic> users) {
    List<Artist> artistList = [];
    List<Artist> userList = [];

    for (var user in users) {
      Artist newTicket = Artist.fromJson(user);
      switch (newTicket.role) {
        case 2:
          artistList.add(newTicket);
          break;
        case 3:
          userList.add(newTicket);
          break;
        default:
          break;
      }
    }

    return ArtistList(
      userList: userList,
      artistList: artistList,
    );
  }
}
