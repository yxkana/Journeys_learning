const GOOGLE_API_KEY = "AIzaSyCi7dFt4IfqxQ7v9umJCKBHE-e_mIEKle8";

class LocationHelper {
  static String generateLocationImg({double? latitude, double? longitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY";
  }
}
