import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readbee_lite/core/layouts/main_layout.dart';
import 'package:readbee_lite/core/layouts/responsive.dart';
import 'package:readbee_lite/viewmodels/providers/assignment_provider.dart';
import 'package:readbee_lite/viewmodels/providers/calendar_event_provider.dart';
import 'package:readbee_lite/viewmodels/providers/completion_rate_provider.dart';
import 'package:readbee_lite/viewmodels/providers/grade_level_provider.dart';
import 'package:readbee_lite/viewmodels/providers/section_provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusPage extends ConsumerStatefulWidget {
  const StatusPage({super.key});

  static final List<OverlayEntry> _notifications = [];

  @override
  ConsumerState<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends ConsumerState<StatusPage> {
  bool _notificationShown = false;

  @override
  Widget build(BuildContext context) {
    final assignmentAsync = ref.watch(assignmentProvider);
    ref.watch(appointmentsProvider);
    ref.watch(gradeLevelProvider);
    ref.watch(sectionProvider);
    ref.watch(gradeRateProvider);

    assignmentAsync.whenData((assignments) {
      if (assignments == null) return;

      final pendingAssignment = assignments.firstWhere(
        (a) => a.confirmationStatus != 'confirmed',
        orElse: () => assignments.first,
      );

      final hasUnconfirmed = assignments.any(
        (a) => a.confirmationStatus != 'confirmed',
      );

      if (!hasUnconfirmed) return;

      if (_notificationShown) return;

      _notificationShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTopRightNotification(context, pendingAssignment.assignmentId);
      });
    });

    return Responsive(
      mobile: ShowCaseWidget(builder: (context) => const MobileMainLayout()),
      tablet: ShowCaseWidget(builder: (context) => const TabletMainLayout()),
    );
  }

  void _showTopRightNotification(BuildContext context, String assignmentId) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (context) => SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.assignment, color: Colors.blue),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  'You have been assigned to an evaluation.',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  overlayEntry.remove();

                                  StatusPage._notifications.remove(
                                    overlayEntry,
                                  );
                                },
                                child: const Text('LATER'),
                              ),

                              const SizedBox(width: 8),

                              ElevatedButton(
                                onPressed: () async {
                                  final supabase = Supabase.instance.client;

                                  await supabase
                                      .from('assigned_evaluators')
                                      .update({
                                        'confirmation_status': 'confirmed',
                                      })
                                      .eq('assignment_id', assignmentId);

                                  overlayEntry.remove();

                                  StatusPage._notifications.remove(
                                    overlayEntry,
                                  );

                                  ref.invalidate(assignmentProvider);
                                },
                                child: const Text('CONFIRM'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    StatusPage._notifications.add(overlayEntry);

    debugPrint('SHOWING NOTIFICATION Assignment');

    Overlay.of(context, rootOverlay: true).insert(overlayEntry);
  }
}
