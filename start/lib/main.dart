import 'package:flutter/material.dart';

void main() {
  runApp(const Game());
}

class Square extends StatelessWidget {
  final void Function() onTap;
  final String? value;

  const Square({
    Key? key,
    required this.onTap,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          border:
              Border.all(color: const Color.fromRGBO(9, 9, 9, 1.0), width: 1),
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
  final void Function(int i) onTap;
  final List<String?> squares;

  const Board({
    Key? key,
    required this.onTap,
    required this.squares,
  }) : super(key: key);

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
          (int i) => Square(onTap: () => onTap(i), value: squares[i],),
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
  int _stepNumber = 0;
  bool _xIsNext = true;

  handleClick(int i) {
    List<Map<String, List<String?>>> history =
        _history.sublist(0, _stepNumber + 1);
    Map<String, List<String?>> current = history[history.length - 1];
    List<String?> squares = current['squares']!.sublist(0);

    if (calculateWinner(squares) != null || squares[i] != null) {
      return;
    }
    squares[i] = _xIsNext ? 'X' : 'O';
    history.add({'squares': squares});
    setState(() {
      _history = history;
      _stepNumber = history.length-1;
      _xIsNext = !_xIsNext;
    });
  }

  jumpTo(step) {
    setState(() {
      _stepNumber = step;
      _xIsNext = (step % 2) == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, List<String?>>> history = _history;
    Map<String, List<String?>> current = history[_stepNumber];
    String? winner = calculateWinner(current['squares']!);

    List<ElevatedButton> moves = history.map((squares) {
      int step = history.indexOf(squares);
      String desc = step != 0 ? 'Go to move #$step' : 'Go to game start';
      return ElevatedButton(onPressed: () => jumpTo(step), child: Text(desc));
    }).toList();

    String status;

    if (winner != null) {
      status = 'Winner: ' + winner;
    } else {
      status = 'Next player: ' + (_xIsNext ? 'X' : 'O');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Board(
                onTap: (index) => handleClick(index),
                squares: current['squares']!),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(status),
                ),
                Column(
                  children: moves,
                )
              ]),
            ),
          ],
        ),
      )),
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
  for (int i = 0; i < lines.length; i++) {
    final List<int> indexs = lines[i];
    if (squares[indexs[0]] != null &&
        squares[indexs[0]] == squares[indexs[1]] &&
        squares[indexs[0]] == squares[indexs[2]]) {
      return squares[indexs[0]]!;
    }
  }
  return null;
}
