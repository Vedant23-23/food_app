import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_e_commerce_shop_app/screens/order/widgets/order_stepping_widgets.dart';

import '../../components/colors.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/address_model.dart';
import '../../models/order_model.dart';
import '../../uitls/app_dimensions.dart';
import '../../uitls/images.dart';
/*
class OrderTrackingScreen extends StatefulWidget {
  final String orderID;

  OrderTrackingScreen({required this.orderID});

  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with WidgetsBindingObserver {
  late GoogleMapController _controller;
  bool _isLoading = true;
  Set<Marker> _markers = HashSet<Marker>();

  void _loadData() async {
    await Get.find<LocationController>().getCurrentLocation(true,
        notify: false,
        defaultLatLng: LatLng(
          double.parse(
              Get.find<LocationController>().getUserAddress().latitude),
          double.parse(
              Get.find<LocationController>().getUserAddress().longitude),
        ));
    Get.find<OrderController>().trackOrder(widget.orderID, null, true);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _loadData();
    // Get.find<OrderController>().callTrackOrderApi(orderModel: Get.find<OrderController>().trackModel, orderId: widget.orderID.toString());
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Get.find<OrderController>().callTrackOrderApi(
          orderModel: Get.find<OrderController>().trackModel,
          orderId: widget.orderID.toString());
    } else if (state == AppLifecycleState.paused) {
      Get.find<OrderController>().cancelTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    Get.find<OrderController>().cancelTimer();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("order_tracking".tr),
      ),
      body: GetBuilder<OrderController>(builder: (orderController) {
        OrderModel? _track;
        if (orderController.trackModel != null) {
          _track = orderController.trackModel;

          /*if(_controller != null && GetPlatform.isWeb) {
            if(_track.deliveryAddress != null) {
              _controller.showMarkerInfoWindow(MarkerId('destination'));
            }
            if(_track.restaurant != null) {
              _controller.showMarkerInfoWindow(MarkerId('restaurant'));
            }
            if(_track.deliveryMan != null) {
              _controller.showMarkerInfoWindow(MarkerId('delivery_boy'));
            }
          }*/
        }

        return _track != null
            ? Center(
                child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Stack(children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.parse(_track.deliveryAddress!.latitude),
                              double.parse(_track.deliveryAddress!.longitude),
                            ),
                            zoom: 16),
                        minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                        zoomControlsEnabled: true,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                          _isLoading = false;
                        },
                      ),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox(),
                      Positioned(
                        top: Dimensions.PADDING_SIZE_SMALL,
                        left: Dimensions.PADDING_SIZE_SMALL,
                        right: Dimensions.PADDING_SIZE_SMALL,
                        child: TrackingStepperWidget(
                            status: _track.orderStatus!,
                            takeAway: _track.orderType == 'take_away'),
                      ),
                      Positioned(
                        bottom: Dimensions.PADDING_SIZE_SMALL,
                        left: Dimensions.PADDING_SIZE_SMALL,
                        right: Dimensions.PADDING_SIZE_SMALL,
                        child: TrackDetailsView(
                            track: _track,
                            callback: () async {
                              orderController.cancelTimer();
                              /*await Get.toNamed(RouteHelper.getChatRoute(
                notificationBody: NotificationBody(deliverymanId: _track.deliveryMan.id, orderId: int.parse(widget.orderID)),
                user: User(id: _track.deliveryMan.id, fName: _track.deliveryMan.fName, lName: _track.deliveryMan.lName, image: _track.deliveryMan.image),
              ));*/
                              orderController.callTrackOrderApi(
                                  orderModel: _track,
                                  orderId: _track.id.toString());
                            }),
                      ),
                    ])))
            : Center(child: CircularProgressIndicator());
      }),
    );
  }

  Future<void> zoomToFit(
      GoogleMapController controller, LatLngBounds bounds, LatLng centerBounds,
      {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck =
        screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck =
        screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck =
        screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck =
        screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck &&
        northEastLongitudeCheck &&
        southWestLatitudeCheck &&
        southWestLongitudeCheck;
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath,
      {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
*/