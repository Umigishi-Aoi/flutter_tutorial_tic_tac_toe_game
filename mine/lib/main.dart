//Step3.親から子にメソッドを渡そう
import 'dart:collection';

import 'package:flutter/material.dart';

const TEXT_SIZE = 24.0;
const SQUARE_SIZE = 34.0;

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
        height: SQUARE_SIZE,
        width: SQUARE_SIZE,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(9, 9, 9, 1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            value ?? '',
            style: const TextStyle(
              fontSize: TEXT_SIZE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({
    Key? key,
  }) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<String?> _squares = List.generate(9, (index) => null);
  bool _xIsNext = true;

  void handleClick(int i) {
    final squares = _squares.sublist(0);
    if (calculateWinner(squares) != null || squares[i] != null) {
      return;
    }

    squares[i] = _xIsNext ? 'X' : 'O';
    setState(() {
      _squares = squares;
      _xIsNext = !_xIsNext;
    });
  }

  @override
  Widget build(BuildContext context) {
    final winner = calculateWinner(_squares);
    String status;
    if (winner == ' ') {
      status = 'Draw!';
    } else if (winner != null) {
      status = 'Winner: $winner';
    } else {
      status = 'Next player: ${_xIsNext ? 'X' : 'O'}';
    }

    return Column(
      children: [
        Text(status),
        SizedBox(
          height: 34 * 3,
          width: 34 * 3,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(
              9,
              (int i) => Square(
                onTap: () => handleClick(i),
                value: _squares[i],
              ),
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
        appBar: AppBar(
          title: const Text('TicTacToe'),
          backgroundColor: const Color.fromARGB(255, 64, 86, 194),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 162, 163),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Board(),
              Padding(
                padding: EdgeInsets.only(left: 20),
                // child: Column(children: const []),
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
    // 横
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    // 縦
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    // 斜め
    [0, 4, 8], [2, 4, 6],
  ];

  for (final positions  in lines) {
    final cells = {
      squares[positions[0]],
      squares[positions[1]],
      squares[positions[2]]
    };
    if (cells.length == 1 && cells.first != null) {
      return cells.first;
    }
  }

  for (final v in squares) {
    if (v == null) {
      return null;
    }
  }
  return ' '; // draw
}
