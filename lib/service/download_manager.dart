import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:background_downloader/background_downloader.dart';
import 'package:etech_tech/constants/constants.dart';
import 'package:etech_tech/service/download_functions.dart';
import 'package:etech_tech/utils/permisisons.dart';
import 'package:flutter/material.dart';

class Downloading extends StatefulWidget {
  final String fileName;
  final String fileUrl;
  const Downloading({super.key, required this.fileName, required this.fileUrl});

  @override
  State<Downloading> createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  final buttonTexts = ['Download', 'Cancel', 'Pause', 'Resume', 'Reset'];

  ButtonState buttonState = ButtonState.download;
  bool downloadWithError = false;
  TaskStatus? downloadTaskStatus;
  DownloadTask? backgroundDownloadTask;
  late StreamController<TaskProgressUpdate> progressUpdateStream;

  bool loadAndOpenInProgress = false;
  bool loadABunchInProgress = false;

  @override
  void initState() {
    super.initState();

    progressUpdateStream = StreamController.broadcast();

    FileDownloader().configure(globalConfig: [
      (Config.requestTimeout, const Duration(seconds: 100)),
    ], androidConfig: [
      (Config.useCacheDir, Config.whenAble),
    ], iOSConfig: [
      (Config.localize, {'Cancel': 'StopIt'}),
    ]).then((result) => debugPrint('Configuration result = $result'));

    @override
    void dispose() {
      downloadTaskStatus = null;
      buttonState = ButtonState.download;
      progressUpdateStream.close();
      FileDownloader().destroy();
      super.dispose();
    }

    // Registering a callback and configure notifications
    FileDownloader()
        .registerCallbacks(
            taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotificationForGroup(FileDownloader.defaultGroup,
            // For the main download button
            // which uses 'enqueue' and a default group
            running: const TaskNotification('Download {filename}',
                'File: {filename} - {progress} - speed {networkSpeed} and {timeRemaining} remaining'),
            complete: const TaskNotification(
                '{displayName} download {filename}', 'Download complete'),
            error: const TaskNotification(
                'Download {filename}', 'Download failed'),
            paused: const TaskNotification(
                'Download {filename}', 'Paused with metadata {metadata}'),
            progressBar: true)
        .configureNotificationForGroup('bunch',
            running: const TaskNotification(
                '{numFinished} out of {numTotal}', 'Progress = {progress}'),
            complete:
                const TaskNotification("Done!", "Loaded {numTotal} files"),
            error: const TaskNotification(
                'Error', '{numFailed}/{numTotal} failed'),
            progressBar: false,
            groupNotificationId: 'notGroup')
        .configureNotification(
            // for the 'Download & Open' dog picture
            // which uses 'download' which is not the .defaultGroup
            // but the .await group so won't use the above config
            complete: const TaskNotification(
                'Download {filename}', 'Download complete'),
            tapOpensFile: true); // dog can also open directly from tap

    if(FileDownloader().updates==null){

    // Listen to updates and process
    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate _:
          if (update.task == backgroundDownloadTask) {
            buttonState = switch (update.status) {
              TaskStatus.running || TaskStatus.enqueued => ButtonState.pause,
              TaskStatus.paused => ButtonState.resume,
              _ => ButtonState.reset
            };
            setState(() {
              downloadTaskStatus = update.status;
            });
          }

        case TaskProgressUpdate _:
          progressUpdateStream.add(update); // pass on to widget for indicator
      }
    });
    }
  }

  /// Process the user tapping on a notification by printing a message
  void myNotificationTapCallback(Task task, NotificationType notificationType) {
    debugPrint(
        'Tapped notification $notificationType for taskId ${task.taskId}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Constant.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
          onPressed: () => processButtonPress(widget.fileName, widget.fileUrl),
          child: Text(
            buttonTexts[buttonState.index],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
          ),
        )),
        //  SizedBox(
        //   width: Constant.width/4,
        //    child: DownloadProgressIndicator(progressUpdateStream.stream,
        //            showPauseButton: true,
        //            showCancelButton: true,
        //            backgroundColor: Colors.grey,
        //            maxExpandable: 3),
        //  )
      ],
    );
    // bottomSheet: DownloadProgressIndicator(progressUpdateStream.stream,
    //     showPauseButton: true,
    //     showCancelButton: true,
    //     backgroundColor: Colors.grey,
    //     maxExpandable: 3));
  }

  /// Process center button press (initially 'Download' but the text changes
  /// based on state)
  Future<void> processButtonPress(String fileName, String fileUrl) async {
    switch (buttonState) {
      case ButtonState.download:
        // start download
        await getPermission(PermissionType.notifications);
        await getPermission(PermissionType.androidSharedStorage);
        GetPermissions.checkallpermission_openstorage();
        var downloadFunctionInstance = DownloadFunctions();
        String path = await DownloadFunctions().getFilePath(fileName);
        backgroundDownloadTask = DownloadTask(
            url: fileUrl,
            // 'https://storage.googleapis.com/approachcharts/test/5MB-test.ZIP',
            filename: '$fileName',
            directory: path,
            // directory: 'my/directory',
            baseDirectory: BaseDirectory.applicationDocuments,
            updates: Updates.statusAndProgress,
            retries: 3,
            allowPause: true,
            metaData: '<example metaData>',
            displayName: 'Daksh');

        await FileDownloader().enqueue(backgroundDownloadTask!);
        await DownloadFunctions().downloadRecording(fileUrl);
        break;
      case ButtonState.cancel:
        // cancel download
        if (backgroundDownloadTask != null) {
          await FileDownloader()
              .cancelTasksWithIds([backgroundDownloadTask!.taskId]);
        }
        break;
      case ButtonState.reset:
        downloadTaskStatus = null;
        buttonState = ButtonState.download;
        break;
      case ButtonState.pause:
        if (backgroundDownloadTask != null) {
          await FileDownloader().pause(backgroundDownloadTask!);
        }
        break;
      case ButtonState.resume:
        if (backgroundDownloadTask != null) {
          await FileDownloader().resume(backgroundDownloadTask!);
        }
        break;
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Attempt to get permissions if not already granted
  Future<void> getPermission(PermissionType permissionType) async {
    var status = await FileDownloader().permissions.status(permissionType);
    if (status != PermissionStatus.granted) {
      if (await FileDownloader()
          .permissions
          .shouldShowRationale(permissionType)) {
        debugPrint('Showing some rationale');
      }
      status = await FileDownloader().permissions.request(permissionType);
      debugPrint('Permission for $permissionType was $status');
    }
  }
}

enum ButtonState { download, cancel, pause, resume, reset }
