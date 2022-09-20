import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/components/small_text.dart';
import 'package:food_delivery/utils/colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double size;
  const ExpandableText({Key? key, required this.text, this.size = 0}) : super(key: key);


  @override
  State<ExpandableText> createState() => _ExpandableState();



}

class _ExpandableState extends State<ExpandableText> {

  late String firstParts;
  late String secondParts;
  int height = 120.h.toInt();
  bool hiddenText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.text.length>height){
      firstParts = widget.text.substring(0, height);
      secondParts = widget.text.substring(height+1, widget.text.length);
    }else {
      firstParts = widget.text.substring(0, widget.text.length);
      secondParts = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondParts.isEmpty?SmallText(name: widget.text, height: 1.8.h, size: widget.size==0?12.sp:widget.size,):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          SmallText(name: hiddenText?'$firstParts....':(firstParts+secondParts) , height: 1.8.h, size: widget.size==0?13.sp:widget.size , color: AppColors.titleColor),
          InkWell(

            onTap: () {
              setState((){
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SmallText(name: hiddenText?'Show more':'Show less', height: 1.8.h, size: widget.size==0?13.sp:widget.size , color: AppColors.mainColor,),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up, color: AppColors.mainColor,),
              ],
            ),
          ),
          SizedBox(height: 5.h,),
        ],
      ),
    );
  }
}
