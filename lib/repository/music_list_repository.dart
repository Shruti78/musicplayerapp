import 'package:relu_consultancy_test/constants.dart';
import 'package:relu_consultancy_test/api/api_provider.dart';
import 'dart:async';
import 'package:relu_consultancy_test/models/music_list.dart';

class MusicListRepository {
  ApiProvider _provider = ApiProvider();
  Future<MusicList> fetchMusicListData() async {
    final response = await _provider.get("chart.tracks.get?apikey=$apikey");
    return MusicList.fromJson(response);
  }
}
