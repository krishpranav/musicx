import 'package:musicx/core/yt_music/segment/search.dart';
import 'package:musicx/core/yt_music/segment/suggestions.dart';
import 'package:musicx/core/yt_music/segment/playlist.dart';

class YTMUSIC {
  static search(query,
          {String? filter, String? scope, ignoreSpelling = false}) =>
      Search().search(query,
          filter: filter, scope: scope, ignoreSpelling: ignoreSpelling);
  static Future suggestions(query) =>
      Suggestions().getSearchSuggestions(query: query);
  static Future getPlaylistDetails(playlistId) =>
      Playlist().getPlaylistDetails(playlistId);
}
