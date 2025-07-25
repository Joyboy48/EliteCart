import 'package:studio_projects/Features/Authentication/Screens/Login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  ///Variable
  final pageController = PageController();
  final currentPageIndex = 0.obs;

  ///Update Current index  when page  Scroll
  void updatePageIndicator(int index) => currentPageIndex.value = index;

  ///Jump to the specific dot selected  page
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  ///Update current index and jump to next page
  void nextPage(){
    if(currentPageIndex.value == 2){
      Get.to(const loginPage());
    }else{
      int page =  currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  ///Update the current index and jump to the last page
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpTo(2);
  }
}