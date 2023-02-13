import 'dart:convert';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Service/ThemeServices.dart';
import 'package:todo_app/ui/theme.dart';
import '../Service/NotificationServices.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/widgets/buttons.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

final _taskController = Get.put(TaskController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    notifyHelper = NotifyHelper();
    notifyHelper.requestPermission();
    notifyHelper.initializeNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _appTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 10,
          ),
          _showTasks()
        ],
      ),
    );
  }

  _appBar() => AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeServices().changeThemeMode();
            notifyHelper.displayNotification(
                title: 'You changed your Theme',
                body: Get.isDarkMode
                    ? 'Activated Light Mode'
                    : 'Activated Dark Mode');
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_sharp : Icons.nightlight_round,
            size: 20.0,
            color: Get.isDarkMode ? Colors.yellow : Colors.black,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('images/profile.png'),
          ),
          SizedBox(
            width: 20.0,
          )
        ],
      );

  _appTaskBar() => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                ),
              ],
            ),
            CustomButtom(
              label: 'Add Task',
              icon: Icons.add,
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              },
            )
          ],
        ),
      );

  _addDateBar() => Container(
        child: DatePicker(
          DateTime.now(),
          initialSelectedDate: DateTime.now(),
          width: 80,
          height: 100,
          selectedTextColor: Colors.white,
          selectionColor: primaryClr,
          dateTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey)),
          monthTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey)),
          dayTextStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey)),
          onDateChange: (change) {
            setState(() {
              _selectedDate = change;
            });
            var date = DateFormat.yMMMMd().format(change);
            print(date);
          },
        ),
      );

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task myTask = _taskController.taskList[index];
            if (myTask.repeat == 'Daily') {
              notifyHelper.ScheduleNotification(
                  int.parse(myTask.startTime.toString().split(":")[0]),
                  int.parse(myTask.startTime.toString().split(":")[1]),
                  myTask);
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, myTask);
                            },
                            child: TaskTile(myTask),
                          )
                        ],
                      ),
                    ),
                  ));
            }
            if (myTask.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, myTask);
                            },
                            child: TaskTile(myTask),
                          )
                        ],
                      ),
                    ),
                  ));
            } else {
              return Container();
            }
          });
    }));
  }
}

_showBottomSheet(BuildContext context, Task task) {
  Get.bottomSheet(Container(
    decoration: BoxDecoration(
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    height: task.isCompleted == 1
        ? MediaQuery.of(context).size.height * 0.24
        : MediaQuery.of(context).size.height * 0.35,
    padding: EdgeInsets.only(top: 4),
    child: task.isCompleted == 0
        ? Column(
            children: [
              Container(
                width: 100,
                height: 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
              Spacer(),
              _bottomSheetButtons(
                  context: context,
                  label: 'Task Completed',
                  color: primaryClr,
                  onTap: () {
                    _taskController.markUpdate(task.id!);
                    Get.back();
                  }),
              _bottomSheetButtons(
                  context: context,
                  label: 'Delete Task',
                  color: pinkClr,
                  onTap: () {
                    _taskController.delete(task);
                    Get.back();
                  }),
              SizedBox(
                height: 30.0,
              ),
              _bottomSheetButtons(
                  isClose: true,
                  context: context,
                  label: 'Close',
                  color: Colors.white,
                  onTap: () => Get.back()),
              SizedBox(
                height: 30.0,
              ),
            ],
          )
        : Column(
            children: [
              Container(
                width: 100,
                height: 6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
              ),
              Spacer(),
              _bottomSheetButtons(
                  context: context,
                  label: 'Delete Task',
                  color: pinkClr,
                  onTap: () {
                    _taskController.delete(task);
                    _taskController.getTasks();
                    Get.back();
                  }),
              SizedBox(
                height: 30.0,
              ),
              _bottomSheetButtons(
                  isClose: true,
                  context: context,
                  label: 'Close',
                  color: Colors.white,
                  onTap: () => Get.back()),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
  ));
}

_bottomSheetButtons(
    {required String label,
    Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 55,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: isClose == true ? Colors.grey : color, width: 2)),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Text(
            label,
            style: isClose == true
                ? titleStyle
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
