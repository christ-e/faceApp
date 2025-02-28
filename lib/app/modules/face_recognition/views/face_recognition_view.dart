import 'package:facerecognition_flutter/app/modules/face_recognition/views/face_detection_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/face_recognition_controller.dart';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class FaceRecognitionView extends GetView<FaceRecognitionController> {
  const FaceRecognitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Recognition'),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera preview and face detection overlay
          FaceDetectionView(controller: controller),
          Obx(() => SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(
                  painter: FacePainter(
                    faces: controller.faces.value,
                    livenessThreshold: controller.livenessThreshold,
                  ),
                ),
              )), // Hide if no faces detected

          // Recognition results
          Obx(() {
            if (controller.recognized.value) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (controller.enrolledFace.value != null)
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  controller.enrolledFace.value!,
                                  width: 160,
                                  height: 160,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text('Enrolled'),
                            ],
                          ),
                        if (controller.identifiedFace.value != null)
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  controller.identifiedFace.value!,
                                  width: 160,
                                  height: 160,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text('Identified'),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Employee Id: ${controller.identifiedempid.value}'),
                    const SizedBox(height: 10),
                    Text('Employee Name: ${controller.identifiedName.value}'),
                    const SizedBox(height: 10),
                    Text(
                        'Designation: ${controller.identifieddesignation.value}'),
                    ElevatedButton(
                      onPressed: () {
                        controller.resetRecognition();
                        controller.startFaceRecognition();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }
}

// Custom painter for drawing face bounding boxes
class FacePainter extends CustomPainter {
  dynamic faces;
  double livenessThreshold;
  FacePainter({required this.faces, required this.livenessThreshold});

  @override
  void paint(Canvas canvas, Size size) {
    if (faces != null) {
      var paint = Paint();
      paint.color = const Color.fromARGB(0xff, 0xff, 0, 0);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;

      for (var face in faces) {
        double xScale = face['frameWidth'] / size.width;
        double yScale = face['frameHeight'] / size.height;

        String title = "";
        Color color = const Color.fromARGB(0xff, 0xff, 0, 0);
        if (face['liveness'] < livenessThreshold) {
          color = const Color.fromARGB(0xff, 0xff, 0, 0);
          title = "Spoof${face['liveness']}";
        } else {
          color = const Color.fromARGB(0xff, 0, 0xff, 0);
          title = "Real ${face['liveness']}";
        }

        TextSpan span =
            TextSpan(style: TextStyle(color: color, fontSize: 20), text: title);
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(face['x1'] / xScale, face['y1'] / yScale - 30));

        paint.color = color;
        canvas.drawRect(
            Offset(face['x1'] / xScale, face['y1'] / yScale) &
                Size((face['x2'] - face['x1']) / xScale,
                    (face['y2'] - face['y1']) / yScale),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


// CircularCountDownTimer(
//      duration: 5,
//      initialDuration: 0,
//      controller: CountDownController(),
//      width: MediaQuery.of(context).size.width / 2,
//      height: MediaQuery.of(context).size.height / 2,
//      ringColor: Colors.grey[300]!,
//      ringGradient: null,
//      fillColor: Colors.purpleAccent[100]!,
//      fillGradient: null,
//      backgroundColor: Colors.purple[500],
//      backgroundGradient: null,
//      strokeWidth: 20.0,
//      strokeCap: StrokeCap.round,
//      textStyle: TextStyle(
//          fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
//      textAlign: TextAlign.center,
//      textFormat: CountdownTextFormat.S,
//      isReverse: false,
//      isReverseAnimation: false,
//      isTimerTextShown: false,
//      autoStart: true,
//      onStart: () {
//         debugPrint('Countdown Started');
//      },
//      onComplete: () {
//        controller.resetRecognition();
// controller.startFaceRecognition();
//         debugPrint('Countdown Ended');
//      },
//      onChange: (String timeStamp) {
//         debugPrint('Countdown Changed $timeStamp');
//      },
//      timeFormatterFunction: (defaultFormatterFunction, duration) {
//         if (duration.inSeconds == 0) {
//            return "Start";
//         } else {
//            return Function.apply(defaultFormatterFunction, [duration]);
//         }
//      },
//  ),