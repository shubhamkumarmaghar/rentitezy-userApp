import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    super.initState();
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl, trimWhitespaces: true) ?? '',
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false, loop: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: true,
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: youtubePlayerController,
                  showVideoProgressIndicator: true,
                  progressColors: ProgressBarColors(
                      playedColor: Constants.primaryColor,
                      bufferedColor: Constants.primaryColor.withOpacity(0.2),
                      handleColor: Constants.primaryColor),
                ),
                builder: (context, player) {
                  return player;
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.3,
                  child: YoutubePlayerBuilder(
                    onExitFullScreen: () {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                        SystemUiOverlay.top,
                      ]);
                    },
                    player: YoutubePlayer(
                      controller: youtubePlayerController,
                      showVideoProgressIndicator: true,
                      progressColors: ProgressBarColors(
                          playedColor: Constants.primaryColor,
                          bufferedColor: Constants.primaryColor.withOpacity(0.2),
                          handleColor: Constants.primaryColor),
                    ),
                    builder: (context, player) {
                      return player;
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    super.dispose();
  }
}
