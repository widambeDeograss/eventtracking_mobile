class Ticket {
  final String id;
  final DateTime createdAt;
  final int number;
  final bool isActive;
  final int amount;
  final Map<String, dynamic> event;
  final Map<String, dynamic> user;

  Ticket(
      {required this.id,
      required this.createdAt,
      required this.number,
      required this.amount,
      required this.isActive,
      required this.event,
      required this.user});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      isActive: json['is_active'],
      amount: json['amount'],
      number: json['number'],
      createdAt: DateTime.parse(json['created_at']),
      event: json['event'],
      user: json['user'],
    );
  }
}

class TicketList {
  final List<Ticket> activeTickets;
  final List<Ticket> inActiveTickets;

  TicketList({
    required this.activeTickets,
    required this.inActiveTickets,
  });
}

class TicketsHelper {
  static TicketList filterEventsByType(List<dynamic> tickets) {
    List<Ticket> activeTickets = [];
    List<Ticket> inActiveTickets = [];

    for (var ticket in tickets) {
      Ticket newTicket = Ticket.fromJson(ticket);
      switch (newTicket.isActive) {
        case true:
          activeTickets.add(newTicket);
          break;
        case false:
          inActiveTickets.add(newTicket);
          break;
        default:
          break;
      }
    }

    return TicketList(
      inActiveTickets: inActiveTickets,
      activeTickets: activeTickets,
    );
  }
}
