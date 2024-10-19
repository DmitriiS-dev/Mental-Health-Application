import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:project_helper/models/event_model.dart';
import 'package:project_helper/models/options_events.dart';
import 'package:project_helper/screens/events_filters.dart';

void main() async {
  runApp(const ActivityPage());
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  List<Event> eventList = [];

  //showing events - filtered:
  List<Event> filteredEventList = [];

  //selected event types - list
  List<EventOption> selectedEventType = [];

  List<EventOption> sportsOptions = [
    EventOption(name: 'Basketball', icon: Icons.sports_basketball),
    EventOption(name: 'Volleyball', icon: Icons.sports_volleyball),
    EventOption(name: 'Football', icon: Icons.sports_soccer),
    EventOption(name: 'Tennis', icon: Icons.sports_tennis),
    EventOption(name: 'Baseball', icon: Icons.sports_baseball),
    EventOption(name: 'Swimming', icon: Icons.pool),
  ];

  //Animation:
  late AnimationController _controller;
  late Animation<double> _animation;

  //filters to apply:
  String selectedCity = 'All';
  String selectedGender = 'All';

  @override
  void initState() {
    super.initState();

    //Animation stuff:
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    retrieveData();
  }

  //Animation:
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity',
      home: Scaffold(
        body: Column(
          children: [
            // Padding to move the Row down the page
            Padding(
              padding:
                  const EdgeInsets.only(top: 65.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Choose event type filter
                  Expanded(
                    child: btnWidget(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        //Open the more filter window and await the result
                        final filters =
                            await Navigator.push<Map<String, String>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreFiltersScreen(
                              selectedCity: selectedCity,
                              selectedGender: selectedGender,
                            ),
                          ),
                        );
                        //Results recieved and applied
                        if (filters != null) {
                          setState(() {
                            selectedCity = filters['city']!;
                            selectedGender = filters['gender']!;
                            applyFilters();
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0), // Adjust vertical padding
                        textStyle: const TextStyle(
                          fontSize: 16, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust button border radius
                        ),
                      ),
                      child: const Text('More Filters'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredEventList.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredEventList.length,
                      itemBuilder: (context, index) {
                        final event = filteredEventList[index];
                        return ListTile(
                          title: Text(event.title ?? 'No Title'),
                          subtitle: Text(
                              '${event.time ?? 'No Time'} - ${event.location ?? 'No Location'}'),
                          trailing: Text(
                              '${event.numberOfPeopleSignedUp ?? 0}/${event.maxNumberOfPeople ?? 0}'),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No events found'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

/*=================
Real Time READ DB
===================
*/

  void retrieveData() {
    ref.child("events").onChildAdded.listen((data) {
      //casting the retrieved data:
      var eventData = data.snapshot.value as Map<Object?, Object?>;
      print(eventData);
      Map<String, dynamic> eventDataMap = eventData.map((key, value) {
        return MapEntry(key.toString(), value);
      });
      //create the object and append to the list:
      Event e = Event.fromJson(eventDataMap);
      setState(() {
        eventList.add(e);
        //apply filters here:
        applyFilters();
      });
    });
  }

/*
================
Event Type Widget
================
*/
  //Choose Event Types Widget:
  Widget btnWidget() {
    return PopupMenuButton<EventOption>(
      onOpened: () {
        _controller.forward(); //animation plays forward
      },
      onCanceled: () {
        _controller.reverse(); //animation plays backwards
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<EventOption>>[
        PopupMenuItem<EventOption>(
          enabled: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  buildSportGrid(
                      sportsOptions, setState), // Pass the setState here
                  const SizedBox(height: 8),
                  // Apply Button - Saves the selected options
                  ElevatedButton(
                    onPressed: () {
                      // Closes the popup menu
                      setState(() {
                        selectedEventType = sportsOptions
                            .where((sport) => sport.selected)
                            .toList();
                      });
                      print(
                          'Selected sports: ${sportsOptions.where((sport) => sport.selected).map((sport) => sport.name).toList()}');
                      Navigator.of(context).pop();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              );
            },
          ),
        ),
      ],
      // Styling here:
      color: const Color.fromRGBO(255, 255, 255, 1),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      offset: const Offset(0, 35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.5), // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Choose event type",
            style: TextStyle(
              fontSize: 16, // Adjust the font size
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.blue, // Change the text color
              letterSpacing: 1.2, // Adjust letter spacing
            ),
          ),
          const SizedBox(width: 4),
          RotationTransition(
              turns: _animation,
              child: SvgPicture.asset(
                'assets/ic_down.svg',
                width: 24,
                height: 24,
              ))
        ],
      ),
    );
  }

  //Separate Widget for each of the Event types:
  Widget buildSportGrid(List<EventOption> options, StateSetter setState) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0), // Adjust the vertical padding here
      child: Container(
        padding: const EdgeInsets.all(
            8.0), // Inner padding for spacing around the sports options
        child: Center(
          child: Wrap(
            spacing: 12.0, // Space between items horizontally
            runSpacing: 8.0, // Space between rows
            children: options.map((option) {
              return GestureDetector(
                onTap: () {
                  // Toggle the selected state
                  setState(() {
                    option.selected = !option.selected; // Toggle selection
                  });
                },
                child: Container(
                  width: 100, // Width of each item
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: option.selected
                        ? Colors.blue
                            .withOpacity(0.2) // Background color if selected
                        : Colors.white, // Default background color
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: option.selected
                          ? Colors.orange
                          : Colors.grey, // Border color based on selection
                      width: 2.0, // Adjust the width of the border if needed
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        option.icon,
                        size: 40,
                        color: option.selected
                            ? Colors.orange
                            : Colors.black, // Icon color based on selection
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: option.selected
                              ? Colors.orange
                              : Colors.black, // Text color based on selection
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

/*
================
Filter Widget Stuff
================
*/
  //filters:
  void applyFilters() {
    setState(() {
      filteredEventList = eventList.where((event) {
        final matchesCity =
            selectedCity == 'All' || event.location == selectedCity;
        final matchesGender =
            selectedGender == 'All' || event.gender == selectedGender;

        return matchesCity && matchesGender;
      }).toList();
    });
  }
}
