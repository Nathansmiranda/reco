import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reco/networking.dart';
import 'colors.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final recoChatStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.black, backgroundColor: Colors.white);
  final personPic = const CircleAvatar(
    radius: 20,
    foregroundColor: Colors.black,
    child: Icon(Icons.person),
  );
  final scrollController = ScrollController();
  final chatFocus = FocusNode();
  final chatController = TextEditingController();

  bool isLoading = false;

  final totalSpecifications =
      'Recommend a monitor for gaming, 144Hz refresh rate, 16:9 aspect ratio, flat screen';
  final initialPrompt =
      "Recommend a monitor for gaming, 144Hz refresh rate, 16:9 aspect ratio, flat screen. Filter down the results as our conversation continues based on the specifications. After filtering down the results, give me 3 options to choose from. No need to mention the specifications of the product again. Review each product going over pros and cons. Avoid special characters";

  List<Map<String, String>> messages = [
    {
      'sender': 'reco',
      /* 'image': '', */
      'message':
          'Hey there, I am Reco, I recommend products, here are some common categories',
    },
  ];

  final categories = ['Monitor Displays', 'Laptops', 'Headphones', 'Others'];
  final uses = ['Gaming', 'Video Editing', 'Productivity', 'Everyday use'];
  final gamingSpecifications = {
    'Refresh Rate': ['60Hz', '75Hz', '120Hz', '144Hz', '240Hz'],
    'Aspect Ratio': ['4:3', '16:9', '16:10', '21:9'],
    'Curved': ['Yes', 'No']
  };
  final videoEditingSpecifications = {
    'Color Gamut': ['sRGB', 'Adobe RGB', 'DCI-P3', 'Rec 2020'],
  };
  final productivitySpecifications = {
    'Resolution': ['HD', 'FHD', 'QHD', 'UHD'],
    'Panel': ['IPS', 'VA', 'TN'],
    'Ports': [
      'HDMI',
      'DisplayPort',
      'USB A',
      'USB C',
      'Ethernet',
      'Thunderbolt',
      'Audio Jack'
    ]
  };
  final everydaySpecifications = {};

  Widget generateButtons(List<String> strings, String optionMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < strings.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      messages.add({
                        'sender': 'user',
                        /* 'image': '', */
                        'message': strings[i],
                      });
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 200,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                      if (optionMessage.isNotEmpty) {
                        addOptionMessage(optionMessage);
                      } else {
                        final Map<String, dynamic> map = {
                          "model": "text-davinci-003",/* 'gpt-3.5-turbo', */
                          "prompt": initialPrompt,
                          "temperature": 0,
                          "max_tokens": 300,
                        };
                        addRecoMessage(map, isMessageJson: false);
                      }
                    });
                  },
                  child: Text(strings[i])),
            )
        ],
      ),
    );
  }

  SizedBox addOptionMessage(String message/* , String image */) {
    setState(() {
      messages.add({
        'sender': 'reco',
        /* 'image': '', */
        'message': message,
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 500,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
    return const SizedBox();
  }

  Future<void> addRecoMessage(Map<String, dynamic> map,
      {isMessageJson = false}) async {
    setState(() {
      isLoading = true;
    });
    final jsonData = await postChat(map);

    List<Map<String, dynamic>> choices =
        jsonData['choices'].cast<Map<String, dynamic>>().toList();

    String recoMessage = choices[0]['text'];

    recoMessage = recoMessage.substring(2);
    print(recoMessage);

    setState(() {
      isLoading = false;
      if (isMessageJson) {
        Map<String, dynamic> json = jsonDecode(recoMessage);
        for (int i = 0; i < json.length; i++) {
          messages.add(
            {'sender': 'reco', /* 'image': '', */ 'message': json[i]['description']}
          );
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 50,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        }
      } else {
        messages.add({
          'sender': 'reco',
          /* 'image': '', */
          'message': recoMessage,
        });
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 250,
              child: messages.length > 5
                  ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(),
                              textColor: lavendar,
                              iconColor: lavendar,
                              title: const Text('DisplayPort'),
                              childrenPadding: const EdgeInsets.all(10),
                              children: const [
                                Text(
                                    'The DisplayPort is a digital display interface that is commonly used to connect computer monitors and other display devices to a computer or graphics card. The primary use of DisplayPort is to transmit high-quality digital audio and video signals from a computer or graphics card to a monitor. It supports high resolutions, high refresh rates, and deep color depths, making it suitable for demanding applications such as gaming, multimedia editing, and professional graphics work.')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(),
                              textColor: lavendar,
                              iconColor: lavendar,
                              title: const Text('Framerate'),
                              childrenPadding: const EdgeInsets.all(10),
                              children: const [
                                Text(
                                    'The frame rate, also known as refresh rate, refers to the number of individual frames or images that are displayed on the screen per second. It is measured in Hertz (Hz) and indicates how many times the display can update its content within one second. The frame rate is important because it affects the smoothness and fluidity of motion on the screen. A higher frame rate provides a smoother viewing experience, especially in fast-paced content such as video games, action movies, or sports events. With a higher frame rate, the transitions between frames appear more seamless and natural, reducing motion blur and judder.')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ExpansionTile(
                              shape: const RoundedRectangleBorder(),
                              textColor: lavendar,
                              iconColor: lavendar,
                              title: const Text('Resolution'),
                              childrenPadding: const EdgeInsets.all(10),
                              children: const [
                                Text(
                                    'Resolution in monitors refers to the number of pixels displayed on the screen, typically represented as the width and height of the screen in pixels. It determines the level of detail and clarity of the visual content that can be displayed. The resolution is often expressed as a combination of numbers, such as 1920x1080 or 3840x2160, where the first number represents the width and the second number represents the height of the screen in pixels. The total number of pixels is calculated by multiplying these two numbers.')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : const SizedBox(),
            ),
            SizedBox(
              width: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('images/rico_pic.png', height: 80)),
                  const Center(
                    child: Text(
                      'RECO',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 500,
                    child: ListView(
                      controller: scrollController,
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < messages.length; i++)
                          Column(
                            children: [
                              messages[i]['sender'] == 'reco'
                                  ? Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Card(
                                        color: lavendar,
                                        child: Padding(
                                          padding: const EdgeInsets.all(17),
                                          child: Text(
                                            messages[i]['message'] ?? '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.bottomRight,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(17),
                                          child: Text(
                                            messages[i]['message'] ?? '',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 8),
                              if (i % 2 != 0) const SizedBox(height: 10)
                            ],
                          ),
                        if (messages.length == 1)
                          generateButtons(categories,
                              'How do you plan to use your monitor?'),
                        if (messages.length == 3)
                          generateButtons(
                              uses, 'What refresh rate would you like?'),
                        if (messages.length == 5)
                          generateButtons(
                              gamingSpecifications['Refresh Rate']
                                  as List<String>,
                              'What aspect ratio would you like?'),
                        if (messages.length == 7)
                          generateButtons(
                              gamingSpecifications['Aspect Ratio']
                                  as List<String>,
                              'Do you want your screen to be curved?'),
                        if (messages.length == 9)
                          generateButtons(
                              gamingSpecifications['Curved'] as List<String>,
                              ''),
                        if (isLoading)
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Card(
                              color: lavendar,
                              child: Padding(
                                padding: const EdgeInsets.all(17),
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(0, 255, 255, 255),
                          Colors.white
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 00),
                    child: TextField(
                      controller: chatController,
                      focusNode: chatFocus,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Type here',
                          suffixIcon: Icon(
                            Icons.send,
                            color: Color.fromARGB(153, 158, 158, 158),
                          )),
                      onSubmitted: (userMessage) {
                        setState(() {
                          messages.add({
                            'sender': 'user',
                            /* 'image': '', */
                            'message': userMessage,
                          });
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent + 50,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeInOut,
                          );
                        });
                        chatController.clear();
                        chatFocus.requestFocus();

                        final Map<String, dynamic> map = {
                          "model": "text-davinci-003",
                          "prompt": userMessage,
                          "temperature": 0,
                          "max_tokens": 300,
                        };

                        addRecoMessage(map);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: 250,
                child: messages.length > 13
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'You May Also Want',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Card(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  width: 250,
                                  padding: const EdgeInsets.only(
                                      left: 40, bottom: 20),
                                  child: Image.asset('images/hdmi.jpg',
                                      height: 190),
                                ),
                                const Text('Hdmi Cables'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Image.asset(
                                    'images/combo.jfif',
                                    height: 200,
                                  ),
                                ),
                                const Text('Computer Accessories'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Sponsored Items',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      )
                    : const SizedBox())
          ],
        ),
      ),
    );
  }
}
