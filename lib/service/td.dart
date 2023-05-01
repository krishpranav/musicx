library chunked_downloader;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

typedef ProgressCallback = void Function(int progress, int total, double speed);

typedef OnDoneCallback = void Function(File file);

typedef OnErrorCallback = void Function(dynamic error);

class ChunkedDownloader {
  final String url;
  final String path;
  final String title;
  final String extension;
  final int chunkSize;
  bool done = false;
}
