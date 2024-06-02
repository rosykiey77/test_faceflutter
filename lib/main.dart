import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Absensi karyawan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   late List<CameraDescription> _cameras;
   late CameraController _cameraController;
   late FaceDetector _faceDetector;
   bool _isOn = false;

   Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
   }

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true));
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
      _startFaceDetection();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  void _startFaceDetection() {
    _cameraController.startImageStream((image) async {
      final faces = await _faceDetector.processImage(image as InputImage);
      for (Face face in faces) {
        // Do something with the detected face, such as drawing a rectangle around it.
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _isOn = !_isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton(
              onPressed: () {
                _incrementCounter();
              },
               style: ElevatedButton.styleFrom(
                backgroundColor: _isOn ? const Color.fromARGB(255, 175, 233, 177) : const Color.fromARGB(255, 255, 136, 128),
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(_isOn ? 'IN' : 'OUT',
                style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                 ),
              ),
            ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _incrementCounter();
              },
               style: ElevatedButton.styleFrom(
                backgroundColor: _isOn ? const Color.fromARGB(255, 175, 233, 177) : const Color.fromARGB(255, 255, 136, 128),
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(_isOn ? 'IN' : 'OUT',
                style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                 ),
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
