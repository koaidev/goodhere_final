import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sixam_mart/controller/zopay/qr_code_scanner_controller.dart';


import '../../helper/route_helper.dart';
import '../../main.dart';
import '../../view/base/custom_dialog.dart';
import '../../view/screens/wallet/zopay/selfie_capture/widget/loader_dialog.dart';


class CameraScreenController extends GetxController implements GetxService{
  bool _isBusy = false;
  String _text;
  int _eyeBlink = 0;
  int _isSuccess = 0;

  CameraController controller;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;



  String get text => _text;
  int get captureLoading => _isSuccess;
  int get eyeBlink => _eyeBlink;
  int get isSuccess => _isSuccess;

  bool _fromEditProfile = false;
  bool get fromEditProfile => _fromEditProfile;

  valueInitialize(bool fromEditProfile) {
    _eyeBlink = 0;
    _isSuccess = 0;
    _fromEditProfile = fromEditProfile;
    print('from edit profile value : $_fromEditProfile');
  }

  Future startLiveFeed({bool isQrCodeScan = false,bool isHome = false, String transactionType = ''}) async {
    final List<CameraDescription> cameraList = Get.find();
    final camera = cameraList[isQrCodeScan ? 0 : 1];
    controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      controller.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      controller.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
      controller?.startImageStream((CameraImage cameraImage) => _processCameraImage(cameraImage, isQrCodeScan, isHome, transactionType));
      update();
    });
  }

  Future stopLiveFeed() async {

    try{
      try{
        await controller?.stopImageStream();
      }catch(e) {

      }
      await controller?.dispose();
       controller = null;
      valueInitialize(_fromEditProfile);
    }catch(e){
      print('error is : $e');

    }
  }

  Future _processCameraImage(CameraImage image, isQrCodeScan, bool isHome, String transactionType) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
    Size(image.width.toDouble(), image.height.toDouble());

    final List<CameraDescription> cameraList = Get.find();
    final camera = cameraList[0];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    if(isQrCodeScan) {
      Get.find<QrCodeScannerController>().processImage(inputImage, isHome, transactionType);
    }else{
      processImage(inputImage);
    }
  }

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  File get getImage => _imageFile;
  //MLKit
  Future<void> processImage(InputImage inputImage) async {
    if (_isBusy) return;
    _isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);
    print('eye Blink count is : $_eyeBlink');
    try{
      if(faces.length < 2) {
        print('face detect eye : ${faces[0].rightEyeOpenProbability} || ${faces[0].leftEyeOpenProbability}');
        if(faces[0].rightEyeOpenProbability < 0.1 && faces[0].leftEyeOpenProbability < 0.1 && _eyeBlink < 3) {
          _eyeBlink++;
        }
      }
    }catch(e) {

    }

    if(_eyeBlink == 3) {
      try{
        await controller?.stopImageStream()?.then((value)async {
          showAnimatedDialog(Get.context,
            LoaderDialog(),
              dismissible: false,
              isFlip: true);
          _faceDetector.close();
          final XFile _file =  await controller.takePicture();
          _imageFile =  File(_file.path);
        });
      }catch(e){
        print('error is $e');
      }
      if(_imageFile != null) {
        final inputImage = InputImage.fromFilePath(_imageFile.path);
        processPicture(inputImage);
      }
    }
    update();
    _isBusy = false;
  }

  Future<void> processPicture(InputImage inputImage) async {

    bool _hasHeadEulerAngleY = false;
    bool _hasHeadEulerAngleZ = false;
    bool _hasEyeOpen = false;
    final faces = await _faceDetector.processImage(inputImage);
    try{
      if(faces.length == 1) {
        print('face is ${faces[0].headEulerAngleX} ${faces[0].headEulerAngleY} ${faces[0].headEulerAngleZ}');
        if(faces[0].headEulerAngleY > -15 && faces[0].headEulerAngleY < 15){
          _hasHeadEulerAngleY = true;
        }
        if(faces[0].headEulerAngleZ > -1 && faces[0].headEulerAngleZ < 6){
          _hasHeadEulerAngleZ = true;
        }
        if(faces[0].rightEyeOpenProbability != null && faces[0].leftEyeOpenProbability != null) {
          if(faces[0].rightEyeOpenProbability > 0.2 && faces[0].leftEyeOpenProbability > 0.2){
            _hasEyeOpen = true;
          }
        }
      }
    }catch(e){

    }

    if(_hasEyeOpen || GetPlatform.isIOS) {
      _isSuccess = 1;
      update();
      Future.delayed(Duration(seconds: 1)).then((value) async {
        await _faceDetector.close();
        // stopLiveFeed();
        Get.back();
        // if(_fromEditProfile) {
        //   Get.off(() => EditProfileScreen());
        // }else{
        //   Get.off(() => OtherInfoScreen());
        // }
      });


    }else{
      _isSuccess = 2;
      update();
    }

  }
  // camera
  File _imageFile;


  void removeImage(){
    _imageFile = null;
    update();
  }

  void showDeniedDialog({@required bool fromEditProfile}) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'camera_permission'.tr,
      middleText: 'you_must_allow_permission_for_further_use'.tr,
      confirm: TextButton(onPressed: () async{
        Permission.camera.request().then((value) async{
          var status = await Permission.camera.status;
          if (status.isDenied) {
            Get.back();
            Permission.camera.request();

          }
          else if(status.isGranted){
          }
          else if(status.isPermanentlyDenied){
            return showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
          }
        });


      }, child: Text('allow'.tr)),
    );

  }

  void showPermanentlyDeniedDialog({@required bool fromEditProfile}) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: 'camera_permission'.tr,
        middleText: 'you_must_allow_permission_for_further_use'.tr,
        confirm: TextButton(onPressed: () async {
          final serviceStatus = await Permission.camera.status ;
          if(serviceStatus.isGranted){
            if(fromEditProfile == true){
              Get.back();
              Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }
            else{
              Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
            }
          }
          else{
            await openAppSettings().then((value)async{
              // final serviceStatus = await Permission.camera.status ;
              if(serviceStatus.isGranted){
                if(fromEditProfile == true){
                  Get.back();
                  return Get.toNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
                }
                else{
                  Get.back();
                  return Get.offNamed(RouteHelper.getSelfieRoute(fromEditProfile: fromEditProfile));
                }
              }
              else{
                Get.back();
                showPermanentlyDeniedDialog(fromEditProfile: fromEditProfile);
              }
            });
          }

        }, child: Text('go_to_settings'.tr))
    );
  }
}

