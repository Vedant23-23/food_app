import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_shop_app/components/colors.dart';

import '../../../uitls/app_dimensions.dart';
import 'package:get/get.dart';
class TrackingStepperWidget extends StatelessWidget {
  final String status;
  final bool takeAway;
  TrackingStepperWidget({required this.status, required this.takeAway});

  @override
  Widget build(BuildContext context) {
    int _status = -1;
    if(status == 'pending') {
      _status = 0;
    }else if(status == 'accepted' || status == 'confirmed') {
      _status = 1;
    }else if(status == 'processing') {
      _status = 2;
    }else if(status == 'handover') {
      _status = takeAway ? 3 : 2;
    }else if(status == 'picked_up') {
      _status = 3;
    }else if(status == 'delivered') {
      _status = 4;
    }

    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      child: Row(children: [
        CustomStepper(
          title: 'order_placed'.tr, isActive: _status > -1, haveLeftBar: false, haveRightBar: true, rightActive: _status > 0,
        ),
        CustomStepper(
          title: 'order_confirmed'.tr, isActive: _status > 0, haveLeftBar: true, haveRightBar: true, rightActive: _status > 1,
        ),
        CustomStepper(
          title: 'preparing_food'.tr, isActive: _status > 1, haveLeftBar: true, haveRightBar: true, rightActive: _status > 2,
        ),
        CustomStepper(
          title: takeAway ? 'ready_for_handover'.tr : 'food_on_the_way'.tr, isActive: _status > 2, haveLeftBar: true, haveRightBar: true, rightActive: _status > 3,
        ),
        CustomStepper(
          title: 'delivered'.tr, isActive: _status > 3, haveLeftBar: true, haveRightBar: false, rightActive: _status > 4,
        ),
      ]),
    );
  }
}

class CustomStepper extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final String title;
  final bool rightActive;
  CustomStepper({required this.title, required this.isActive, required this.haveLeftBar, required this.haveRightBar,
    required this.rightActive});

  @override
  Widget build(BuildContext context) {
    Color _color = isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    Color _right = rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return Expanded(
      child: Column(children: [

        Row(children: [
          Expanded(child: haveLeftBar ? Divider(color: _color, thickness: 2) : SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isActive ? 0 : 5),
            child: Icon(isActive ? Icons.check_circle : Icons.blur_circular, color: _color, size: isActive ? 25 : 15),
          ),
          Expanded(child: haveRightBar ? Divider(color: _right, thickness: 2) : SizedBox()),
        ]),

        Text(
          title+'\n', maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          style: TextStyle(color: _color, fontSize: Dimensions.fontSizeExtraSmall),
        ),

      ]),
    );
  }
}

