// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../../../controller/zopay/camera_screen_controller.dart';
//
// class CameraView extends StatefulWidget {
//   @override
//   _CameraViewState createState() => _CameraViewState();
// }
//
// class _CameraViewState extends State<CameraView> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CameraScreenController>(builder: (cameraController) {
//       if (cameraController.controller.value.isInitialized == false) {
//         return SizedBox();
//       }
//       final size = MediaQuery.of(context).size;
//       return Container(
//         color: Colors.black,
//         height: size.height * 0.7,
//         width: size.width,
//         child: AspectRatio(
//           aspectRatio: cameraController.controller.value.aspectRatio,
//           child: CameraPreview(cameraController.controller),
//         ),
//       );
//     });
//   }
// }
