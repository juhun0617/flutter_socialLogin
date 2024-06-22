import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key? key, required this.user}) : super(key: key);



  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showToast('환영합니다, ${widget.user.displayName}!');
    });
  }
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 60
          ),
          child: Column(
            children: [
              TableCalendar(
                locale: 'ko_KR',
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2023,1,1),
                lastDay: DateTime.utc(2033,12,12),

                calendarFormat: _calendarFormat,
              availableCalendarFormats: const{
                  CalendarFormat.month: 'Month',
                CalendarFormat.twoWeeks: '2 Weeks'
              },
              onFormatChanged: (format){
                  setState(() {
                    _calendarFormat = format;
                  });
              },
              formatAnimationCurve: Curves.easeInOutQuart,
              formatAnimationDuration: Duration(milliseconds: 800),)
            ],
          ),
        )
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}
