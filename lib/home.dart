import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:tennis_booking/court_booking_modal.dart';
import 'package:tennis_booking/main.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:tennis_booking/schedule.dart';
import 'package:tennis_booking/stats.dart';
import 'package:tennis_booking/profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isBookingSheetOpen = false;

  late final List<String> _titles = [
    widget.title,
    'Schedule',
    'Statistics',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.6, 0.7, 1.0],
          colors: [
            backgroundColor,
            Color(0xFF10140E),
            Color.fromARGB(255, 59, 69, 36),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: textColor),
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text(
            // Use specific title for non-home pages, otherwise use widget.title
            _selectedIndex == 0 ? widget.title : _titles[_selectedIndex],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          actions: _selectedIndex == 0
              ? [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.account_circle_rounded),
                        iconSize: 45,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ]
              : [],
        ),
        drawer: NavigationDrawer(
          backgroundColor: backgroundColor,
          indicatorColor: accentColor,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.pop(context); // Close drawer
          },
          children: [
            const Padding(padding: EdgeInsets.all(20)),
            Column(
              children: const [
                CircleAvatar(radius: 40, child: Icon(Icons.person, size: 35)),
                SizedBox(height: 10),
                Text(
                  'John Doe',
                  style: TextStyle(color: textColor, fontSize: 20),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            NavigationDrawerDestination(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? primaryColor : textColor,
              ),
              label: Text(
                'Home',
                style: TextStyle(
                  color: _selectedIndex == 0 ? primaryColor : textColor,
                ),
              ),
            ),
            NavigationDrawerDestination(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 1 ? primaryColor : textColor,
              ),
              label: Text(
                'Settings',
                style: TextStyle(
                  color: _selectedIndex == 1 ? primaryColor : textColor,
                ),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeTab(isBookingSheetOpen: _isBookingSheetOpen),
            const SchedulePage(),
            const StatsPage(),
            const ProfilePage(),
          ],
        ),
        floatingActionButton: _selectedIndex == 0 && !_isBookingSheetOpen
            ? Builder(
                builder: (scaffoldContext) => Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(97, 211, 255, 89),
                        blurRadius: 30,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 65,
                    height: 65,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _isBookingSheetOpen = true;
                        });
                        showBottomSheet(
                          context: scaffoldContext,
                          enableDrag: true,
                          showDragHandle: false,
                          backgroundColor: const Color(0xFF121212),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.62,
                              width: MediaQuery.of(context).size.width,
                              child: CourtBookingModal(
                                onClose: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ).closed.then((_) {
                          setState(() {
                            _isBookingSheetOpen = false;
                          });
                        });
                      },
                      elevation: 0,
                      tooltip: 'New Booking',
                      shape: const CircleBorder(),
                      backgroundColor: accentColor,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: !_isBookingSheetOpen
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF202025),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(111, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.home, size: 28),
                          color: _selectedIndex == 0
                              ? accentColor
                              : Colors.white54,
                          onPressed: () => setState(() => _selectedIndex = 0),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month, size: 28),
                          color: _selectedIndex == 1
                              ? accentColor
                              : Colors.white54,
                          onPressed: () => setState(() => _selectedIndex = 1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart, size: 28),
                          color: _selectedIndex == 2
                              ? accentColor
                              : Colors.white54,
                          onPressed: () => setState(() => _selectedIndex = 2),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person, size: 28),
                          color: _selectedIndex == 3
                              ? accentColor
                              : Colors.white54,
                          onPressed: () => setState(() => _selectedIndex = 3),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final bool isBookingSheetOpen;

  const HomeTab({super.key, required this.isBookingSheetOpen});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime _selectedDate = DateTime.now();
  int _selectedSport = 0; // 0 = Tennis, 1 = Pickle Ball
  int _currentBookingPage = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting text - hides when booking sheet is open
          AnimatedOpacity(
            opacity: widget.isBookingSheetOpen ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedSlide(
              offset: widget.isBookingSheetOpen
                  ? const Offset(0, -1)
                  : Offset.zero,
              duration: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Hi, Rajesh Sharma',
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Book a court',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSlide(
            offset: widget.isBookingSheetOpen
                ? const Offset(0, -0.35)
                : Offset.zero,
            duration: const Duration(milliseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
                  child: Text(
                    DateFormat('MMM').format(_selectedDate).toUpperCase(),
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 14,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    onDateChange: (selectedDate) {
                      // Allow selection of today and future dates only
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);
                      final selected = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                      );

                      // Calculate the difference in days
                      final difference = selected.difference(today).inDays;

                      // Allow only next 7 days (0 to 6)
                      if (difference < 0 || difference > 6) {
                        return;
                      }

                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    },
                    headerProps: const EasyHeaderProps(showHeader: false),
                    timeLineProps: const EasyTimeLineProps(
                      hPadding: 0,
                      separatorPadding: 10,
                    ),
                    activeColor: accentColor,
                    dayProps: EasyDayProps(
                      height: 90,
                      width: 70,
                      dayStructure: DayStructure.dayStrDayNum,
                      todayStyle: const DayStyle(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        dayNumStyle: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                        ),
                        dayStrStyle: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      activeDayStyle: const DayStyle(
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        dayNumStyle: TextStyle(
                          color: backgroundColor,
                          fontSize: 28,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                        ),
                        dayStrStyle: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      inactiveDayStyle: DayStyle(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: secondaryColor, width: 0.2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        dayNumStyle: const TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.bold,
                        ),
                        dayStrStyle: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),

                // Sport Toggle Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 0, 10),
                  child: Container(
                    height: 35,
                    width: 300,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFF292931)),
                    ),
                    child: Stack(
                      children: [
                        // Animated selection indicator
                        AnimatedAlign(
                          alignment: _selectedSport == 0
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          child: FractionallySizedBox(
                            widthFactor: 0.5,
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        // Toggle buttons row
                        Row(
                          children: [
                            // Tennis button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedSport = 0),
                                behavior: HitTestBehavior.opaque,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 50),
                                  style: TextStyle(
                                    color: _selectedSport == 0
                                        ? backgroundColor
                                        : textColor,
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.sports_tennis,
                                          size: 20,
                                          color: _selectedSport == 0
                                              ? backgroundColor
                                              : textColor,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text('Tennis'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Pickle Ball button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedSport = 1),
                                behavior: HitTestBehavior.opaque,
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 50),
                                  style: TextStyle(
                                    color: _selectedSport == 1
                                        ? backgroundColor
                                        : textColor,
                                    fontSize: 16,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/pickle_ball.svg',
                                        width: 20,
                                        height: 20,
                                        colorFilter: ColorFilter.mode(
                                          _selectedSport == 1
                                              ? backgroundColor
                                              : textColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Pickle Ball'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Upcoming Bookings',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 18,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            height: 130,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              onPageChanged: (index) {
                setState(() {
                  _currentBookingPage = index;
                });
              },
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 20, top: 15),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: secondaryColor, width: 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.sports_tennis,
                              size: 20,
                              color: accentColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tennis',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right_rounded,
                              size: 18,
                              color: secondaryColor,
                            ),
                            Text(
                              'Today, ',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '5:00 PM ',
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Court 1',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  widthFactor: 0.6,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  widthFactor: 0.7,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  widthFactor: 0.7,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                Align(
                                  widthFactor: 0.7,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: backgroundColor,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(60, 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'View',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Dot indicators
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentBookingPage == index ? 15 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentBookingPage == index
                        ? const Color.fromARGB(38, 201, 199, 199)
                        : primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'Recent',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 18,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ], //Children of column
      ),
    );
  }
}
