import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:places/models/place.dart';
import '../widgets/Boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../widgets/main_map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  LatLng userLocation = LatLng(0, 0);
  bool loading = true;
  List<Place> searchMap = [];
  Set<Marker> map = {};
  List<Marker> markers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var userLoc = await Location().getLocation();
      setState(() {
        userLocation = LatLng(userLoc.latitude!, userLoc.longitude!);
        map.add(Marker(
            markerId: MarkerId("mark1"),
            position: LatLng(userLoc.latitude!, userLoc.longitude!)));
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).backgroundColor,
        body: ValueListenableBuilder<Box<Place>>(
          valueListenable: Boxes.getPlace().listenable(),
          builder: (context, box, _) {
            var marker = box.values.toList().cast<Place>();

            return loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : mainMap(searchMap, _searchController, userLocation, marker);
          },
        ));
  }
}
