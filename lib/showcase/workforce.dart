import 'package:flutter/foundation.dart';

enum RequestStatus { pending, approved }

@immutable
class LeaveRequest {
  const LeaveRequest({
    required this.id,
    required this.date,
    required this.reason,
    this.status = RequestStatus.pending,
  });
  final int id;
  final DateTime date;
  final String reason;
  final RequestStatus status;
}

/// Boundary for a future authenticated ERP adapter. The preview never uses a live server.
abstract interface class WorkforceRepository {
  List<LeaveRequest> get requests;
  int get remainingLeaveDays;
  Future<LeaveRequest> requestLeave(DateTime date, String reason);
  Future<void> recordAttendance(DateTime time);
}

class DemoWorkforceRepository implements WorkforceRepository {
  final List<LeaveRequest> _requests = [
    LeaveRequest(
      id: 1,
      date: DateTime(2026, 11, 18),
      reason: 'Personal appointment',
    ),
    LeaveRequest(
      id: 2,
      date: DateTime(2026, 11, 5),
      reason: 'Annual leave',
      status: RequestStatus.approved,
    ),
  ];
  @override
  List<LeaveRequest> get requests => List.unmodifiable(_requests);
  @override
  int get remainingLeaveDays =>
      12 - _requests.where((r) => r.status == RequestStatus.pending).length;

  @override
  Future<LeaveRequest> requestLeave(DateTime date, String reason) async {
    final day = DateTime(date.year, date.month, date.day);
    if (reason.trim().isEmpty) {
      throw ArgumentError('Add a reason for your request.');
    }
    if (_requests.any((r) => r.date == day)) {
      throw StateError('A request already exists for this day.');
    }
    if (remainingLeaveDays <= 0) {
      throw StateError('No leave allowance remaining.');
    }
    final request = LeaveRequest(
      id: _requests.length + 1,
      date: day,
      reason: reason.trim(),
    );
    _requests.add(request);
    return request;
  }

  final List<DateTime> attendance = [];
  @override
  Future<void> recordAttendance(DateTime time) async {
    attendance.add(time);
  }
}

class WorkforceController extends ChangeNotifier {
  WorkforceController(this.repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final WorkforceRepository repository;
  final DateTime Function() _now;
  bool checkedIn = false;
  bool busy = false;
  String? error;
  DateTime? checkedInAt;
  List<LeaveRequest> get requests => repository.requests;
  int get remainingLeaveDays => repository.remainingLeaveDays;

  Future<bool> checkIn() async {
    if (busy || checkedIn) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final time = _now();
      await repository.recordAttendance(time);
      checkedInAt = time;
      checkedIn = true;
      return true;
    } catch (_) {
      error = 'Could not record attendance. Try again.';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<bool> requestLeave(DateTime date, String reason) async {
    if (busy) return false;
    final now = _now();
    if (date.isBefore(DateTime(now.year, now.month, now.day))) {
      error = 'Choose today or a future date.';
      notifyListeners();
      return false;
    }
    busy = true;
    error = null;
    notifyListeners();
    try {
      await repository.requestLeave(date, reason);
      return true;
    } on ArgumentError catch (e) {
      error = e.message.toString();
      return false;
    } on StateError catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Could not send the request. Try again.';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }
}
