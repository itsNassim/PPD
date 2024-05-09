import 'package:despinterface/loginScreen.dart';
import 'package:despinterface/mapScreen.dart';
import 'package:despinterface/recieveCall.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DispatcherScreen extends StatefulWidget {
  const DispatcherScreen({super.key});

  @override
  _DispatcherScreenState createState() => _DispatcherScreenState();
}

class _DispatcherScreenState extends State<DispatcherScreen>
    with SingleTickerProviderStateMixin {
  Color primary = const Color.fromARGB(255, 62, 99, 137);
  bool _showReceiveCallPage = false;
  bool _showDiscussion = false;
  late TabController _tabController;
  bool _showDispatcherScreen = true; // Added

  void _logout(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void showUserListPanel(BuildContext context, List<User2> users) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Color(0xFF333333),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'User List',
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 99, 137),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tileColor: const Color.fromARGB(255, 62, 99, 137),
                onTap: () {}, // Optional: Add functionality to the list tile
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        users[index].name,
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      // subtitle: Text(users[index].details),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add functionality to call the user
                            },
                            icon: Icon(Icons.phone),
                            color: Color.fromARGB(255, 62, 99, 137),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add functionality to report the user
                            },
                            icon: Icon(Icons.report),
                            color: Color.fromARGB(255, 62, 99, 137),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiveCallButton() {
    return Column(
      children: [
        SizedBox(height: 60),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showReceiveCallPage = !_showReceiveCallPage;
              _showDiscussion = _showReceiveCallPage;
              _showDispatcherScreen = !_showReceiveCallPage; // Toggle here
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primary,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 70),
          ),
          child: Text(_showReceiveCallPage ? 'End Call' : 'Receive Call'),
        ),
      ],
    );
  }

  Widget _voluntaryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: [
                Text(
                  '     Voluntaries List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        _voluntaryItem(' Touati nassim  '),
        _voluntaryItem(' chelghoum aya '),
        _voluntaryItem(' lanani ghania '),
        _voluntaryItem(' Hamma souheila '),
      ],
    );
  }

  Widget _voluntaryItem(String name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Add functionality to call the voluntary
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(40, 40),
            backgroundColor: Color.fromRGBO(62, 99, 137, 1),
            foregroundColor: Colors.white,
          ),
          child: Icon(
            Icons.phone,
            size: 20,
          ),
        ),
      ],
    );
  }

  String _currentMessage = '';
  List<String> messages = [];
  TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) {
    DateTime now = DateTime.now();
    String timestamp = DateFormat('HH:mm a').format(now);
    String messageWithTime = '$message - $timestamp';
    setState(() {
      messages.add(messageWithTime);
      _currentMessage = '';
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: _showDispatcherScreen // Conditionally show DispatcherScreen
          ? _dispatcherScreenContent()
          : _receiveCallScreenContent(),
    );
  }

  Widget _dispatcherScreenContent() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Features',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _receiveCallButton(),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        showUserListPanel(context, users);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primary,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 70),
                      ),
                      child: Text(
                        '  History      ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primary,
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 70),
                      ),
                      child: Text(
                        '    Log Out    ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!_showReceiveCallPage)
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      'image/AidNow9.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_showReceiveCallPage) const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 2,
          child: MapScreen(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: _showDiscussion ? 3 : 6,
                child: ListView(
                  children: [
                    _voluntaryList(),
                  ],
                ),
              ),
              if (_showReceiveCallPage) const Divider(thickness: 1, height: 1),
              Expanded(
                flex: _showDiscussion ? 6 : 3,
                child: _showDiscussion
                    ? Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: 'Discussion'),
                              Tab(
                                  text:
                                      'Video call'), // Change the text as per your other feature
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  margin: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Discussion',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: messages.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      62, 99, 137, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    messages[index],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: _messageController,
                                              onChanged: (value) {
                                                setState(() {
                                                  _currentMessage = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Type your message here...',
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              maxLines: null,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              _sendMessage(_currentMessage);
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Color.fromRGBO(62, 99, 137, 1),
                                              ),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.white,
                                              ),
                                            ),
                                            child: Text('Send'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Placeholder for other feature
                                Container(
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text(
                                      'Other Feature Content',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _receiveCallScreenContent() {
    return ReceiveCallScreen();
  }
}

class User2 {
  final String name;

  User2(this.name);
}

List<User2> users = [
  User2('Larekeb khadidja'),
  User2('Soussi heithem'),
  User2('Zaatout doua'),
  // Add more users as needed
];
