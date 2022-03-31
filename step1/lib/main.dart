import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

class Square extends StatelessWidget {
  const Square({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(9, 9, 9, 1), width: 1),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  const Board({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Next Player: X'),
        SizedBox(
          height: 34 * 3,
          width: 34 * 3,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              9,
              (int i) => Square(value: '$i'),
            ),
          ),
        ),
      ],
    );
  }
}

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Board(),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(children: const []),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
