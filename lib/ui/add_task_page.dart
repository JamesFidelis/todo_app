import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/widgets/buttons.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/input_fields.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  var _selectDate = DateTime.now();
  String _startTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  String _endTime = '12:50';
  int _remindTime = 5;
  List<int> _selectRemind = [5, 10, 15, 20, 25, 30];
  String _repeatTimes = 'None';
  List<String> _selectRepeat = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedIndex = 0;

  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.backgroundColor,
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              myInputField(
                title: 'Title',
                hint: 'Enter the task title',
                controller: _titleController,
              ),
              myInputField(
                title: 'Note',
                hint: 'Enter your note here.',
                controller: _noteController,
              ),
              myInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_month),
                  onPressed: () {
                    _getUserPickedDate();
                    print(DateFormat.yMd().format(_selectDate));
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: myInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getUserPickedTime(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_outlined)),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: myInputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                            onPressed: () {
                              _getUserPickedTime(isStartTime: false);
                            },
                            icon: Icon(Icons.access_time_outlined))),
                  ),
                ],
              ),
              myInputField(
                title: 'Remind',
                hint: '$_remindTime Minutes Early',
                widget: DropdownButton(
                  underline: Container(
                    height: 0,
                    width: 0,
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                  ),
                  elevation: 4,
                  style: subTitleStyle,
                  items:
                      _selectRemind.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.toString()),
                      value: value.toString(),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _remindTime = int.parse(value!);
                    });
                  },
                ),
              ),
              myInputField(
                title: 'Repeat',
                hint: _repeatTimes,
                widget: DropdownButton(
                  underline: Container(
                    height: 0,
                    width: 0,
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 32,
                  ),
                  elevation: 4,
                  style: subTitleStyle,
                  items: _selectRepeat
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _repeatTimes = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  CustomButtom(
                    label: 'Create Task',
                    icon: Icons.add,
                    onTap: () => _validateData(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addDataToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All required fields must be filled',
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.black,
          colorText: Colors.red,
          icon: Icon(
            Icons.warning,
            color: Get.isDarkMode ? Colors.red : Colors.yellowAccent,
          ),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  _addDataToDB() async {
    await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _remindTime,
            repeat: _repeatTimes,
            color: _selectedIndex,
            isCompleted: 0));
  }

  _appBar(BuildContext context) => AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20.0,
            color: Get.isDarkMode ? Colors.white : Colors.black,
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

  _colorPallete() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color',
            style: titleStyle,
          ),
          Wrap(
            children: List<Widget>.generate(
                3,
                (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, right: 4.0),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: index == 0
                              ? primaryClr
                              : index == 1
                                  ? pinkClr
                                  : yellowClr,
                          child: _selectedIndex == index
                              ? Icon(
                                  Icons.done,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : Container(),
                        ),
                      ),
                    )),
          )
        ],
      );

  _getUserPickedDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2040));

    if (pickedDate != null) {
      setState(() {
        _selectDate = pickedDate;
      });
    } else {
      print('Date is null');
    }
  }

  _getUserPickedTime({required bool isStartTime}) async {
    var _timePicker = await _showPickedTime();
    String myTime = _timePicker.format(context);
    if (_timePicker == null) {
      print('Time is Cancelled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = myTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = myTime;
      });
    }
  }

  _showPickedTime() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(hour: 9, minute: 50));
  }
}
