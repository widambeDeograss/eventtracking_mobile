class Event {
  final String id;
  final String name;
  final String description;
  final String location;
  final String dateTime;
  final int ticketsAmount;
  final int likesCount;
  final String type;
  final int price;
  final dynamic profile;
  final List<dynamic> artists;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.location,
      required this.dateTime,
      required this.ticketsAmount,
      required this.likesCount,
      required this.type,
      required this.price,
      required this.artists,
      required this.profile});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      dateTime: json['date_time'],
      ticketsAmount: json['tickets_amount'],
      likesCount: json['likes_count'],
      type: json['type'],
      price: json['price'],
      artists: json['artists'],
      profile: json['profile'],
    );
  }
}

class EventList {
  final List<Event> bongoFlevaEvents;
  final List<Event> gospelEvents;
  final List<Event> cultureEvents;
  final List<Event> allEvents;

  EventList(
      {required this.bongoFlevaEvents,
      required this.gospelEvents,
      required this.cultureEvents,
      required this.allEvents});
}

class EventHelper {
  static EventList filterEventsByType(List<dynamic> events) {
    List<Event> bongoFlevaEvents = [];
    List<Event> gospelEvents = [];
    List<Event> cultureEvents = [];
    List<Event> allEvents = [];

    for (var event in events) {
      Event newEvent = Event.fromJson(event);
      allEvents.add(newEvent);
      switch (newEvent.type) {
        case 'BongoFleva':
          bongoFlevaEvents.add(newEvent);
          break;
        case 'Gospel':
          gospelEvents.add(newEvent);
          break;
        case 'Culture':
          cultureEvents.add(newEvent);
          break;
        default:
          break;
      }
    }

    return EventList(
      bongoFlevaEvents: bongoFlevaEvents,
      gospelEvents: gospelEvents,
      cultureEvents: cultureEvents,
      allEvents: allEvents,
    );
  }
}
