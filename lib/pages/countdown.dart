import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:countdown_timer/widgets/round-button.dart';
import 'package:countdown_timer/pages/list.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({super.key});

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage>
 with TickerProviderStateMixin {
  late AnimationController controller;
  bool isPlaying = false;
  
  String get countText{
    Duration count = controller.duration! * controller.value;
    return
    controller.isDismissed? 
    '${(controller.duration!.inHours).toString().padLeft(2,'0')}:${(controller.duration!.inMinutes % 60).toString().padLeft(2,'0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2,'0')}':
    '${(count.inHours).toString().padLeft(2,'0')}:${(count.inMinutes % 60).toString().padLeft(2,'0')}:${(count.inSeconds % 60).toString().padLeft(2,'0')}';

  }

 

  @override
  void initState(){ 
    super.initState();
    controller = AnimationController(vsync: this,
     duration: const Duration(seconds: 0),
     );
     controller.addListener(() {
      
      if(controller.isDismissed){
        setState(() {
          isPlaying = false;
        });
      }
     });
  }

@override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (controller.isDismissed){
                  showModalBottomSheet(context: context,
                      builder: (context)=>Container(
                        height: 300,
                        child: CupertinoTimerPicker(
                          initialTimerDuration: controller.duration!,
                          onTimerDurationChanged: (time){
                            setState(() {
                              controller.duration = time;
                            });
                          }),
                      ),
                    );
                  }
                },
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Text(
                    countText,
                    style: const TextStyle(
                      fontSize: 60,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
              final selectedTimerType = await Navigator.push(context,
              MaterialPageRoute(builder: (context) =>const ListPage()),
              );
              if(selectedTimerType!=null){
                setState(() {
                 controller.duration = selectedTimerType.duration;
                });
              }
            },
            child: const RoundButton(
              icon: Icons.access_alarm
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: controller.duration!.inSeconds >0
                  ? (){
                      if (controller.isAnimating){
                      controller.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    }else{
                    controller.reverse(from: controller.value
                    == 0?1.0: controller.value);
                    setState(() {
                      isPlaying = true;
                    });
                    }
                  }
                  : null,
                  child: RoundButton(
                    icon: isPlaying == true? Icons.pause : Icons.play_arrow,
                    )
                  ),
                GestureDetector(
                  onTap: (){
                    controller.reset();
                    setState(() {
                      isPlaying = false;
                    });
                  },
                  child: const RoundButton(
                    icon: Icons.restart_alt
                    )
                  ),
              ],
            ),
          ),
      ],)
    );
  }
}