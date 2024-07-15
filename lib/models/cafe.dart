class Cafe {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String hours;
  final String price;

  Cafe({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.hours,
    required this.price,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      name: json['Name'] ?? '',
      address: json['Address'] ?? '',
      latitude: json['Position (Latitude)']?.toDouble() ?? 0.0,
      longitude: json['Position (Longitude)']?.toDouble() ?? 0.0,
      hours: json['Hours'] ?? '',
      price: json['Price'] ?? '',
    );
  }
}
