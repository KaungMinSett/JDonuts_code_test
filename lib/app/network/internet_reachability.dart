import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetReachability {
  static const _timeout = Duration(seconds: 3);

  final _connectivity = Connectivity();

  // Interface changes tell the app when to check internet access again.
  Stream<List<ConnectivityResult>> get networkChanges =>
      _connectivity.onConnectivityChanged;

  Future<bool> isOnline() async {
    final client = HttpClient();
    try {
      return await _probe(client).timeout(_timeout);
    } on TimeoutException {
      return false;
    } on IOException {
      return false;
    } finally {
      // Close the connection even when the request times out.
      client.close(force: true);
    }
  }

  Future<bool> _probe(HttpClient client) async {
    // HTTPS endpoint to confirm internet access.
    final request = await client.getUrl(
      Uri.https('www.google.com', '/generate_204'),
    );
    request.followRedirects = false;
    final response = await request.close();
    return response.statusCode == HttpStatus.noContent;
  }
}
