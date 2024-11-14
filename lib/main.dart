import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewsFeedScreen(),
    );
  }
}

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<List<int>> _newsFeed = [];
  int _rows = 5;
  int _columns = 5;
  int _feedCounter = 1;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadInitialNews();
  }

  void _loadInitialNews() {
    setState(() {
      _newsFeed = List.generate(_rows, (i) => List.generate(_columns, (j) {
        int newsId = _feedCounter++;
        return newsId;
      }));
    });
  }

  void _addMoreRows({bool atStart = false}) {
    if (_isAdding) return;
    _isAdding = true;

    setState(() {
      List<List<int>> newRows = List.generate(5, (i) => List.generate(_columns, (j) {
        int newsId = _feedCounter++;
        return newsId;
      }));
      if (atStart) {
        _newsFeed.insertAll(0, newRows);
      } else {
        _newsFeed.addAll(newRows);
      }
      _rows += 5;
      _isAdding = false;
    });
  }

  void _addMoreColumns({bool atStart = false}) {
    if (_isAdding) return;
    _isAdding = true;

    setState(() {
      for (int i = 0; i < _rows; i++) {
        int newsId = _feedCounter++;
        if (atStart) {
          _newsFeed[i].insert(0, newsId);
        } else {
          _newsFeed[i].add(newsId);
        }
      }
      _columns += 5;
      _isAdding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.5,
        maxScale: 2.0,
        child: GestureDetector(
          onPanUpdate: (details) {
            // Detect when near the edges and load new rows or columns accordingly
            if (details.delta.dx > 0 && details.localPosition.dx > MediaQuery.of(context).size.width * 0.9) {
              _addMoreColumns();
            } else if (details.delta.dx < 0 && details.localPosition.dx < MediaQuery.of(context).size.width * 0.1) {
              _addMoreColumns(atStart: true);
            }
            if (details.delta.dy > 0 && details.localPosition.dy > MediaQuery.of(context).size.height * 0.9) {
              _addMoreRows();
            } else if (details.delta.dy < 0 && details.localPosition.dy < MediaQuery.of(context).size.height * 0.1) {
              _addMoreRows(atStart: true);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _newsFeed.asMap().entries.map((entry) {
                int rowIndex = entry.key;
                List<int> row = entry.value;

                return Padding(
                  padding: EdgeInsets.only(left: rowIndex.isOdd ? 160 : 0),  // Zig-zag layout
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: row.map((newsId) {
                      Color cardColor = newsId % 2 == 0
                          ? Colors.blue.shade100
                          : Colors.red.shade100;

                      return Container(
                        width: 160,
                        height: 120,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'News $newsId',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Date',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade700,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '70%',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}