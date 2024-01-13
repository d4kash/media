import 'package:etech_tech/Network/connectivity_controller.dart';
import 'package:etech_tech/controller/read_json_controller.dart';

import 'package:etech_tech/model/video_list_model.dart';
import 'package:etech_tech/view/singleVideoPlayer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:student_erp/Screen/Video/singleVideoPlayer.dart';
import 'package:etech_tech/constants/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late ConnectivityService _connectivityService;
 late FlickManager flickManager;
  @override
  void initState() {
    _connectivityService = Get.find<ConnectivityService>();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
            'https://erp-dav-sanford.s3.ap-south-1.amazonaws.com/erp_videos/id39543245test1.mp4')));
    super.initState();
  }

  // @override
  // void dispose() {
  //   _connectivityService.dispose();
  //   flickManager.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // FlickManager flickManager = FlickManager(
    //     videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
    //         'https://erp-dav-sanford.s3.ap-south-1.amazonaws.com/erp_videos/id39543245test1.mp4')));
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text("Media"),
        // centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
            future: ReadJsonFile.readJsonData(path: Constant.apiUrl),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              // if (snapshot.data == null) {
              //   return const Center(
              //     child: CircularProgressIndicator(),
              //   );
              // }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error occurred',
                      style: TextStyle(fontSize: 18),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  if (snapshot.data == "") {
                    return const Center(
                      child: Text("Something Went wrong"),
                    );
                  }
                  var videoData = videoListModelFromJson(snapshot.data!);
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // UserDetailCard(data: widget.data!,),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: FlickVideoPlayer(flickManager: flickManager),
                      ),
                      SizedBox(
                        height: Constant.height / 14.5,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: videoData.categories[0].videos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  // height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xffD0A2F7),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      foregroundImage: NetworkImage(
                                          '${Constant.image_base_url}/${videoData.categories[0].videos[index].thumb}'),
                                      backgroundColor: const Color(0xffD0A2F7),
                                    ),
                                    title: Text(
                                        videoData
                                            .categories[0].videos[index].title
                                            .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        videoData.categories[0].videos[index]
                                            .subtitle,
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    trailing: GestureDetector(
                                        onTap: () {
                                          // print(
                                          //     "video Url: ${videoData.categories[0].videos[index].sources[0]}");
                                          Get.to(() => SingleVideoPlayer(
                                              videoDetails: videoData
                                                  .categories[0]
                                                  .videos[index]));
                                        },
                                        child: const CircleAvatar(
                                            child: Icon(
                                                Icons.play_arrow_rounded))),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return const SizedBox.shrink();
              }
            }),
      ),

      // body: Center(
      //   child: AspectRatio(
      //     aspectRatio: 16 / 9,
      //     child: FlickVideoPlayer(flickManager: flickManager),
      //   ),
      // ),
    );
  }
}
