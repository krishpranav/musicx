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
  final ProgressCallback? onProgress;
  final OnDoneCallback? onDone;
  final OnErrorCallback? onError;
  final Function? onCancel;
  final Function? onPause;
  final Function? onResume;
  StreamSubscription<StreamedResponse>? stream;
  ChunkedStreamReader<int>? reader;
  Map<String, String>? headers;
  double speed = 0;
  bool paused = false;
  bool done = false;
  static const bool kDebugMode = false;

  ChunkedDownloader({
    required this.url,
    required this.path,
    required this.title,
    this.extension = 'mp3',
    this.headers,
    this.chunkSize = 1024 * 1024,
    this.onProgress,
    this.onDone,
    this.onError,
    this.onCancel,
    this.onPause,
    this.onResume,
  });

  Future<ChunkedDownloader> start() async {
    try {
      int offset = 0;
      var httpClient = http.Client();
      var request = http.Request('GET', Uri.parse(url));
      if (headers != null) {
        request.headers.addAll(headers!);
      }
      var response = httpClient.send(request);

      File file = File('$path$title.$extension');

      stream = response.asStream().listen(null);
      stream?.onData((http.StreamedResponse r) async {
        int fileSize = int.tryParse(r.headers['content-length'] ?? '-1') ?? -1;
        reader = ChunkedStreamReader(r.stream);
        try {
          Uint8List buffer;
          do {
            while (paused) {
              await Future.delayed(const Duration(milliseconds: 500));
            }

            int startTime = DateTime.now().millisecondsSinceEpoch;

            buffer = await reader!.readBytes(chunkSize);

            int endTime = DateTime.now().millisecondsSinceEpoch;
            int timeDiff = endTime - startTime;
            if (timeDiff > 0) {
              speed = (buffer.length / timeDiff) * 1000;
            }

            offset += buffer.length;
            if (kDebugMode) {
              print('Downloading ${offset ~/ 1024 ~/ 1024}MB '
                  'Speed: ${speed ~/ 1024 ~/ 1024}MB/s');
            }
            if (onProgress != null) {
              onProgress!(offset, fileSize, speed);
            }

            await file.writeAsBytes(buffer, mode: FileMode.append);
          } while (buffer.length == chunkSize);

          done = true;
          if (onDone != null) {
            onDone!(file);
          }
          if (kDebugMode) {
            print('Downloaded file.');
          }
        } catch (error) {
          if (kDebugMode) {
            print('Error downloading: $error');
          }
          if (onError != null) {
            onError!(error);
          }
        } finally {
          reader?.cancel();
          stream?.cancel();
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error downloading: $error');
      }
      if (onError != null) {
        onError!(error);
      }
    }
    return this;
  }

  void stop() {
    stream?.cancel();
    reader?.cancel();
    if (onCancel != null) {
      onCancel!();
    }
  }

  void pause() {
    paused = true;
    if (onPause != null) {
      onPause!();
    }
  }

  void resume() {
    paused = false;
    if (onResume != null) {
      onResume!();
    }
  }
}
