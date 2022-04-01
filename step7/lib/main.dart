//Step7.過去の着順を表示する
import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

class Square extends StatelessWidget {
  const Square({
    Key? key,
    required this.onTap,
    required this.value,
  }) : super(key: key);

  final void Function() onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(9, 9, 9, 1), width: 1),
        ),
        child: Center(
          child: Text(
            value ?? '',
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
    required this.onTap,
    required this.squares,
  }) : super(key: key);

  final void Function(int i) onTap;
  final List<String?> squares;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34 * 3,
      width: 34 * 3,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (int i) => Square(
            onTap: () => onTap(i),
            value: squares[i],
          ),
        ),
      ),
    );
  }
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Map<String, List<String?>>> _history = [
    {'squares': List.generate(9, (index) => null)}
  ];
  bool _xIsNext = true;

  void handleClick(int i) {
    final history = _history;
    final current = history[history.length - 1];
    final squares = current['squares']!.sublist(0);

    if (calculateWinner(squares) != null || squares[i] != null) {
      return;
    }
    squares[i] = _xIsNext ? 'X' : 'O';
    history.add({'squares': squares});
    setState(() {
      _history = history;
      _xIsNext = !_xIsNext;
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = _history;
    final current = history[history.length - 1];
    final winner = calculateWinner(current['squares']!);

    final moves = history.map((squares) {
      final step = history.indexOf(squares);
      final desc = step != 0 ? 'Go to move #$step' : 'Go to game start';
      return ElevatedButton(onPressed: () {}, child: Text(desc));
    }).toList();

    String status;

    if (winner != null) {
      status = 'Winner: $winner';
    } else {
      status = 'Next player: ${_xIsNext ? 'X' : 'O'}';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Board(
                onTap: handleClick,
                squares: current['squares']!,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(status),
                    ),
                    Column(
                      children: moves,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? calculateWinner(List<String?> squares) {
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];
  for (var i = 0; i < lines.length; i++) {
    final indexs = lines[i];
    if (squares[indexs[0]] != null &&
        squares[indexs[0]] == squares[indexs[1]] &&
        squares[indexs[0]] == squares[indexs[2]]) {
      return squares[indexs[0]];
    }
  }
  return null;
}
