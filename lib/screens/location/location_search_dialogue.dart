
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/location_controller.dart';
import '../../uitls/app_dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController mapController;
  LocationSearchDialog({required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top : 0),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: SingleChildScrollView(
          child: TypeAheadField<Prediction>(
            suggestionsCallback: (pattern) async{
              return await Get.find<LocationController>().searchLocation(context, pattern);
              },
            builder: (context, controller, focusNode) {
              return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  )
              );
            },
            itemBuilder: (context, Prediction suggestion) {
              return ListTile(
                title: Text("${suggestion.placeId}"),
                subtitle: Text("${suggestion.description}"),
              );
            },
            onSelected: (Prediction suggestion) {
              print("My location is "+suggestion.description!);
              Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
              Get.back();

            },
          ),
        )),
      ),
    );
  }
}

// TypeAheadField(
// textFieldConfiguration: TextFieldConfiguration(
// controller: _controller,
// textInputAction: TextInputAction.search,
// autofocus: true,
// textCapitalization: TextCapitalization.words,
// keyboardType: TextInputType.streetAddress,
// decoration: InputDecoration(
// hintText: 'search_location'.tr,
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(10),
// borderSide: BorderSide(style: BorderStyle.none, width: 0),
// ),
// hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
// fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
// ),
// filled: true, fillColor: Theme.of(context).cardColor,
// ),
// style: Theme.of(context).textTheme.headline2?.copyWith(
// color: Theme.of(context).textTheme.bodyText1?.color,
// fontSize: Dimensions.fontSizeLarge,
// ),
// ),
// suggestionsCallback: (pattern) async {
// return await Get.find<LocationController>().searchLocation(context, pattern);
// },
// itemBuilder: (context, Prediction suggestion) {
// return Padding(
// padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
// child: Row(children: [
// Icon(Icons.location_on),
// Expanded(
// child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
// style: Theme.of(context).textTheme.headline2?.copyWith(
// color: Theme.of(context).textTheme.bodyText1?.color,
// fontSize: Dimensions.fontSizeLarge,
// )),
// ),
// ]),
// );
// },
// onSelected: (Prediction suggestion) {
// print("My location is "+suggestion.description!);
// Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!,
// mapController);
// Get.back();
// },
// )
