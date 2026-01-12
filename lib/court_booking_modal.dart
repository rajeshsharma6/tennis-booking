import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:tennis_booking/booking_details_step.dart';

// --- Constants ---
const Color kBackgroundColor = Color(0xFF121212);
const Color kNeonGreen = Color(0xFFCCFF00);
const Color kNeonRed = Color(0xFFFF3131); // Neon red for the 'Now' line
const Color kDarkSlate = Color(0xFF2A2A2A);
const Color kGreyText = Colors.grey;

// --- Models ---
enum SlotStatus { empty, booked, coaching, pickleball }

class TimeSlot {
  final String timeLabel; // e.g., "16:00", "16:30"
  final SlotStatus status;
  final int playerCount;
  final List<String> playerAvatars; // URL or asset paths

  TimeSlot({
    required this.timeLabel,
    required this.status,
    this.playerCount = 0,
    this.playerAvatars = const [],
  });
}

class CourtData {
  final String courtName;
  final List<TimeSlot> slots;

  CourtData({required this.courtName, required this.slots});
}

// --- Hatched Painter ---
class HatchedPainter extends CustomPainter {
  final Color stripeColor;
  final Color backgroundColor;

  HatchedPainter({required this.stripeColor, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != Colors.transparent) {
      final Paint backgroundPaint = Paint()..color = backgroundColor;
      canvas.drawRect(Offset.zero & size, backgroundPaint);
    }

    final Paint stripePaint = Paint()
      ..color = stripeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double spacing = 10.0;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        stripePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- Main Modal Widget ---
class CourtBookingModal extends StatefulWidget {
  final VoidCallback onClose;

  const CourtBookingModal({super.key, required this.onClose});

  @override
  State<CourtBookingModal> createState() => _CourtBookingModalState();
}

class _CourtBookingModalState extends State<CourtBookingModal> {
  late LinkedScrollControllerGroup _scrollGroup;
  late ScrollController _headerController;
  late List<ScrollController> _courtControllers;
  late ScrollController _lineController; // For the continuous red line

  // Dummy Data
  // Generate 24-hour time labels (00:00 to 23:30)
  late final List<String> _timeLabels = List.generate(48, (index) {
    final int hour = index ~/ 2;
    final int minute = (index % 2) * 30;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  });

  late List<CourtData> _courts;

  int? _selectedCourtIndex;
  List<int> _selectedSlotIndices = []; // Changed to List for multiple selection
  int _currentStep = 0;

  // Constant width for slots including margin logic
  final double _slotWidth = 84.0; // 80 content + 4 gap
  final double _gap = 4.0;

  @override
  void initState() {
    super.initState();
    _scrollGroup = LinkedScrollControllerGroup();
    _headerController = _scrollGroup.addAndGet();
    _lineController = _scrollGroup.addAndGet();
    _courts = _generateDummyData();
    _courtControllers = List.generate(
      _courts.length,
      (index) => _scrollGroup.addAndGet(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final now = DateTime.now();
        final double totalMinutes = now.hour * 60 + now.minute.toDouble();
        final double nowOffset = (totalMinutes / 30.0) * _slotWidth + 28;

        // Target scroll: 30 mins (one slot width) before "Now"
        double targetScroll = nowOffset - _slotWidth;
        if (targetScroll < 0) targetScroll = 0;

        if (_headerController.hasClients) {
          _headerController.jumpTo(targetScroll);
        }
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _lineController.dispose();
    for (var controller in _courtControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // kept _generateDummyData as is...
  List<CourtData> _generateDummyData() {
    // Helper to generate 48 slots for each court
    List<TimeSlot> generateSlots(
      List<int> bookedIndices, {
      SlotStatus status = SlotStatus.booked,
      bool coaching = false,
      bool pickleball = false,
    }) {
      return List.generate(48, (index) {
        if (bookedIndices.contains(index)) {
          if (pickleball) {
            return TimeSlot(
              timeLabel: _timeLabels[index],
              status: SlotStatus.pickleball,
            );
          }
          if (coaching) {
            return TimeSlot(
              timeLabel: _timeLabels[index],
              status: SlotStatus.coaching,
            );
          }

          return TimeSlot(
            timeLabel: _timeLabels[index],
            status: SlotStatus.booked,
            playerCount: (index % 3) + 1,
          );
        }
        return TimeSlot(
          timeLabel: _timeLabels[index],
          status: SlotStatus.empty,
        );
      });
    }

    return [
      CourtData(
        courtName: 'Court 1',
        slots: generateSlots([32, 33, 38, 39]), // 16:00-17:00, 19:00-20:00
      ),
      CourtData(
        courtName: 'Court 2',
        slots: generateSlots([
          30,
          31,
          32,
          33,
        ], coaching: true), // 15:00-17:00 Coaching
      ),
      CourtData(
        courtName: 'Court 3',
        slots: generateSlots([34, 35, 36, 37]), // 17:00-19:00
      ),
      CourtData(
        courtName: 'Court 4',
        slots: generateSlots([
          36,
          37,
          38,
          39,
          40,
          41,
        ], pickleball: true), // 18:00 onwards Pickleball
      ),
    ];
  }

  void _handleSlotTap(int courtIndex, int slotIndex) {
    final slot = _courts[courtIndex].slots[slotIndex];

    if (slot.status == SlotStatus.empty) {
      setState(() {
        if (_selectedCourtIndex != courtIndex) {
          // New, different court selected. Reset.
          _selectedCourtIndex = courtIndex;
          _selectedSlotIndices = [slotIndex];
        } else {
          // Same court
          if (_selectedSlotIndices.contains(slotIndex)) {
            _selectedSlotIndices.remove(slotIndex);
            if (_selectedSlotIndices.isEmpty) {
              _selectedCourtIndex = null;
            }
          } else {
            _selectedSlotIndices.add(slotIndex);
            _selectedSlotIndices.sort(); // Keep sorted to simplify logic
          }
        }
      });
    } else if (slot.status == SlotStatus.booked && slot.playerCount < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Request to join sent!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 30 min Labels = 1 slot width
    final double timeLabelWidth = _slotWidth;

    // Calculate "Now" Offset based on current time
    final now = DateTime.now();
    final double totalMinutes = now.hour * 60 + now.minute.toDouble();
    // 30 mins = _slotWidth. So 1 min = _slotWidth / 30.
    final double nowOffset = (totalMinutes / 30.0) * _slotWidth + 28;

    return Container(
      color: kBackgroundColor,
      child: Column(
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: _currentStep == 1
                ? BookingDetailsStep(
                    onBack: () => setState(() => _currentStep = 0),
                    onContinue: widget.onClose,
                  )
                : Stack(
                    children: [
                      Column(
                        children: [
                          // Header Row
                          SizedBox(
                            height: 40, // Increase height to fit alignment
                            child: SingleChildScrollView(
                              controller: _headerController,
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 28),
                                      ..._timeLabels.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final label = entry.value;

                                        double labelX =
                                            28 + (index * timeLabelWidth);
                                        // Hide if strictly overlapping 'Now' label or the line proximity
                                        bool overlapping =
                                            (labelX - nowOffset).abs() < 30;

                                        return Container(
                                          width: timeLabelWidth,
                                          alignment: Alignment.centerLeft,
                                          child: overlapping
                                              ? const SizedBox()
                                              : Text(
                                                  label,
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        );
                                      }),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                  // Now Indicator ON Header
                                  Positioned(
                                    left: nowOffset - 18, // Center text roughly
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kNeonRed,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Text(
                                          'Now',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Courts List
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: _courts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, courtIndex) {
                                final court = _courts[courtIndex];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E1E),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Court Header
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            court.courtName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: 2,
                                              itemBuilder: (context, i) =>
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 4,
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Slots Row
                                      SingleChildScrollView(
                                        controller:
                                            _courtControllers[courtIndex],
                                        scrollDirection: Axis.horizontal,
                                        physics: const ClampingScrollPhysics(),
                                        child: Row(
                                          children: [
                                            ...court.slots.asMap().entries.map((
                                              entry,
                                            ) {
                                              final int slotIndex = entry.key;
                                              final TimeSlot slot = entry.value;

                                              final bool isSelected =
                                                  _selectedCourtIndex ==
                                                      courtIndex &&
                                                  _selectedSlotIndices.contains(
                                                    slotIndex,
                                                  );

                                              // Check Neighbors for merging
                                              final bool nextSelected =
                                                  _selectedCourtIndex ==
                                                      courtIndex &&
                                                  _selectedSlotIndices.contains(
                                                    slotIndex + 1,
                                                  );
                                              final bool prevSelected =
                                                  _selectedCourtIndex ==
                                                      courtIndex &&
                                                  _selectedSlotIndices.contains(
                                                    slotIndex - 1,
                                                  );

                                              return GestureDetector(
                                                onTap: () => _handleSlotTap(
                                                  courtIndex,
                                                  slotIndex,
                                                ),
                                                child: Container(
                                                  // Use fixed full width for the "cell"
                                                  width: _slotWidth,
                                                  height: 50,
                                                  // Padding acts as the visual gap
                                                  // If selected and next is selected, remove right padding (gap)
                                                  // Actually, standard gap is 4.
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        (isSelected &&
                                                            nextSelected)
                                                        ? 0
                                                        : _gap,
                                                  ),
                                                  child: Container(
                                                    // Inner container is the actual Slot UI
                                                    decoration:
                                                        _buildSlotDecoration(
                                                          slot,
                                                          isSelected,
                                                          prevSelected,
                                                          nextSelected,
                                                        ),
                                                    child: _buildSlotContent(
                                                      slot,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '00:00',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Text(
                                            '23:30',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      // Continuous Red Line Overlay
                      Positioned(
                        top: 40,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: SingleChildScrollView(
                            controller: _lineController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: SizedBox(
                              // Width needs to match total slots width roughly
                              // 10 slots * 84 = 840 + padding 28 + 20 = 888 roughly
                              width: _timeLabels.length * _slotWidth + 48,
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: nowOffset,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      color: kNeonRed.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom Continue Button
                      Positioned(
                        left: 60,
                        right: 60,
                        bottom: 30,
                        child: SizedBox(
                          height: 48,
                          child: FilledButton(
                            onPressed: _selectedCourtIndex != null
                                ? () => setState(() => _currentStep = 1)
                                : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: kNeonGreen,
                              disabledBackgroundColor: const Color(
                                0xFF3A3A3A,
                              ), // Grey when disabled
                              foregroundColor: Colors.black,
                              disabledForegroundColor: Colors.white.withOpacity(
                                0.5,
                              ), // Visible when disabled
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildSlotDecoration(
    TimeSlot slot,
    bool isSelected,
    bool prevSelected,
    bool nextSelected,
  ) {
    if (slot.status == SlotStatus.coaching ||
        slot.status == SlotStatus.pickleball) {
      return BoxDecoration(
        color: kDarkSlate,
        borderRadius: BorderRadius.circular(12),
      );
    }

    Color color = kDarkSlate;
    if (slot.status == SlotStatus.empty) {
      color = isSelected ? kNeonGreen : kNeonGreen.withOpacity(0.8);
    }

    // Merging Logic
    BorderRadiusGeometry borderRadius;
    if (isSelected) {
      if (prevSelected && nextSelected) {
        borderRadius = BorderRadius.zero;
      } else if (prevSelected) {
        borderRadius = const BorderRadius.horizontal(
          right: Radius.circular(12),
        );
      } else if (nextSelected) {
        borderRadius = const BorderRadius.horizontal(left: Radius.circular(12));
      } else {
        borderRadius = BorderRadius.circular(12);
      }
    } else {
      borderRadius = BorderRadius.circular(12);
    }

    // Border logic ?
    // If selected, we might want a white border.
    // Similar merging applies.
    BoxBorder? border;

    // Simplifying border: wrap the whole Shape?
    // Individual borders are tricky when merged.
    // Let's use simple color based merging first.
    // If user needs white border on specific edges, it gets complex.
    // Current design: border: isSelected ? Border.all(white)

    // To properly merge borders, we'd need to assume no border on the shared side.
    if (isSelected) {
      border = Border(
        top: const BorderSide(color: Colors.white, width: 2),
        bottom: const BorderSide(color: Colors.white, width: 2),
        left: prevSelected
            ? BorderSide.none
            : const BorderSide(color: Colors.white, width: 2),
        right: nextSelected
            ? BorderSide.none
            : const BorderSide(color: Colors.white, width: 2),
      );
    }

    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: isSelected
          ? [
              BoxShadow(
                color: kNeonGreen.withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ]
          : null,
    );
  }

  Widget _buildSlotContent(TimeSlot slot) {
    // Same as before
    if (slot.status == SlotStatus.coaching) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: HatchedPainter(
            stripeColor: kNeonGreen.withOpacity(0.3),
            backgroundColor: Colors.transparent,
          ),
          child: const Center(
            child: Text(
              'Coaching',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ),
      );
    }

    if (slot.status == SlotStatus.pickleball) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: HatchedPainter(
            stripeColor: Colors.orange.withOpacity(0.5),
            backgroundColor: Colors.transparent,
          ),
          child: const Center(
            child: Text(
              'Pickleball',
              style: TextStyle(color: Colors.orange, fontSize: 10),
            ),
          ),
        ),
      );
    }

    if (slot.status == SlotStatus.booked && slot.playerCount < 4) {
      return const Center(
        child: Icon(Icons.add, color: Colors.white, size: 20),
      );
    }

    return const SizedBox();
  }
}
