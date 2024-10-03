/*import 'package:flutter/material.dart';
import 'package:flutter_instagram_stories/flutter_instagram_stories.dart';
import 'package:get/get.dart';

import 'user_data_storyController.dart';

class UserStoryViewer extends StatefulWidget {
  final index;
  const UserStoryViewer({super.key, required this.index});

  @override
  State<UserStoryViewer> createState() => _UserStoryViewerState();
}

class _UserStoryViewerState extends State<UserStoryViewer> {

  final storyController = Get.put(UserDataController());
  final String collectionDbName = "stories_db";


  @override
  Widget build(BuildContext context) {
    final List<dynamic>? stories = storyController.userData.value?.data?[widget.index].stories;
    final List<Map<String, dynamic>> storyItems = stories?.map((story) {
      return {
        "media_url": story['media_url'],
        "media_type": story['media_type'],
        "timestamp": story['timestamp'],
        "text": story['text'],
        "text_description": story['text_description'],
      };
    }).toList() ?? [];

    void _backFromStoriesAlert() {
      // Implement the alert function here
    }

    return Scaffold(
      body: Container(
        child:FlutterInstagramStories(
          collectionDbName: collectionDbName,
          showTitleOnIcon: true,
          stories: storyItems, // Pass the generated story list here
          backFromStories: () {
            _backFromStoriesAlert();
          },
          iconTextStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          iconImageBorderRadius: BorderRadius.circular(15.0),
          iconBoxDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: Color(0xFFffffff),
            boxShadow: [
              BoxShadow(
                color: Color(0xff333333),
                blurRadius: 10.0,
                offset: Offset(0.0, 4.0),
              ),
            ],
          ),
          iconWidth: 150.0,
          iconHeight: 150.0,
          textInIconPadding:
          EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
          imageStoryDuration: 7,
          progressPosition: ProgressPosition.top,
          repeat: true,
          inline: false,
          languageCode: 'en',
          backgroundColorBetweenStories: Colors.black,
          closeButtonIcon: Icon(
            Icons.close,
            color: Colors.white,
            size: 28.0,
          ),
          closeButtonBackgroundColor: Color(0x11000000),
          sortingOrderDesc: true,
          lastIconHighlight: true,
          lastIconHighlightColor: Colors.deepOrange,
          lastIconHighlightRadius: const Radius.circular(15.0),
          captionTextStyle: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
          captionMargin: EdgeInsets.only(
            bottom: 50,
          ),
          captionPadding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}*/




import 'package:flutter/material.dart';
import 'package:flutter_task/UTILS/media_widget.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import 'user_data_controller.dart';

class CustomInstagramStories extends StatelessWidget {
  final index;

  CustomInstagramStories({ required this.index});
  final StoryController storyController = StoryController();
  final controller = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = [];

    for(int i=0; i< controller.userData.value!.data![index].stories!.length; i++){
      if (controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".jpg") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".jpeg") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".png") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".gif")){
        storyItems.add(
            StoryItem.pageImage(
              url: controller.userData.value!.data![index].stories![i].mediaUrl.toString(),
              controller: storyController,
              caption: Text(controller.userData.value!.data![index].stories![i].textDescription.toString()),
            )
        );
      }
      else if(controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".mp4") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".mov") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".avi") ||
          controller.userData.value!.data![index].stories![i].mediaUrl.toString().endsWith(".mkv")){
        storyItems.add(
            StoryItem.pageVideo(
              controller.userData.value!.data![index].stories![i].mediaUrl.toString(),
              controller: storyController,
              caption: Text(controller.userData.value!.data![index].stories![i].textDescription.toString()),
            )
        );
      }
      
    }

    return Scaffold(
      body: StoryView(
          controller: storyController,
          repeat: false,
          onComplete: () {
            Navigator.pop(context);
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
        storyItems: storyItems,

      ),
    );
  }
}


// class StoriesScreen extends StatefulWidget {
//   final index;
//   const StoriesScreen({super.key, required this.index});
//
//   @override
//   State<StoriesScreen> createState() => _StoriesScreenState();
// }
//
// class _StoriesScreenState extends State<StoriesScreen> {
//
//   final storyController = Get.put(UserDataController());
//
//   @override
//   Widget build(BuildContext context) {
//
//     final stories = [
//       for(int i=0; i<storyController.userData.value!.data![widget.index].stories!.length; i++)
//         {
//           "media_url": storyController.userData.value!.data![widget.index].stories![i].mediaUrl,
//           "media_type": storyController.userData.value!.data![widget.index].stories![i].mediaType,
//           "text": storyController.userData.value!.data![widget.index].stories![i].text,
//         }
//     ];
//
//     print("stories : ${stories}");
//
//     return CustomInstagramStories(stories: stories);
//   }
// }

