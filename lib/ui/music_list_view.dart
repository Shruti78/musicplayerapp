import 'package:relu_consultancy_test/bloc/connectivity_bloc.dart';
import 'package:relu_consultancy_test/ui/bookmarks_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:relu_consultancy_test/bloc/music_list_block.dart';
import 'package:relu_consultancy_test/api/response.dart';
import 'package:relu_consultancy_test/models/music_list.dart';
import 'music_lyrics_view.dart';

class GetMusicList extends StatefulWidget {
  @override
  _GetMusicListState createState() => _GetMusicListState();
}

class _GetMusicListState extends State<GetMusicList> {
  ConnectivityBloc _netBloc = ConnectivityBloc();
  MusicListBloc _bloc = MusicListBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 56, 5, 77),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 5, 77),
        automaticallyImplyLeading: false,
        elevation: 5.0,
        title: Text(
          'Trending',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookmarkView()));
            },
          )
        ],
      ),
      body: StreamBuilder<ConnectivityResult>(
          stream: _netBloc.connectivityResultStream.asBroadcastStream(),
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case ConnectivityResult.mobile:
              case ConnectivityResult.wifi:
                _bloc.fetchMusicList();
                //print('NET : ');
                return RefreshIndicator(
                  onRefresh: () => _bloc.fetchMusicList(),
                  child: StreamBuilder<Response<MusicList>>(
                    stream: _bloc.musicListStream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return Loading(
                                loadingMessage: snapshot.data.message);
                            break;
                          case Status.COMPLETED:
                            return TrackList(musicList: snapshot.data.data);
                            break;
                          case Status.ERROR:
                            return Center(
                              child: Text(
                                'No internet',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                            break;
                            break;
                        }
                      }
                      return Loading(loadingMessage: 'Connecting');
                    },
                  ),
                );
                break;
              case ConnectivityResult.none:
                //print('No net: ');
                return Center(
                  child: Text(
                    'No internet',
                    style: TextStyle(color: Colors.white),
                  ),
                );
                break;
            }
            return Container();
          }),
    );
  }

  @override
  void dispose() {
    _netBloc.dispose();
    _bloc.dispose();
    super.dispose();
  }
}

class TrackList extends StatelessWidget {
  final MusicList musicList;
  const TrackList({Key key, this.musicList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          Track track = musicList.message.body.trackList[index].track;
          return TrackTile(
            track: track,
          );
        },
        itemCount: musicList.message.body.trackList.length,
        //shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final Track track;
  TrackTile({
    this.track,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //debugPrint('Calling for trackid ${track.trackId}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetMusicLyrics(trackCurrent: track)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListTile(
            leading: Icon(Icons.library_music),
            title: Text(
              track.trackName,
            ),
            subtitle: Text(track.albumName),
            trailing: Container(
              width: 110,
              child: Text(
                track.artistName,
                softWrap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
