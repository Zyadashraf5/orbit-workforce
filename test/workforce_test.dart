import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_workforce/showcase/workforce.dart';

class FailingRepository extends DemoWorkforceRepository {
  @override
  Future<void> recordAttendance(DateTime time) async =>
      throw StateError('Offline');
}

void main() {
  final today = DateTime(2026, 11, 12, 9);
  test('check-in records once and repeated taps do not duplicate it', () async {
    final repo = DemoWorkforceRepository();
    final controller = WorkforceController(repo, now: () => today);
    expect(await controller.checkIn(), isTrue);
    expect(await controller.checkIn(), isFalse);
    expect(repo.attendance, [today]);
    expect(controller.checkedInAt, today);
  });
  test('failed attendance does not claim success and permits retry', () async {
    final controller = WorkforceController(
      FailingRepository(),
      now: () => today,
    );
    expect(await controller.checkIn(), isFalse);
    expect(controller.checkedIn, isFalse);
    expect(controller.checkedInAt, isNull);
    expect(controller.busy, isFalse);
    expect(controller.error, isNotNull);
  });
  test('valid leave is pending and updates the remaining allowance', () async {
    final controller = WorkforceController(
      DemoWorkforceRepository(),
      now: () => today,
    );
    final previous = controller.remainingLeaveDays;
    expect(
      await controller.requestLeave(DateTime(2026, 11, 20), '  Family day  '),
      isTrue,
    );
    expect(controller.requests.last.reason, 'Family day');
    expect(controller.requests.last.status, RequestStatus.pending);
    expect(controller.remainingLeaveDays, previous - 1);
  });
  test('duplicate day is rejected without reducing allowance', () async {
    final controller = WorkforceController(
      DemoWorkforceRepository(),
      now: () => today,
    );
    final previous = controller.remainingLeaveDays;
    expect(
      await controller.requestLeave(DateTime(2026, 11, 18), 'Another reason'),
      isFalse,
    );
    expect(controller.remainingLeaveDays, previous);
    expect(controller.requests.length, 2);
  });
  test('past dates and empty reasons do not add requests', () async {
    final controller = WorkforceController(
      DemoWorkforceRepository(),
      now: () => today,
    );
    expect(
      await controller.requestLeave(DateTime(2026, 11, 11), 'Past'),
      isFalse,
    );
    expect(
      await controller.requestLeave(DateTime(2026, 11, 20), '  '),
      isFalse,
    );
    expect(controller.requests.length, 2);
  });
  test('repository does not expose mutable request storage', () {
    final repo = DemoWorkforceRepository();
    expect(() => repo.requests.clear(), throwsUnsupportedError);
  });
}
