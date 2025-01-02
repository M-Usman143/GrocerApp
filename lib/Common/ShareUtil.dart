import 'package:location/location.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class ShareUtil {
  // Method to share product details (name, price, URL)
  static void shareProductDetails(String productName, String productPrice, String productUrl) {
    final String shareText = "$productName\nPrice: $productPrice\n$productUrl";
    Share.share(shareText);
  }

  // Method to share simple text content
  static void shareText(String textToShare) {
    Share.share(textToShare);
  }

  // Method to share a URL
  static void shareUrl(String urlToShare) {
    Share.share(urlToShare);
  }

  // Method to share custom content and URL
  static void shareContent(String content, String url) {
    final String shareText = "$content\n$url";
    Share.share(shareText);
  }

  // Method to share an image with a message
  static Future<void> shareImage(String imagePath) async {
    try {
      XFile imageFile = XFile(imagePath);
      await Share.shareXFiles([imageFile], text: 'Check this out!');
    } catch (e) {
      print("Error sharing image: $e");
    }
  }
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

}
