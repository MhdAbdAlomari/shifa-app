import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int surgeriesToday;
  final int roomsInUse;
  final int totalRooms;
  final int surgeriesThisWeek;
  final int surgeriesCompletedToday;
  final int surgeriesInProgress;

  const DashboardStats({
    required this.surgeriesToday,
    required this.roomsInUse,
    required this.totalRooms,
    required this.surgeriesThisWeek,
    required this.surgeriesCompletedToday,
    required this.surgeriesInProgress,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
        surgeriesToday: json['surgeries_today'] as int,
        roomsInUse: json['rooms_in_use'] as int,
        totalRooms: json['total_rooms'] as int,
        surgeriesThisWeek: json['surgeries_this_week'] as int,
        surgeriesCompletedToday: json['surgeries_completed_today'] as int,
        surgeriesInProgress: json['surgeries_in_progress'] as int,
      );

  @override
  List<Object?> get props => [
        surgeriesToday,
        roomsInUse,
        totalRooms,
        surgeriesThisWeek,
        surgeriesCompletedToday,
        surgeriesInProgress,
      ];
}
