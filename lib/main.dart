import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home :const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

List<Map<String,String>> meeting=[];

  String? _hour, _minute, _time;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    _selectTime(context);
    print(_dateController.text);
    print(_timeController.text);
  }
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && selectedDate != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
      print(_timeController.text);
      meeting.add(
        {
          'title':title.text,
          'description':description.text,
          'date':_dateController.text,
          'time':_timeController.text,
        }
      );
      Navigator.pop(context);
    }
  }
  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting List'),
        actions: [
          IconButton(onPressed: ()
          async {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('add now meeting'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: title,
                        decoration: InputDecoration(
                          labelText: 'Meeting title'
                        ),

                      ),
                      TextFormField(
                        controller: description,
                        decoration: InputDecoration(
                            labelText: 'desciption'
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(15)
                        ),

                        child: TextButton(
                          onPressed: (){
                            _selectDate(context);
                          },
                          child: Text('select date',style: TextStyle(fontSize:20,color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                )
            );
            //_selectDate(context);
          },
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(
        child: ListView.separated(
            itemBuilder:  ((context,index)=>MeetingItem(meeting[index])),
            separatorBuilder: ((context,index)=>Container(height: 5,)),
            itemCount: meeting.length
        ),
      ),
    );
  }
}
Widget MeetingItem(Map meet)=> Container(
  margin: const EdgeInsets.all(15.0),
  padding: const EdgeInsets.all(10.0),
  decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(20)
  ),
  width: double.infinity,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(meet['title'],style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),),
      Text(meet['description'],style: TextStyle(
        fontSize: 20,
        color: Colors.grey,
      ),),
      Row(
        children: [
          Text('${meet['time']} -${meet['date']}',style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(15)
            ),

            child: TextButton(
              onPressed: ()async{
                const url = 'http://meet.google.com/kaq-obdh-yue';
                final uri = Uri.parse(url);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: Text('Join',style: TextStyle(fontSize:20,color: Colors.white),),
            ),
          )
        ],
      )
    ],
  ),
);

