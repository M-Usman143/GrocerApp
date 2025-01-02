import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollSlider extends StatefulWidget {
  @override
  State<AutoScrollSlider> createState() => _AutoScrollSliderState();
}
class _AutoScrollSliderState extends State<AutoScrollSlider> {
  final PageController _pageController = PageController(initialPage: 0);
  final int _totalPages = 5; // Total slides/cards
  int _currentPage = 0;
  Timer? _timer;

  // Data source for each slider
  final List<Map<String, dynamic>> _sliderData = [
    {
      'image': 'assets/categoryimages/fishslider.png', // Red background image
      'title': 'FISH SEASON IS BACK!',
      'color': Colors.teal,
    },
    {
      'image': 'assets/categoryimages/noodlesslider.png',
      'title': 'New offer, waits you!',
      'color': Colors.orange,
    },
    {
      'image': 'assets/categoryimages/cookingoilslider.png',
      'title': 'NEW COLLECTION ARRIVED!',
      'color': Colors.purple,
    },
    {
      'image': 'assets/categoryimages/speskerslider.png', // Yellow background image
      'title': 'DISCOUNT ON ELECTRONICS!',
      'color': Colors.red,
    },
    {
      'image': 'assets/categoryimages/teaslider.png', // Pink background image
      'title': 'GET READY FOR SUMMER!',
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();

    // Timer for automatic scrolling
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 250, // Card height
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildCard(index); // Pass the index to display different content
            },
          ),
        ),
        const SizedBox(height: 10),
        // Progress Indicator
        _buildProgressIndicator(),
      ],
    );
  }

  // Extracted Function for Card with dynamic content based on the index
  Widget _buildCard(int index) {
    final slider = _sliderData[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: slider['color'], // Dynamic background color
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background graphics or decoration (optional)
            Positioned(
              top: 50,
              left: 20,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.crisis_alert, size: 100, color: Colors.white),
              ),
            ),
            // Card Content
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top:10 , left: 5),
                  child: Text(
                    slider['title'], // Dynamic title
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
            Column(children: [
              Container(
                margin: EdgeInsets.only(left: 150 , top: 33),
                child: Image.asset(
                  slider['image'],
                  height: 200,
                  width: 230,
                  fit: BoxFit.contain,
                ),
              ),
            ],),
            Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(right: 190 , top: 170),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: slider['color'], // Dynamic button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Handle button action
                    },
                    child: const Text("SHOP NOW"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Extracted Function for Progress Dots
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _totalPages,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.orange : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
