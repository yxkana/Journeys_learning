import 'package:flutter/material.dart';

//Dependencies
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Models
import 'package:places/models/place.dart';

//Widgets
import '../widgets/Boxes.dart';
import '../widgets/main_map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin {
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
            markerId: const MarkerId("mark1"),
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
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : mainMap(searchMap, _searchController, userLocation, marker);
          },
        ));
  }
}
