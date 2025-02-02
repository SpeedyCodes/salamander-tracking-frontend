import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:salamander_tracker/globals.dart' as globals;

class ProcessedImagesScreen extends StatefulWidget {

  
  final int sightingId;
  const ProcessedImagesScreen({super.key, required this.sightingId});
  @override
  State<ProcessedImagesScreen> createState() => _ProcessedImagesScreenState();
}

class _ProcessedImagesScreenState extends State<ProcessedImagesScreen> {
  final List<String> imageUrls = [
    'pose_estimation',
    'cropped',
    'dot_detection',
    'straightened_dots'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Processed Images'),
      ),
      body: CarouselSlider.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index, realIndex) {
          return PhotoView(
            imageProvider: NetworkImage(
                    '${globals.serverAddress}/sightings/${widget.sightingId}/image/${imageUrls[index]}'),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          enlargeCenterPage: true,
          autoPlay: false,
          aspectRatio: 16 / 9,
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: false,
        ),
      ),
    );
  }
}