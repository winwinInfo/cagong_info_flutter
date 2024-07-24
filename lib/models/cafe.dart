class Cafe {
  final String id;
  final String name;
  final String address;
  final String message;
  final String openingHours;
  final int hoursWeekday;
  final int hoursWeekend;
  final int price;
  final List<SeatingInfo> seatingInfo;
  final String? videoUrl;
  final int cowork;
  final double latitude;
  final double longitude;

  Cafe({
    required this.id,
    required this.name,
    required this.address,
    required this.message,
    required this.openingHours,
    required this.hoursWeekday,
    required this.hoursWeekend,
    required this.price,
    required this.seatingInfo,
    this.videoUrl,
    required this.cowork,
    required this.latitude,
    required this.longitude,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['ID'].toString(),
      name: json['Name'] ?? '',
      address: json['Address'] ?? '',
      message: json['Message'] ?? '',
      openingHours: json['영업 시간'] ?? '',
      hoursWeekday: json['Hours_weekday'] ?? 0,
      hoursWeekend: json['Hours_weekend'] ?? 0,
      price: int.tryParse(json['Price']?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0,
      seatingInfo: _parseSeatingInfo(json),
      videoUrl: json['Video URL'],
      cowork: json['Co-work'] ?? 0,
      latitude: json['Position (Latitude)'] ?? 0.0,
      longitude: json['Position (Longitude)'] ?? 0.0,
    );
  }

  static List<SeatingInfo> _parseSeatingInfo(Map<String, dynamic> json) {
    List<SeatingInfo> seatingInfoList = [];
    for (int i = 1; i <= 5; i++) {
      String typeKey = 'Seating Type $i';
      String countKey = 'Seating Count $i';
      String powerKey = 'Power Count $i';

      if (json.containsKey(typeKey) && json[typeKey] != null) {
        seatingInfoList.add(SeatingInfo(
          type: json[typeKey] ?? '',
          count: (json[countKey] is int ? json[countKey] : int.tryParse(json[countKey]?.toString() ?? '0')) ?? 0,
          powerCount: (json[powerKey] is int ? json[powerKey] : int.tryParse(json[powerKey]?.toString() ?? '0')) ?? 0,
        ));
      }
    }
    return seatingInfoList;
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Name': name,
      'Address': address,
      'Message': message,
      '영업 시간': openingHours,
      'Hours_weekday': hoursWeekday,
      'Hours_weekend': hoursWeekend,
      'Price': price.toString(),
      'Video URL': videoUrl,
      'Co-work': cowork,
      'Position (Latitude)': latitude,
      'Position (Longitude)': longitude,
      ...seatingInfoToJson(),
    };
  }

  Map<String, dynamic> seatingInfoToJson() {
    Map<String, dynamic> result = {};
    for (int i = 0; i < seatingInfo.length; i++) {
      result['Seating Type ${i + 1}'] = seatingInfo[i].type;
      result['Seating Count ${i + 1}'] = seatingInfo[i].count;
      result['Power Count ${i + 1}'] = seatingInfo[i].powerCount;
    }
    return result;
  }

  int get totalPowerSeats {
    return seatingInfo.fold(0, (sum, seat) => sum + seat.powerCount);
  }
}

class SeatingInfo {
  final String type;
  final int count;
  final int powerCount;

  SeatingInfo({
    required this.type,
    required this.count,
    required this.powerCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'count': count,
      'powerCount': powerCount,
    };
  }
}
