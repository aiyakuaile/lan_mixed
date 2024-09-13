import 'package:flutter/material.dart';
import 'package:lan_mixed/lan_mixed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAN Mixed Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController messageController = TextEditingController();
  List<DeviceEntity> devices = [];
  List<LanMsgEntity> lanMsgList = [];
  final _deviceScrollController = ScrollController();
  final _msgScrollController = ScrollController();

  @override
  void dispose() {
    LanMixed().close();
    _deviceScrollController.dispose();
    _msgScrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    LanMixed().startService(
      port: 8848,
      onReceiveMsg: (msg) {
        setState(() {
          lanMsgList.add(msg);
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _msgScrollController.animateTo(_msgScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300), curve: Curves.linear);
        });
      },
      onDevicesChange: (devices) {
        setState(() {
          this.devices = devices;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          _deviceScrollController.animateTo(_deviceScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300), curve: Curves.linear);
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LAN Device Discovery'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('LAN Devices'),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      LanMixed().refreshDevices();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFEEEEEE),
                child: ListView.builder(
                  controller: _deviceScrollController,
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      title: Text(device.deviceName ?? ''),
                      subtitle: Text('${device.deviceType} ${device.deviceIp}'),
                      trailing: IconButton(
                        onPressed: () {
                          LanMixed().sendMessage(messageController.text, device.deviceIp!);
                          messageController.clear();
                        },
                        icon: const Icon(Icons.send),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text('Received LAN Msg'),
            Expanded(
              child: Container(
                color: const Color(0xFFEEEEEE),
                child: ListView.builder(
                  controller: _msgScrollController,
                  itemCount: lanMsgList.length,
                  itemBuilder: (context, index) {
                    final lanMsg = lanMsgList[index];
                    return ListTile(
                      title: Text(lanMsg.data ?? ''),
                      subtitle: Text('${lanMsg.device!.deviceName}'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                color: const Color(0xFFDDDDDD),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(labelText: "Enter message", border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () {
                          LanMixed().sendMessage(messageController.text);
                          messageController.clear();
                        },
                        child: const Text('Send')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
