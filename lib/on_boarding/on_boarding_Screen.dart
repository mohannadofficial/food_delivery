import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/big_text.dart';
import 'package:food_delivery/layout/food_delivery.dart';
import 'package:food_delivery/models/boarding_model.dart';
import 'package:food_delivery/shared/network/local/cache_helper.dart';
import 'package:food_delivery/utils/app_constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  final PageController _pageController = PageController(initialPage: 0);

  bool isLast = false;

  List<BoardingModel> boarding = [
    BoardingModel(
        'assets/image/onboard_2.png',
        'Order for Food',
        'Place order for what you want from\nany restaurant of your choice.',
    ),
    BoardingModel(
      'assets/image/onboard_3.png',
      'Swift Delivery',
      'Receive your order in less than 1hour\nor pick specific delivery time.',
    ),
    BoardingModel(
      'assets/image/onboard_1.png',
      'Tracking Order',
      'Realtime-tracking will keep you\nposted about order progress',
    ),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          if(!isLast)
            TextButton(
          onPressed: sharedBoarding,
          child: BigText(name: 'SKIP', color: AppColors.mainColor,),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: boarding.length,
              onPageChanged: (int index){
                if(index == boarding.length-1){
                  isLast = true;
                } else {
                    isLast = false;
                }
                setState(() {});
              },
              itemBuilder: (context, index) {
                return buildBoarding(context,index);
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget buildBoarding(BuildContext context , int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            boarding[index].image,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height/2.6,
          ),
          SizedBox(height: 30.h,),
          SmoothPageIndicator(
            controller: _pageController,
            count: boarding.length,
            effect: const ExpandingDotsEffect(
              dotColor: Colors.grey,
              activeDotColor: AppColors.mainColor,
              dotHeight: 10,
              dotWidth: 10,
              paintStyle: PaintingStyle.fill,
              spacing: 6,
              expansionFactor: 2
            ),
          ),
          SizedBox(height: 30.h,),
          Text(
            boarding[index].title,
            style: GoogleFonts.alike(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.mainBlackColor,
            )
          ),
          SizedBox(
            height: 25.h,
          ),
          Text(
            boarding[index].description,
            textAlign: TextAlign.center,
            style: GoogleFonts.aBeeZee(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.titleColor,
                height: 1.5,
              ),
          ),
          SizedBox(
            height: 25.h,
          ),
          InkWell(
            onTap: () {
              if (index < boarding.length-1){
                _pageController.nextPage(
                    duration: const Duration(microseconds: 750),
                    curve: Curves.fastLinearToSlowEaseIn,
                );
              } else {
                sharedBoarding();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width/1.2,
              height: MediaQuery.of(context).size.height/17,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  index != boarding.length-1 ? 'Continue':'Get Started',
                  style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void sharedBoarding(){
    CacheHelper.setData(ON_BOARDING, true);
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
          builder: (context) => const FoodDeliveryLayout(),),
      (route) => false);
  }
}
