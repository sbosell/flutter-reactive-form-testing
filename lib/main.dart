import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
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
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const phoneValidationPattern = r'\(?\d{3}\)?-? *\d{3}-? *-?\d{4}$';

final form = FormGroup({
  'lastName': FormControl(validators: []),
  'phoneNumber': FormControl(validators: [Validators.required, Validators.pattern(phoneValidationPattern)]),
  'spotId': FormControl(validators: [Validators.required]),
});

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int spotValue;

  String formError;

  Future<int> f = Future.delayed(Duration(seconds: 2), () => 1);

  // the only difference in the tests is setting this flag to hide the image
  bool hideImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      // showing and hiding the image won't reproduce the issue
      //  floatingActionButton: FloatingActionButton(onPressed: () => setState(() => hideImage = !hideImage)),
      body: SingleChildScrollView(
        child: Center(
            child: FutureBuilder<int>(
                future: f,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Sample 1"),
                      hideImage
                          ? Container()
                          : Image.network("https://via.placeholder.com/508x262/ff0000.png?text=logo", width: 200),
                      Consumer(builder: (context, watch, child) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: ReactiveForm(
                            formGroup: form,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveDropdownField<int>(
                                    formControlName: 'spotId',
                                    //hint: Text('Spot Number'),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        //contentPadding: EdgeInsets.fromLTRB(0, 5.5, 0, 0),
                                        labelStyle: TextStyle(),
                                        labelText: 'Drop Down #'),
                                    items: [
                                      DropdownMenuItem(child: Text("100"), value: 11),
                                      DropdownMenuItem(child: Text("101"), value: 12)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveTextField(
                                    formControlName: 'lastName',
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      //hintText: 'Last name on order',
                                      labelText: 'Last name ',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReactiveTextField(
                                    formControlName: 'phoneNumber',
                                    keyboardType: TextInputType.phone,
                                    validationMessages: {'pattern': 'Invalid phone'},
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      //hintText: 'Last name on order',
                                      labelText: 'Phone number ',
                                    ),
                                  ),
                                ),
                                ReactiveFormConsumer(
                                  builder: (context, form, child) {
                                    return RaisedButton(
                                        child: Text('Submit '),
                                        onPressed: () {
                                          form.markAllAsTouched();

                                          if (form.valid) {}
                                        });
                                  },
                                ),
                                formError != null ? Text(formError) : Container(),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  );
                })),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
