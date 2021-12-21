
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VdPlayer extends StatefulWidget {
  final String? dataSource;
  final BetterPlayerDataSourceType dataSourceType;
  const VdPlayer({Key? key, required this.dataSource,required this.dataSourceType}) : super(key: key);


  @override
  _VdPlayerState createState() => _VdPlayerState();
}
class _VdPlayerState extends State<VdPlayer> {
  late BetterPlayerController _betterPlayerController;
  Color color=Colors.white;
  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        widget.dataSourceType,
        widget.dataSource!,
    cacheConfiguration:const BetterPlayerCacheConfiguration(
      useCache:true,
    )
    );
    _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
            autoDetectFullscreenDeviceOrientation: true,
          fit: BoxFit.fill,
            aspectRatio: 4/3,
            autoDispose: false,
           fullScreenAspectRatio:9/16,
          deviceOrientationsAfterFullScreen:[DeviceOrientation.portraitUp],
            controlsConfiguration: BetterPlayerControlsConfiguration(
              enableOverflowMenu: false,
              enableSkips: false,
              enableRetry: false,
                enableFullscreen: false,
            ),
        ),
        betterPlayerDataSource: betterPlayerDataSource);

  }
  @override
  Widget build(BuildContext context) {
    return  BetterPlayer(
      controller: _betterPlayerController,
    );
  }
  @override
  void dispose() {
    _betterPlayerController.videoPlayerController!.dispose();
    super.dispose();
  }
}
