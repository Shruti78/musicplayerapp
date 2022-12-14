import 'package:relu_consultancy_test/constants.dart';
import 'package:relu_consultancy_test/models/music_lyrics.dart';
import 'package:relu_consultancy_test/api/api_provider.dart';
import 'dart:async';

class MusicLyricsRepository {
  final int trackId;
  MusicLyricsRepository({this.trackId});
  ApiProvider _provider = ApiProvider();
  Future<MusicLyrics> fetchMusicDetailsData() async {
    final response = await _provider
        .get("track.lyrics.get?track_id=$trackId&apikey=$apikey");
    return MusicLyrics.fromJson(response);
  }
}
