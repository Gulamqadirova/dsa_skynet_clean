import '../models/airport.dart';
import '../models/flight.dart';
import '../models/passenger.dart';

/// Har bir faza birinchi yuklanishda namoyish etilishi uchun ilovani
/// urug'laydigan global tarmoqning mustaqil namunasi.
class SampleData {
  const SampleData._();

  static const List<Airport> airports = [
    Airport(code: 'JFK', city: 'New York', country: 'AQSH'),
    Airport(code: 'LHR', city: 'London', country: 'Britaniya'),
    Airport(code: 'CDG', city: 'Parij', country: 'Fransiya'),
    Airport(code: 'DXB', city: 'Dubai', country: 'BAA'),
    Airport(code: 'SIN', city: 'Singapur', country: 'Singapur'),
    Airport(code: 'HND', city: 'Tokio', country: 'Yaponiya'),
    Airport(code: 'FRA', city: 'Frankfurt', country: 'Germaniya'),
    Airport(code: 'TAS', city: 'Toshkent', country: 'O\'zbekiston'),
  ];

  /// Yo'nalishli reyslar `(kimdan, kimga, narx $, masofa km, vaqt min)`.
  static const List<(String, String, double, double, int)> flights = [
    ('JFK', 'LHR', 450, 5570, 420),
    ('LHR', 'JFK', 470, 5570, 440),
    ('JFK', 'CDG', 480, 5840, 440),
    ('LHR', 'CDG', 120, 350, 80),
    ('CDG', 'FRA', 110, 480, 75),
    ('FRA', 'DXB', 520, 4840, 380),
    ('LHR', 'DXB', 560, 5500, 420),
    ('DXB', 'TAS', 240, 2570, 200),
    ('DXB', 'SIN', 410, 5840, 440),
    ('SIN', 'HND', 480, 5310, 410),
    ('HND', 'SIN', 470, 5310, 410),
    ('FRA', 'TAS', 430, 4960, 390),
    ('TAS', 'DXB', 250, 2570, 205),
    ('CDG', 'DXB', 540, 5240, 400),
    ('SIN', 'DXB', 415, 5840, 445),
    ('FRA', 'JFK', 510, 6200, 510),
  ];

  static const List<Flight> schedule = [
    Flight(
        flightNo: 'SK101',
        origin: 'JFK',
        destination: 'LHR',
        departureMinutes: 480,
        price: 450,
        fuelEfficiency: 3.1),
    Flight(
        flightNo: 'SK205',
        origin: 'LHR',
        destination: 'CDG',
        departureMinutes: 615,
        price: 120,
        fuelEfficiency: 2.4),
    Flight(
        flightNo: 'SK330',
        origin: 'CDG',
        destination: 'FRA',
        departureMinutes: 390,
        price: 110,
        fuelEfficiency: 2.2),
    Flight(
        flightNo: 'SK412',
        origin: 'FRA',
        destination: 'DXB',
        departureMinutes: 1320,
        price: 520,
        fuelEfficiency: 3.8),
    Flight(
        flightNo: 'SK508',
        origin: 'DXB',
        destination: 'SIN',
        departureMinutes: 75,
        price: 410,
        fuelEfficiency: 3.5),
    Flight(
        flightNo: 'SK612',
        origin: 'SIN',
        destination: 'HND',
        departureMinutes: 1080,
        price: 480,
        fuelEfficiency: 3.3),
    Flight(
        flightNo: 'SK720',
        origin: 'DXB',
        destination: 'TAS',
        departureMinutes: 240,
        price: 240,
        fuelEfficiency: 2.9),
    Flight(
        flightNo: 'SK815',
        origin: 'JFK',
        destination: 'CDG',
        departureMinutes: 990,
        price: 480,
        fuelEfficiency: 3.2),
    Flight(
        flightNo: 'SK902',
        origin: 'LHR',
        destination: 'DXB',
        departureMinutes: 60,
        price: 560,
        fuelEfficiency: 3.9),
    Flight(
        flightNo: 'SK034',
        origin: 'TAS',
        destination: 'DXB',
        departureMinutes: 1230,
        price: 250,
        fuelEfficiency: 2.7),
  ];

  static const List<Passenger> passengers = [
    Passenger(pnr: 'PNR001', name: 'Amelia Watson', tier: TicketTier.platinum),
    Passenger(pnr: 'PNR002', name: 'Liam Carter', tier: TicketTier.economy),
    Passenger(pnr: 'PNR003', name: 'Sofia Marchetti', tier: TicketTier.gold),
    Passenger(pnr: 'PNR004', name: 'Noah Williams', tier: TicketTier.silver),
    Passenger(pnr: 'PNR005', name: 'Olivia Watson', tier: TicketTier.gold),
    Passenger(pnr: 'PNR006', name: 'Ethan Brown', tier: TicketTier.economy),
    Passenger(pnr: 'PNR007', name: 'Aziz Karimov', tier: TicketTier.platinum),
    Passenger(pnr: 'PNR008', name: 'Mia Watson', tier: TicketTier.economy),
    Passenger(pnr: 'PNR009', name: 'Lucas Schmidt', tier: TicketTier.silver),
    Passenger(pnr: 'PNR010', name: 'Hana Tanaka', tier: TicketTier.gold),
  ];
}
