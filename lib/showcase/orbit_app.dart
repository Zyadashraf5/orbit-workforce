import 'package:flutter/material.dart';
import 'workforce.dart';

const _ink = Color(0xFF173B54);
const _teal = Color(0xFF0D766E);
const _muted = Color(0xFF617583);
const _canvas = Color(0xFFF3F7F8);

class OrbitApp extends StatelessWidget {
  const OrbitApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Orbit Workforce',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(
        seedColor: _teal,
        primary: _teal,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: _canvas,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: _ink),
        titleLarge: TextStyle(color: _ink, fontWeight: FontWeight.w700),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    home: const OrbitWorkspace(),
  );
}

class OrbitWorkspace extends StatefulWidget {
  const OrbitWorkspace({super.key, this.controller});
  final WorkforceController? controller;
  @override
  State<OrbitWorkspace> createState() => _OrbitWorkspaceState();
}

class _OrbitWorkspaceState extends State<OrbitWorkspace> {
  late final WorkforceController controller;
  int selected = 0;
  bool arabic = false;
  String t(String en, String ar) => arabic ? ar : en;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? WorkforceController(DemoWorkforceRepository());
    controller.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (wide) _sidebar(),
                Expanded(
                  child: Column(
                    children: [
                      _topbar(wide),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(wide ? 36 : 20),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1120),
                              child: selected == 0
                                  ? _overview(wide)
                                  : selected == 1
                                  ? _attendance(wide)
                                  : _requests(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selected,
                  onDestinationSelected: (value) =>
                      setState(() => selected = value),
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.grid_view_rounded),
                      label: t('Overview', 'الرئيسية'),
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.schedule_rounded),
                      label: t('Attendance', 'الحضور'),
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.inbox_outlined),
                      label: t('Requests', 'الطلبات'),
                    ),
                  ],
                ),
        );
      },
    ),
  );

  Widget _sidebar() => Container(
    width: 238,
    color: _ink,
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        const Row(
          children: [
            Icon(Icons.blur_circular, color: Color(0xFF89E0D0), size: 34),
            SizedBox(width: 10),
            Text(
              'orbit',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 44, top: 2),
          child: Text(
            'WORKFORCE',
            style: TextStyle(
              color: Color(0xFF9AB7C8),
              fontSize: 10,
              letterSpacing: 2.5,
            ),
          ),
        ),
        const SizedBox(height: 54),
        Text(
          t('YOUR WORKSPACE', 'مساحة العمل'),
          style: const TextStyle(
            color: Color(0xFF9AB7C8),
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        for (int i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              selected: selected == i,
              selectedTileColor: const Color(0xFF2A5369),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Icon(
                [
                  Icons.grid_view_rounded,
                  Icons.schedule_rounded,
                  Icons.inbox_outlined,
                ][i],
                color: selected == i
                    ? const Color(0xFF89E0D0)
                    : const Color(0xFFBED0DA),
              ),
              title: Text(
                [
                  t('Overview', 'الرئيسية'),
                  t('Attendance', 'الحضور'),
                  t('Requests', 'الطلبات'),
                ][i],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              onTap: () => setState(() => selected = i),
            ),
          ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF24495F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_awesome_outlined, color: Color(0xFFF5C77E)),
              const SizedBox(height: 12),
              Text(
                t('A little more clarity.', 'يوم عمل أوضح.'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                t(
                  'Your workday, in one place.',
                  'كل تفاصيل يومك في مكان واحد.',
                ),
                style: const TextStyle(color: Color(0xFFBED0DA), fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Portfolio edition · 2026',
          style: TextStyle(color: Color(0xFF9AB7C8), fontSize: 10),
        ),
      ],
    ),
  );

  Widget _topbar(bool wide) => Container(
    padding: EdgeInsets.symmetric(horizontal: wide ? 36 : 20, vertical: 15),
    color: Colors.white,
    child: Row(
      children: [
        if (!wide)
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.blur_circular, color: _teal, size: 30),
          ),
        Expanded(
          child: Text(
            wide
                ? t('Workspace / Employee portal', 'مساحة العمل / بوابة الموظف')
                : 'Orbit Workforce',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => arabic = !arabic),
          child: Text(arabic ? 'English' : 'العربية'),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFE0EEEA),
          child: Text(
            'SA',
            style: TextStyle(
              color: _teal,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _heading(String eyebrow, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: _teal,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: _muted, fontSize: 13, height: 1.8),
        ),
      ],
    ),
  );

  Widget _demoNote() => Container(
    margin: const EdgeInsets.only(bottom: 24),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFE3EEE9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.science_outlined, size: 18, color: _teal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            t(
              'Offline demo · Fictional employee data. Changes reset when you restart.',
              'عرض محلي · بيانات موظف وهمية. التغييرات لا تُحفظ بعد إعادة التشغيل.',
            ),
            style: const TextStyle(fontSize: 11, color: _teal, height: 1.7),
          ),
        ),
      ],
    ),
  );

  Widget _overview(bool wide) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        t('A CALMER WORKDAY', 'يوم عمل أكثر هدوءًا'),
        t('Good morning, Sara', 'صباح الخير، سارة'),
        t('Here is your workday at a glance.', 'كل تفاصيل يوم عملك في لمحة.'),
      ),
      _demoNote(),
      Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFFF5C77E),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    t('YOUR NEXT GREAT DAY', 'خطوة جديدة ليوم مثمر'),
                    style: const TextStyle(
                      color: Color(0xFFBED0DA),
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              t(
                'Small steps. Meaningful progress.',
                'خطوات بسيطة. إنجاز يستحق.',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: wide ? 30 : 23,
                fontWeight: FontWeight.w600,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t(
                'Your team is ready. Start with a quick check-in.',
                'فريقك مستعد. ابدأ يومك بتسجيل حضورك.',
              ),
              style: const TextStyle(color: Color(0xFFBED0DA), fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => setState(() => selected = 1),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(t('Open attendance', 'فتح سجل الحضور')),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      LayoutBuilder(
        builder: (context, box) => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _stat(
              t('Attendance', 'الحضور'),
              '96%',
              t('Sample monthly rate', 'نسبة شهرية توضيحية'),
              Icons.event_available_outlined,
              box.maxWidth,
            ),
            _stat(
              t('Leave balance', 'رصيد الإجازات'),
              '${controller.remainingLeaveDays}',
              t('Days available to request', 'أيام متاحة للطلب'),
              Icons.spa_outlined,
              box.maxWidth,
            ),
            _stat(
              t('Your requests', 'طلباتك'),
              '${controller.requests.length}',
              t('Track every request', 'تابع حالة كل طلب'),
              Icons.inbox_outlined,
              box.maxWidth,
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              t('Team noticeboard', 'لوحة الفريق'),
              t('STAY IN THE LOOP', 'آخر المستجدات'),
            ),
            const SizedBox(height: 20),
            _notice(
              Icons.lightbulb_outline,
              t('Make space for focused work', 'مساحة للعمل بتركيز'),
              t(
                'Our sample team has focus hours from 10:00 to 12:00.',
                'وقت التركيز للفريق التجريبي من ١٠ صباحًا إلى ١٢ ظهرًا.',
              ),
            ),
            const Divider(height: 32),
            _notice(
              Icons.groups_outlined,
              t('Monthly team catch-up', 'لقاء الفريق الشهري'),
              t(
                'A fictional event for this portfolio preview.',
                'موعد توضيحي ضمن نسخة العرض.',
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _stat(
    String label,
    String value,
    String note,
    IconData icon,
    double width,
  ) => SizedBox(
    width: width >= 600 ? (width - 32) / 3 : width,
    child: _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _teal, size: 23),
              const Spacer(),
              const Icon(Icons.north_east, size: 16, color: _muted),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: _ink,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 5),
          Text(note, style: const TextStyle(fontSize: 10, color: _muted)),
        ],
      ),
    ),
  );

  Widget _attendance(bool wide) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        t('BE PRESENT', 'ابدأ يومك'),
        t('Attendance, simplified', 'حضورك، ببساطة'),
        t(
          'A clear view of your time and daily rhythm.',
          'نظرة واضحة على وقتك وتفاصيل يومك.',
        ),
      ),
      _demoNote(),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              t('Today’s check-in', 'تسجيل حضور اليوم'),
              t('LOCAL SESSION', 'جلسة محلية'),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF5F2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    controller.checkedIn
                        ? Icons.check_circle_outline
                        : Icons.fingerprint,
                    size: 58,
                    color: _teal,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    controller.checkedIn
                        ? t('You’re checked in', 'تم تسجيل حضورك')
                        : t('Ready when you are', 'جاهزون عندما تكون مستعدًا'),
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t(
                      'Demo session · No GPS or real attendance is submitted',
                      'جلسة تجريبية · لا نستخدم موقعك أو نسجل حضورًا حقيقيًا',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: _muted),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.checkedIn || controller.busy
                        ? null
                        : controller.checkIn,
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(
                      controller.checkedIn
                          ? t(
                              'Recorded for this session',
                              'تم التسجيل لهذه الجلسة',
                            )
                          : t('Check in to demo', 'تسجيل حضور تجريبي'),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  controller.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              t('Recent activity', 'آخر النشاطات'),
              t('SAMPLE RECORDS', 'سجلات توضيحية'),
            ),
            const SizedBox(height: 18),
            if (controller.checkedIn)
              _notice(
                Icons.check_circle_outline,
                t('Current session', 'الجلسة الحالية'),
                t('Check-in saved in memory', 'تم حفظ الحضور في الذاكرة'),
              ),
            _notice(
              Icons.schedule,
              t('Wednesday · 11 Nov', 'الأربعاء · ١١ نوفمبر'),
              '09:00 — 17:00',
            ),
            const Divider(height: 24),
            _notice(
              Icons.schedule,
              t('Tuesday · 10 Nov', 'الثلاثاء · ١٠ نوفمبر'),
              '08:55 — 17:05',
            ),
          ],
        ),
      ),
    ],
  );

  Widget _requests() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _heading(
        t('PLAN AHEAD', 'خطط ليومك'),
        t('Time for yourself', 'وقت لنفسك'),
        t(
          'Submit a leave request and follow its progress.',
          'قدّم طلب إجازة وتابع حالته بوضوح.',
        ),
      ),
      _demoNote(),
      _card(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t('Your leave allowance', 'رصيد إجازاتك'),
                    style: const TextStyle(fontSize: 13, color: _muted),
                  ),
                  Text(
                    '${controller.remainingLeaveDays} ${t('days', 'يوم')}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: _newRequest,
              icon: const Icon(Icons.add, size: 18),
              label: Text(t('Request', 'طلب جديد')),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(
              t('Request history', 'سجل الطلبات'),
              t('ALL REQUESTS', 'كل الطلبات'),
            ),
            const SizedBox(height: 16),
            for (final request in controller.requests.reversed)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF5F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.beach_access_outlined,
                        color: _teal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.reason,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${request.date.day}/${request.date.month}/${request.date.year} · ${t('1 day', 'يوم واحد')}',
                            style: const TextStyle(fontSize: 11, color: _muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: request.status == RequestStatus.approved
                            ? const Color(0xFFE3F2EA)
                            : const Color(0xFFFBF0DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        request.status == RequestStatus.approved
                            ? t('Approved', 'مقبول')
                            : t('Pending', 'قيد المراجعة'),
                        style: TextStyle(
                          fontSize: 10,
                          color: request.status == RequestStatus.approved
                              ? _teal
                              : const Color(0xFF896016),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );

  Future<void> _newRequest() async {
    final reason = TextEditingController();
    DateTime date = DateTime.now().add(const Duration(days: 1));
    String? error;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(t('Request a day off', 'طلب يوم إجازة')),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(
                    'Demo only — no request reaches an employer.',
                    'عرض تجريبي — لن يُرسل الطلب لأي جهة عمل.',
                  ),
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(now.year, now.month, now.day),
                      lastDate: DateTime(now.year + 1, now.month, now.day),
                    );
                    if (picked != null) setDialogState(() => date = picked);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text('${date.day}/${date.month}/${date.year}'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reason,
                  maxLength: 120,
                  decoration: InputDecoration(labelText: t('Reason', 'السبب')),
                ),
                if (error != null)
                  Text(
                    error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t('Cancel', 'إلغاء')),
            ),
            FilledButton(
              onPressed: () async {
                final ok = await controller.requestLeave(date, reason.text);
                if (!dialogContext.mounted) return;
                if (ok) {
                  Navigator.pop(dialogContext);
                } else {
                  setDialogState(() => error = controller.error);
                }
              },
              child: Text(t('Submit demo request', 'إضافة طلب تجريبي')),
            ),
          ],
        ),
      ),
    );
    // Wait until the dialog's closing transition releases its input field.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    reason.dispose();
  }

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE0E8EC)),
    ),
    child: child,
  );
  Widget _sectionTitle(String title, String label) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          color: _teal,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
      const SizedBox(height: 7),
      Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: _ink,
        ),
      ),
    ],
  );
  Widget _notice(IconData icon, String title, String body) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: _teal, size: 23),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              body,
              style: const TextStyle(fontSize: 11, color: _muted, height: 1.8),
            ),
          ],
        ),
      ),
    ],
  );
}
