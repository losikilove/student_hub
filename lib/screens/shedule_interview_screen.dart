import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textform.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';
class ScheduleInterview extends StatefulWidget {
  const ScheduleInterview({super.key});

  @override
  State<ScheduleInterview> createState() => _ScheduleInterviewState();
}

class _ScheduleInterviewState extends State<ScheduleInterview> {
  DateTime selectedDate = DateTime.now();
  bool isChooseTitle = false,isStart = false,isEnd = false;
  TimeOfDay selectedStartTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 0, minute: 0);
  double doubleStartTime = 0,doubleEndTime = 0;
  double timeDiff = 0;
  int hour = 0;
  double minute = 0;
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = DateTime(pickedDate.year,pickedDate.month,pickedDate.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: (){},
        currentContext: context
      ),
      body:InitialBody(
        child: 
          SingleChildScrollView (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Schedule for a video interview",isBold: true,size: 23,),
                SizedBox(
                  height: SpacingUtil.largeHeight,
                ),
                CustomTextForm(controller: TextEditingController(),
                  listErros: const <InvalidationType>[
                    InvalidationType.isBlank
                  ],
                  hintText: "Catch up meeting", 
                  onHelper: ((messageError) {
                    isChooseTitle = messageError == null ? true : false;
                  })
                ),
                SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_month,size: 35,),
                    SizedBox(
                      width: SpacingUtil.mediumHeight,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        selectDate(context);
                      },
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 66, 135, 239)
                      ) ,
                      child: Text('${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',  style:const TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),)
                    )
                  ],
                ),
                SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
                Row(
                  children: [
                    Text("Start Time",style: TextStyle(
                      fontSize: 20,
                      fontWeight:FontWeight.w500
                    )),
                    SizedBox(
                      width: SpacingUtil.mediumHeight,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        selectselectStartTime(context);  
                      },
                      style:ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 66, 135, 239)
                      ) ,
                      child: Text('${selectedStartTime.hour}:${selectedStartTime.minute}',
                      style:const TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),)
                    )
                  ],
                ),
                SizedBox(height: SpacingUtil.smallHeight,),
                Row(
                  children: [
                    Text("End Time",style: TextStyle(
                      fontSize: 20,
                      fontWeight:FontWeight.w500
                    )),
                    SizedBox(
                      width: SpacingUtil.mediumHeight,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        selectTimeEnd(context);
                      },
                      style:ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 66, 135, 239)
                      ) ,
                      child: Text('${selectedEndTime.hour}:${selectedEndTime.minute}',
                        style:const TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),)
                    )
                  ],
                ),
                SizedBox(
                  height: SpacingUtil.mediumHeight,
                ),
                CustomText(text: "Duration: $hour hour $minute minutes",isItalic: true,size: 20,),
                SizedBox(
                  height: SpacingUtil.largeHeight*4,
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(onPressed: (){}, 
                      text: "Cancel",
                      buttonColor: Color.fromARGB(255, 62, 114, 225),
                    ),
                    CustomButton(onPressed: (){}, 
                      text: "Send Invite",
                      isDisabled: !isChooseTitle||!isEnd||!isStart,
                      buttonColor: Color.fromARGB(255, 62, 114, 225),
                    ),
                ],)
              ],
            ),
          ),
        ),
    
    );
  }

  Future<void> selectselectStartTime(BuildContext context) async {
    int? selectedHour;
    int? selectedMinute;
    int initialMinuteIndex = 0; // Chỉ mục ban đầu của phút

    await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250.0,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    if (selectedHour != null && selectedMinute != null) {
                      setState(() {
                        selectedStartTime = TimeOfDay(hour: selectedHour!, minute: selectedMinute!);
                        isStart = true;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Done'),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                          selectedMinute = initialMinuteIndex * 15;
                        },
                        childCount: 24,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('$index'),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          initialMinuteIndex = index;
                          selectedMinute = index * 15;
                        },
                        childCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('${index * 15}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

   Future<void> selectTimeEnd(BuildContext context) async {
    int? selectedHour;
    int? selectedMinute;
    int initialMinuteIndex = 0; // Chỉ mục ban đầu của phút

    await showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250.0,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    if (selectedHour != null && selectedMinute != null) {
                      setState(() {
                        selectedEndTime = TimeOfDay(hour: selectedHour!, minute: selectedMinute!);
                        doubleStartTime = selectedStartTime.hour.toDouble() + (selectedStartTime.minute.toDouble() / 60);
                        doubleEndTime = selectedEndTime.hour.toDouble() + (selectedEndTime.minute.toDouble() / 60);
                        timeDiff = doubleEndTime - doubleStartTime ;
                        hour = timeDiff.truncate();
                        isEnd = true;
                        minute = (timeDiff - timeDiff.truncate()) * 60;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Done'),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                          selectedMinute = initialMinuteIndex * 15;
                        },
                        childCount: 24,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('$index'),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker.builder(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          initialMinuteIndex = index;
                          selectedMinute = index * 15;
                        },
                        childCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                            child: Text('${index * 15}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}