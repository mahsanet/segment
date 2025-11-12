// Create a new file: lib/src/modules/connection/application/connection_meta_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:segment/src/modules/connection_meta/domain/connection_meta_model.dart';
import 'package:segment/src/shared/errors/app_exceptions.dart';
import 'package:socks5_proxy/socks.dart';

final connectionMetaRepoProvider =
    Provider<ConnectionMetaRepo>((_) => ConnectionMetaRepo());

class ConnectionMetaRepo {
  static const _traceUrl = 'https://cloudflare.com/cdn-cgi/trace';

  Future<ConnectionMetaModel> fetchConnectionMeta() async {
    final client = HttpClient();

    SocksTCPClient.assignToHttpClient(
      client,
      [ProxySettings(InternetAddress.loopbackIPv4, 2080)],
      tryLookup: true,
    );

    try {
      // GET request
      final request = await client.getUrl(Uri.parse(_traceUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        return ConnectionMetaModel.fromRawText(
            await utf8.decodeStream(response));
      } else {
        throw ConnectionMetaException(
            error: "Response status code: ${response.statusCode}");
      }
    } catch (e) {
      throw ConnectionMetaException(error: e);
    } finally {
      client.close();
    }
  }
}
