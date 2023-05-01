import 'dart:convert';
import 'package:flutter/foundation.dart';

class HomeModel {
  String title;
  List playlists;

  HomeModel({
    required this.title,
    required this.playlists,
  });

  String get getTitle => title;
  List get getPlaylist => playlists;

  set setTitle(String title) => this.title = title;
  set setPlaylist(List playlists) => this.playlists = playlists;

  HomeModel copyWith({
    String? title,
    List? playlists,
  }) {
    return HomeModel(
        title: title ?? this.title, playlists: playlists ?? this.playlists);
  }
}
