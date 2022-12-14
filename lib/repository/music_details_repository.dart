import 'package:relu_consultancy_test/constants.dart';
import 'package:relu_consultancy_test/models/music_details.dart';
import 'package:relu_consultancy_test/api/api_provider.dart';
import 'dart:async';

class MusicDetailsRepository {
  final int trackId;
  MusicDetailsRepository({this.trackId});
  ApiProvider _provider = ApiProvider();
  Future<MusicDetails> fetchMusicDetailsData() async {
    final response =
        await _provider.get("track.get?track_id=$trackId&apikey=$apikey");
    return MusicDetails.fromJson(response);
  }
}
