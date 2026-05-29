enum TicketTier {
  platinum('Platinum', 4),
  gold('Gold', 3),
  silver('Silver', 2),
  economy('Economy', 1);

  const TicketTier(this.label, this.rank);

  final String label;
  final int rank;
}

class Passenger {
  final String pnr;
  final String name;
  final TicketTier tier;
  final int arrivalOrder;

  const Passenger({
    required this.pnr,
    required this.name,
    required this.tier,
    this.arrivalOrder = 0,
  });

  Passenger copyWith({int? arrivalOrder}) => Passenger(
        pnr: pnr,
        name: name,
        tier: tier,
        arrivalOrder: arrivalOrder ?? this.arrivalOrder,
      );

  @override
  String toString() => '$name [$pnr] (${tier.label})';
}
