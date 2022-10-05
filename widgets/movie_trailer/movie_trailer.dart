import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailer extends StatefulWidget {
  final String videoKey;

  const MovieTrailer({Key? key, required this.videoKey}) : super(key: key);

  @override
  State<MovieTrailer> createState() => _MovieTrailerState();
}

class _MovieTrailerState extends State<MovieTrailer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );

    return YoutubePlayerBuilder(
        player: player,
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Trailer'),
            ),
            body: Center(
              child: player,
            ),
          );
        });
  }
}
