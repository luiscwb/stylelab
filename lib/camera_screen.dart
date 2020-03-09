import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CamperaApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CamperaApp> {
  List<CameraDescription> _cameras;
  int _selectedCameraIdx;
  CameraController _controller;

  @override
  void initState() {
    super.initState();

    // availableCameras() is part of the camera plugin which will return a list of available cameras
    // on the device.
    availableCameras().then((avCams) {
      _cameras = avCams;
      if (_cameras.length > 0) {
        //Initially, selectedCameraIdx will be 0, as you will be loading the back camera at every cold launch of the app
        setState(() => _selectedCameraIdx = 0);
        _initCameraController(_cameras[_selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError(
        (err) => debugPrint('Error: $err.code\nError Message: $err.message'));
  }

  // Is responsible for initializing the CameraController object. Initializing a CameraController
  // object is asynchronous work. Hence the return type of this method is a Future.
  // CameraDescription will hold the type of camera(front or back) you want to use
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    // You are creating a CameraController object which takes two arguments, first a cameraDescription
    // and second a resolutionPreset with which the picture should be captured.
    // ResolutionPreset can have only 3 values i.e high, mediumand low.
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    // addListener() will be called when the controller object is changed.
    // For example, this closure will be called when you switch between the front and back camera.
    _controller.addListener(() {
      // mounted is a getter method which will return a boolean value indicating whether the
      // _CameraAppState object is currently in the widget tree or not.
      if (mounted) {
        setState(() {});
      }

      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    // While initializing the controller object if something goes wrong you will catch the error in a try/catch block.
    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e.description);
      //_showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      if (!_controller.value.isInitialized) {
        return Container();
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          //key: _scaffoldKey,
          extendBody: true,
          body: Stack(
            children: <Widget>[
              _buildCameraPreview(),
            ],
          ),
        );
      }
    } else {
      return const Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _buildCameraPreview() {
    final size = MediaQuery.of(context).size;
    return ClipRect(
      child: Container(
        child: Transform.scale(
          scale: _controller.value.aspectRatio / size.aspectRatio,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
          ),
        ),
      ),
    );
  }
}
