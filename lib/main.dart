
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'DbManager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

  }

class _MyHomePageState extends State<MyHomePage> {

  final Dbstudents dbstudents = new Dbstudents();

  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  Student student;
  List<Student> studentlist;
  int updateindex;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double width =  MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Sqlite Demo'),),
      body: ListView(
        children: <Widget>[
        Form(key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
              decoration: new InputDecoration(labelText: 'Name'),
              controller: _nameController,
              validator: (val) => val.isNotEmpty? null: 'name should not be empty',
            ),

              TextFormField(
                decoration: new InputDecoration(labelText: 'Course'),
                controller: _courseController,
                validator: (val) => val.isNotEmpty? null: 'course should not be empty',
              ),

              RaisedButton(
                textColor: Colors.white,
                color: Colors.blueAccent,
                child: Container(
                  width: width*0.9,
                    child: Text('Submit',textAlign: TextAlign.center,)
                ),
                onPressed: (){
                  _submitStudent(context);
                },
              ),
              FutureBuilder(
                future: dbstudents.getStudentlist(),
                builder: (context, snapshot){
                    if(snapshot.hasData)
                      {
                        studentlist = snapshot.data;
                        return
                          ListView.separated(
                            shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) => Divider(),
                        itemCount: studentlist == null?0: studentlist.length,
                        itemBuilder: (BuildContext context, int index)
                        {
                          Student st = studentlist[index];
                          return Card(
                            child:Row(
                              children: <Widget>[
                                Container(
                                  width: width*0.6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      AutoSizeText('Name : ${st.name}',style: TextStyle(fontSize: 16),maxLines: 2,),
                                      AutoSizeText('Course : ${st.course}',style: TextStyle(fontSize: 16,color: Colors.black54),maxLines: 2,)
                                    ],
                                  ),
                                ),

                                IconButton(icon: Icon(Icons.edit,color: Colors.blueAccent), onPressed: (){
                                  _nameController.text = st.name;
                                  _courseController.text = st.course;
                                  student = st;
                                  updateindex = index;
                                }),
                                IconButton(icon: Icon(Icons.delete,color: Colors.redAccent), onPressed: (){
                                  dbstudents.deleteStudent(st.id);
                                  setState(() {
                                    studentlist.removeAt(index);
                                  });
                                })
                              ],
                            )


                          );
                        }
                        );
                      }
                    return new CircularProgressIndicator();
                },
              )
            ],
          ),
        ),)
      ],
      ),
    );
  }

  void _submitStudent(BuildContext context) {
    if(_formKey.currentState.validate())
      {
          if(student == null)
            {
              Student st = new Student(name: _nameController.text, course: _courseController.text);
              dbstudents.insertStudent(st).then((id) => {
                _nameController.clear(),
                _courseController.clear(),
                print('Student added successfully and id is  ${id}')
              });
            }
          else{
            student.name = _nameController.text;
            student.course = _courseController.text;
            dbstudents.updateStudent(student).then((id) => {
              _nameController.clear(),
              _courseController.clear(),
              print('Student updated successfully and id is  ${id}')
            });
          }
      }
  }


}
