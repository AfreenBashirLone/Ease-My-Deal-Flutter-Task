import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/UI/user_data/user_data_controller.dart';
import 'package:flutter_task/UI/user_data/user_story_viewer.dart';
import 'package:get/get.dart';
import 'package:status_view/status_view.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {

  final controller = Get.put(UserDataController());
  Rx<String> errorName  = "".obs;

  Future<void> loadData() async{
    try{
      controller.isLoading.value = true;
      controller.userData.value = await controller.getUserDataApi(context, "https://ixifly.in/flutter/task2");
      controller.isLoading.value = false;
      errorName.value = "\n(${jsonEncode(controller.userData.value)})";
      if(controller.userData.value?.status == true){
        controller.isDataLoaded.value = true;
      }
      else{
        controller.isDataLoaded.value = false;
      }
    }
    catch(ex){
      print("Error : ${ex}");
      errorName.value = "\n($ex)";
      controller.isDataLoaded.value = false;
    }

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"),
      ),
      body: Obx(()=> body())
    );
  }
  
  
  Widget body(){
    if(controller.isLoading.value){
      return Center(child: CircularProgressIndicator(color: Colors.red,));
    }
    else if(controller.isDataLoaded.value){
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: controller.userData.value?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: (){
                        Get.to(CustomInstagramStories(index: index,));
                      },
                      child: StatusView(
                        radius: 40,
                        spacing: 10,
                        strokeWidth: 1,
                        indexOfSeenStatus: 0,
                        numberOfStatus: controller.userData.value?.data?[index].stories?.length ?? 0,
                        padding: 4,
                        centerImageUrl: controller.userData.value?.data?[index].profilePicture ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwoRj8E-Di6SqjsTnIwHMExDqyH5M7_lGkaA&s",
                        seenColor: Colors.grey,
                        unSeenColor: Colors.red,
                      ),/*Image.network(
                          controller.userData.value?.data?[index].profilePicture ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwoRj8E-Di6SqjsTnIwHMExDqyH5M7_lGkaA&s",
                          height: 50,
                          fit: BoxFit.cover,
                        ),*/
                    ),
                  );
                },
              ),
           
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.userData.value?.data?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.025),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5, right: 5),
                              child: InkWell(
                                onTap: (){
                                  Get.to(CustomInstagramStories(index: index,));
                                },
                                child: StatusView(
                                  radius: 25,
                                  spacing: 3,
                                  strokeWidth: 1.5,
                                  indexOfSeenStatus: 0,
                                  numberOfStatus: controller.userData.value?.data?[index].stories?.length ?? 0,
                                  padding: 4,
                                  centerImageUrl: controller.userData.value?.data?[index].profilePicture ??
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwoRj8E-Di6SqjsTnIwHMExDqyH5M7_lGkaA&s",
                                  seenColor: Colors.grey,
                                  unSeenColor: Colors.red,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${controller.userData.value?.data?[index].userName}"),
                                Text("(${controller.userData.value?.data?[index].userId})"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Image.network(controller.userData.value?.data?[index].profilePicture
                          ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwoRj8E-Di6SqjsTnIwHMExDqyH5M7_lGkaA&s",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.95,
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      );
    }
    else{
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("OOPs, Data not loaded!${errorName.value}"),
            GestureDetector(
                onTap: () async{
                  await loadData();
                },
                child: Text("Retry", style: TextStyle(color: Colors.red),)
            ),
          ],
        ),
      );
    }
    
  }
}
