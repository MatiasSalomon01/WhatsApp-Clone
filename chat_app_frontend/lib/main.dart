import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });
  final String serverUrl = 'http://localhost:5003/chat-hub';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();

  late final HubConnection connection;
  List<String> messages = [];
  UniqueKey key = UniqueKey();
  bool isChatRoom = false;
  String userName = '';
  final Map<String, List<String>> content = {};
  final TextEditingController chatController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    buildConnection();
    connection.onclose((exception) => onClosed);
    connection.on(
      'ReceiveMessage',
      (arguments) async {
        print(arguments);
        for (var data in arguments!) {
          if (content.containsKey(data["user"])) {
            var value = data["message"].toString();
            content[data["user"]] = [...content[data["user"]]!, value];
          } else {
            var keyValue = {
              data["user"].toString(): [data["message"].toString()],
            };
            content.addAll(keyValue);
          }
        }
        setState(() {});
      },
    );
  }

  buildConnection() {
    connection = HubConnectionBuilder().withUrl(widget.serverUrl).build();
  }

  void onClosed(Exception exception) => print('connection closed');

  Future connect() async {
    await connection.start();
  }

  Future sendAll(String message) async {
    await connection.invoke('SendAll', args: [userName, message]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 29, 75, 62),
        title: const Text(
          'CHAT - APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 36, 36),
      body: isChatRoom
          ? Container(
              margin: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        ...content.keys
                            .map(
                              (key) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // if (e != userName)
                                  //   Text(
                                  //     e.toString(),
                                  //     style: const TextStyle(
                                  //       color: Colors.purple,
                                  //       fontSize: 14,
                                  //     ),
                                  //   ),
                                  ...content[key]!.map(
                                    (value) => Align(
                                      alignment: key != userName
                                          ? Alignment.bottomLeft
                                          : Alignment.bottomRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: key != userName
                                              ? const Color.fromARGB(
                                                  255, 43, 44, 44)
                                              : const Color.fromARGB(
                                                  255, 29, 75, 62),
                                        ),
                                        child: Text(
                                          value.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList()
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: chatController,
                    focusNode: _focusNode,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.grey,
                    onEditingComplete: () {},
                    onSaved: (newValue) {},
                    onFieldSubmitted: (value) {
                      sendAll(value);
                      chatController.text = '';
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 29, 75, 62),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: .5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: .5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: .5),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 250,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.grey,
                        onFieldSubmitted: (value) async {
                          setState(() => userName = value);
                          await enterChat();
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 29, 75, 62),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: .5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: .5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: .5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: .5),
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 29, 75, 62),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(25)),
                      shape: MaterialStateProperty.all(
                        const StadiumBorder(
                          side: BorderSide(color: Colors.white, width: .3),
                        ),
                      ),
                    ),
                    onPressed: () async => enterChat(),
                    child: const Text(
                      'Send Message',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Text('CHAT APP'),
      //       ...messages.map((e) => Text(e)).toList(),
      // ElevatedButton(
      //   onPressed: () async {
      //     sendMessage(UniqueKey().toString());
      //   },
      //   child: const Text('Send Message'),
      // )
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.cloud_done_outlined),
      //   onPressed: () async => await connect(),
      // ),
    );
  }

  Future enterChat() async {
    setState(() => isChatRoom = true);
    await connect();
  }
}
