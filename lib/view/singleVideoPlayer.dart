import 'package:etech_tech/Constants/constants.dart';
import 'package:etech_tech/model/video_list_model.dart';
import 'package:etech_tech/service/download_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class SingleVideoPlayer extends StatefulWidget {
  final Video videoDetails;
 const SingleVideoPlayer({required this.videoDetails, super.key});

  @override
  State<SingleVideoPlayer> createState() => _SingleVideoPlayerState();
}

class _SingleVideoPlayerState extends State<SingleVideoPlayer> {
   late FlickManager flickManager;
  @override
  void initState() {
 
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
             widget.videoDetails.sources.first)));
    super.initState();
  }

  @override
  void dispose() {
  
    flickManager.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {



    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // ignore: unnecessary_string_interpolations
        title:  Text("${widget.videoDetails.title}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(

          padding: const EdgeInsets.all(8),
          height: Constant.height,
          width: double.infinity,
          child: 
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: FlickVideoPlayer(flickManager: flickManager),
                      ),
                      SizedBox(
                        height: Constant.height / 24.5,
                      ),
                      Expanded(child: 
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          
                          children: [
                            Text(
                              textAlign: TextAlign.justify,
                              textScaler: MediaQuery.textScalerOf(context),
                              widget.videoDetails.title,style: TextStyle(
                              fontSize: Constant.width/18,
                              fontWeight: FontWeight.bold
                            ),),
                            Text(
                              textAlign: TextAlign.justify,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              textScaler: MediaQuery.textScalerOf(context),
                              widget.videoDetails.description,style: TextStyle(
                              fontSize: Constant.width/30,
                            ),),
                            
                                    SizedBox(height: Constant.height/18,),
                            Divider(color: Colors.grey.shade400,),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               CircleAvatar(
                                      foregroundImage: NetworkImage('${Constant.image_base_url}/${  widget.videoDetails.thumb}'),
                                      backgroundColor: const Color(0xffD0A2F7),
                                      
                                     
                                    ),
                                SizedBox(width: Constant.width/35,),
                               Text(
                                                          textScaler: MediaQuery.textScalerOf(context),
                                                          
                                                          widget.videoDetails.subtitle,style: TextStyle(
                                                          fontSize: Constant.width/25,
                                                        ),),
                                                        
                                
                                const Spacer(),
                                Downloading(fileName: 'media${DateTime.now()}.mp4', fileUrl: widget.videoDetails.sources.first,)
                                // ElevatedButton(onPressed: (){},
                                // style: ElevatedButton.styleFrom(
                                //   backgroundColor:  Constant.buttonColor,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(8),
                                  
                                //   )
                                // ),
                                //  child: const Text('Download',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),))
                                                        ]),
                                SizedBox(width: Constant.width/15,),
                           
                            Divider(color: Colors.grey.shade400,),
                        
                           
                          ],
                        ),
                      ))
                    ],
                  
              ),
        ),
      ),

      
    );
  }
}
