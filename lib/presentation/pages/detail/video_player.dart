import 'package:cinemabooking/config/ui.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.movieTrailer});
  final String? movieTrailer;

  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  final defaultTrailerUrl =
      "https://www.youtube.com/watch?v=MzEFeIRJ0eQ&ab_channel=DibyenduJana";

  late YoutubePlayerController controller;

  late String? videoYoutubeUrl;

  void getMovieTrailer(String? movieUrl) {
    if (movieUrl != null) {
      videoYoutubeUrl = YoutubePlayer.convertUrlToId(movieUrl);
      videoYoutubeUrl ??= YoutubePlayer.convertUrlToId(defaultTrailerUrl);
    } else {
      videoYoutubeUrl ??= YoutubePlayer.convertUrlToId(defaultTrailerUrl);
    }
  }

  @override
  void initState() {
    getMovieTrailer(widget.movieTrailer);
    controller = YoutubePlayerController(
      initialVideoId: videoYoutubeUrl!,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );

    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void pause(){
    controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayer(
          controller: controller,
          showVideoProgressIndicator: true,
          bottomActions: [
            CurrentPosition(),
            ProgressBar(
              isExpanded: true,
              colors: const ProgressBarColors(
                playedColor: Color(appColor),
                handleColor: Color(appColor),
              ),
            ),
            const PlaybackSpeedButton(),
          ],
        )
      ],
    );
  }
}
