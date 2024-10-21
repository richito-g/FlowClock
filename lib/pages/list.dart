import 'dart:convert';
import 'package:countdown_timer/widgets/timebutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class TimerSetting {
  final String name;
  final Duration duration;

  TimerSetting(this.name, this.duration);

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration': duration.inSeconds,
  };

  factory TimerSetting.fromJson(Map<String, dynamic> json) {
    return TimerSetting(
      json['name'],
      Duration(seconds: json['duration']),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListPageState createState() => _ListPageState();
}


class _ListPageState extends State<ListPage> {
  List<TimerSetting>_customTimers = [];
  @override
  void initState(){
    super.initState();
    _loadCustomTimers();
  }
  Future<void> _loadCustomTimers() async{
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('timer_settings');
    if (settingsJson != null) {
      final List<dynamic> decodedJson = json.decode(settingsJson);
      final settings = decodedJson.map((e) => TimerSetting.fromJson(e)).toList();
      setState(() {
        _customTimers = settings;
      });
  }
}
  Future<void> _addCustomTimer() async {
    if(_customTimers.length>=10){
      showDialog(context: context,
       builder: (context){
        return AlertDialog(
          title: Text("Timer Limit Reached"),
          content: Text("You can't add more than 10 presets."),
          actions: [
            TextButton(onPressed:(){
              Navigator.of(context).pop();
            },
            
            child: Text('Ok')),
          ],
        );
       }
       );
       return;
    }
    String name = '';
    Duration duration = Duration.zero;
    final prefs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Custom Timer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hms,
                    onTimerDurationChanged: (newDuration){
                    duration = newDuration;
                  }),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if(name.isNotEmpty && duration > Duration.zero){
              final newTimer = TimerSetting(name, duration);
                setState(() {
                  _customTimers.add(newTimer);
                });
                final settingsJson = json.encode(_customTimers.map((e) => e.toJson()).toList());
                prefs.setString('timer_settings', settingsJson);
                Navigator.of(context).pop();
                } 
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future <void> _deleteCustomTimer(int index) async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _customTimers.removeAt(index);
    });
    final settingsJson = json.encode(_customTimers.map((e) => e.toJson()).toList());
    prefs.setString('timer_settings', settingsJson);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Colors.grey[900],
        title: const Text('Select Timer',
        style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: _addCustomTimer, icon: const Icon(Icons.add)),
        ],
      ),
      body: ListView(
        
        padding: const EdgeInsets.all(16.0),
        children :[
        TimerButton(
            title: 'Pomodoro Timer Study',
            duration: Duration(minutes: 25),
            onTap: () {
              Navigator.pop(context, TimerSetting('Pomodoro Study', Duration(minutes: 25)));
            },
          ),
          TimerButton(
            title: 'Pomodoro Timer Break',
            duration: Duration(minutes: 5),
            onTap: () {
              Navigator.pop(context, TimerSetting('Pomodoro Break', Duration(minutes: 5)));
            },
          ),
        ..._customTimers.asMap().entries.map((entry) {
            int index = entry.key;
            TimerSetting timer = entry.value;
            return TimerButton(
              title: timer.name,
              duration: timer.duration,
              onTap: () {
                Navigator.pop(context, timer);
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Timer'),
                      content: Text('Are you sure you want to delete the timer "${timer.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteCustomTimer(index);
                            Navigator.of(context).pop();
                          },
                          child: Text('Delete'),
                        ),
                      ],
                     );
                  },
                );
              },
            );
          }).toList(),
        ],
      )
    );
  }
}

