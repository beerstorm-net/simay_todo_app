import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/main/main_bloc.dart';
import 'blocs/simple_bloc_observer.dart';
import 'models/user_repository.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await Hive.initFlutter();
  Box _hiveBox = await Hive.openBox("appBox");
  UserRepository _userRepository = UserRepository(hiveBox: _hiveBox);

  runApp(BlocProvider<MainBloc>(
    lazy: false,
    create: (context) => MainBloc(
      userRepository: _userRepository,
    )..add(AppStartedEvent()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simay TODO app',
      debugShowCheckedModeBanner: false,
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
      home: MyHomePage(title: 'Simay TODO app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isAuthenticated = false;
  String appTitle = "Giris";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state is LoginState) {
            setState(() {
              isAuthenticated = (state.appUser != null &&
                  state.appUser.uid != null &&
                  state.appUser.uid.isNotEmpty);

              if (isAuthenticated) {
                appTitle = "TODO App";
              } else {
                appTitle = "Giris";
              }
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(appTitle),
              centerTitle: true,
              actions: [
                if (isAuthenticated)
                  InkWell(
                    child: Icon(Icons.exit_to_app),
                    onTap: () {
                      BlocProvider.of<MainBloc>(context).add(LogoutEvent());
                    },
                  )
              ],
            ),
            body: isAuthenticated
                ? MainPage()
                : LoginPage() // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
