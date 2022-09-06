//Basics
import 'home.dart';
import 'package:flutter/material.dart';

//Hive package
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Model
import 'package:places/models/place.dart';
//Screens
import './screens/detail_place.dart';

//Provider
import 'package:provider/provider.dart';
import 'package:places/providers/places_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(PlaceLocationAdapter());
  Hive.registerAdapter(PlaceTagAdapter());
  Hive.registerAdapter(IconsDataAdapter());
  await Hive.openBox<Place>("place4");
  await Hive.openBox<PlaceLocation>("markers4");
 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlacesProvider(),
      child: MaterialApp(
        title: 'PhotoMap',
        theme: ThemeData(
            fontFamily: "RobotoRegular",
            backgroundColor: Color.fromARGB(255, 243, 236, 248),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                tertiary: Color.fromARGB(255, 229, 222, 241),
                primary: Color.fromARGB(255, 85, 112, 138),
                secondary: Color.fromARGB(255, 175, 197, 226))),
        home: HomeScreen(),
        routes: {},
      ),
    );
  }
}
