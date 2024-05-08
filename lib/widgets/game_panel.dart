// ignore_for_file: avoid_print

import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:circule_game/models/figure.dart';
import 'package:circule_game/widgets/figure_view.dart';
import 'package:flutter/material.dart';

const int heightDimension = 6;
const int widthDimension = 4;

double gridWidth = 90;
double gridHeight = 90;

class GamePanel extends StatefulWidget {
  const GamePanel({super.key});

  @override
  State<GamePanel> createState() => _GamePanelState();
}

enum Move { up, right, down, left }

class _GamePanelState extends State<GamePanel> with TickerProviderStateMixin {
  Move currentMovement = Move.right;
  late final AnimationController controllerMovements;
  late Animation<double> animationMovements;

  late List<({FigureInfo figure, int availableMovement})> availableSpace = [];

  int serialId = 0;
  late List<FigureInfo> lastState;
  List<FigureInfo> figuresPossitions = [
    FigureInfo(
      id: 0,
      rowIndex: 4,
      columnIndex: 3,
      steps: 0,
      lvl: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    lastState = List.from(figuresPossitions);
    controllerMovements = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    animationMovements =
        Tween<double>(begin: 0, end: 1).animate(controllerMovements)
          ..addListener(() {
            setState(() {
              if (animationMovements.value == 1) {
                for (var figure in figuresPossitions) {
                  switch (currentMovement) {
                    case Move.up:
                      figure.rowIndex -= figure.steps;
                    case Move.right:
                      figure.columnIndex += figure.steps;
                    case Move.down:
                      figure.rowIndex += figure.steps;
                    case Move.left:
                      figure.columnIndex -= figure.steps;
                  }
                }
                // Combined
                List<FigureInfo> combinedFigures = [];
                List<int> indexDuplicated = [];
                for (int i = 0; i < figuresPossitions.length; i++) {
                  bool isCombined = false;
                  for (int j = i + 1; j < figuresPossitions.length; j++) {
                    if ((figuresPossitions[i].rowIndex ==
                            figuresPossitions[j].rowIndex) &&
                        (figuresPossitions[i].columnIndex ==
                            figuresPossitions[j].columnIndex) &&
                        !(indexDuplicated.contains(j))) {
                      isCombined = true;
                      indexDuplicated.add(j);
                      if (figuresPossitions[i].id > figuresPossitions[j].id) {
                        combinedFigures.add(figuresPossitions[i]
                          ..lvl = ++figuresPossitions[i].lvl
                          ..id = ++serialId
                          ..levelUp = true);
                      } else {
                        combinedFigures.add(figuresPossitions[j]
                          ..lvl = ++figuresPossitions[j].lvl
                          ..id = ++serialId
                          ..levelUp = true);
                      }

                      break;
                    }
                  }
                  if (!isCombined && !indexDuplicated.contains(i)) {
                    combinedFigures.add(figuresPossitions[i]);
                  }
                }

                figuresPossitions = combinedFigures
                  ..sort((a, b) => a.id.compareTo(b.id));

                _addNewFigure();
              }
            });
          });
  }

  @override
  void dispose() {
    controllerMovements.dispose();
    super.dispose();
  }

  void _addNewFigure() async {
    bool notEqual = false;

    if (lastState.length == figuresPossitions.length) {
      for (int i = 0; i < lastState.length; i++) {
        if (lastState[i] != figuresPossitions[i]) {
          notEqual = true;
          break;
        }
      }
    }

    if (!notEqual) {
      // Adding a new figure in the canvas
      ({int rowIndex, int columnIndex}) poss = _getNewPoss();
      figuresPossitions.add(FigureInfo(
        id: ++serialId,
        rowIndex: poss.rowIndex,
        columnIndex: poss.columnIndex,
        steps: 0,
        lvl: 1,
      ));
      final player = AudioPlayer();
      player
          .play(AssetSource('audio/beep.mp3'))
          .then((value) => print('Player.play'));
    }

    lastState = List.from(figuresPossitions);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double paddingTop = 50;
      double paddingBottom = 50;

      gridWidth = (constrains.maxWidth - (50)) ~/ widthDimension + 0.0;
      gridHeight = (constrains.maxHeight - (paddingTop + paddingBottom)) ~/
              heightDimension +
          0.0;

      // print('gridWidth: $gridWidth');
      // print('gridHeight: $gridHeight');

      return Container(
        color: Colors.grey,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  // Swiping in up direction.
                  if (details.velocity.pixelsPerSecond.dy > 0) {
                    if (!_isTransicion()) {
                      print('Down!!!');
                      _calculateSpace(Move.down);
                      currentMovement = Move.down;
                      controllerMovements
                        ..reset()
                        ..forward();
                    }
                  }
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    print('Up!!!');
                    if (!_isTransicion()) {
                      _calculateSpace(Move.up);
                      currentMovement = Move.up;
                      controllerMovements
                        ..reset()
                        ..forward();
                    }
                  }
                },
                onHorizontalDragEnd: (details) {
                  // Swiping in right direction.
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    print('Right!!!');
                    if (!_isTransicion()) {
                      _calculateSpace(Move.right);
                      currentMovement = Move.right;
                      controllerMovements
                        ..reset()
                        ..forward();
                    }
                  }
                  // Swiping in left direction.
                  if (details.velocity.pixelsPerSecond.dx < 0) {
                    print('Left!!!');
                    if (!_isTransicion()) {
                      _calculateSpace(Move.left);
                      currentMovement = Move.left;
                      controllerMovements
                        ..reset()
                        ..forward();
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: SizedBox(
                        width: widthDimension * gridWidth,
                        height: heightDimension * gridHeight,
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(30, 33, 35, 1),
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            Stack(
                              children: figuresPossitions
                                  .map((FigureInfo figure) =>
                                      _buildFigureWithPossition(figure))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const FooterPanel()
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Positioned _buildFigureWithPossition(FigureInfo figure) {
    print(
        'Figure: ${figure.id}, poss( ${figure.rowIndex} , ${figure.columnIndex} ), steps: ${figure.steps},  value: ${animationMovements.value} )');
    print('gridHeight: $gridHeight -- gridWidth: $gridWidth');
    return Positioned(
      top: (currentMovement == Move.down)
          ? gridHeight *
              (figure.rowIndex +
                  figure.steps *
                      (animationMovements.value == 1
                          ? 0
                          : animationMovements.value))
          : (currentMovement == Move.up)
              ? gridHeight *
                  (figure.rowIndex -
                      figure.steps *
                          (animationMovements.value == 1
                              ? 0
                              : animationMovements.value))
              : figure.rowIndex * gridHeight,
      left: currentMovement == Move.right
          ? gridWidth *
              (figure.columnIndex +
                  figure.steps *
                      (animationMovements.value == 1
                          ? 0
                          : animationMovements.value))
          : currentMovement == Move.left
              ? gridWidth *
                  (figure.columnIndex -
                      figure.steps *
                          (animationMovements.value == 1
                              ? 0
                              : animationMovements.value))
              : figure.columnIndex * gridWidth,
      child: FigureView(
        key: ValueKey(figure.id),
        figureInfo: figure,
        maxWidth: gridWidth,
        maxHeight: gridHeight,
      ),
    );
  }

  bool _isTransicion() =>
      (animationMovements.value > 0 && animationMovements.value < 1);

  void _calculateSpace(Move move) {
    List<({FigureInfo figure, int availableMovement})> available = [];
    _cleanLevelUp();
    switch (move) {
      case Move.up:
        available = _calculateAvailabilityTop();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
      case Move.right:
        available = _calculateAvailabilityRight();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.down:
        available = _calculateAvailabilityDown();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);

      case Move.left:
        available = _calculateAvailabilityLeft();
        availableSpace = available;
        _refreshFigureWithNewAvailability(available);
    }
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityTop() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int column = 0; column < widthDimension; column++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInColumn = [];

      bool combined = false;
      for (int row = 0; row < heightDimension; row++) {
        if (arrayIndexPoss[row]![column] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInColumn.isNotEmpty) &&
            (availableInColumn.last.figure.id !=
                arrayIndexPoss[row]![column]!.id) &&
            (availableInColumn.last.figure.lvl ==
                arrayIndexPoss[row]![column]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInColumn.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInColumn.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInColumn];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityDown() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int column = 0; column < widthDimension; column++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInColumn = [];

      bool combined = false;
      for (int row = heightDimension - 1; row >= 0; row--) {
        if (arrayIndexPoss[row]![column] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInColumn.isNotEmpty) &&
            (availableInColumn.last.figure.id !=
                arrayIndexPoss[row]![column]!.id) &&
            (availableInColumn.last.figure.lvl ==
                arrayIndexPoss[row]![column]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInColumn.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        } else {
          print(
              'Figure: ${arrayIndexPoss[row]![column]!.id} -> available: $availableMovement');

          combined = false;
          availableInColumn.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInColumn];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityRight() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int row = 0; row < heightDimension; row++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInRow = [];

      bool combined = false;
      for (int column = widthDimension - 1; column >= 0; column--) {
        if (arrayIndexPoss[row]![column] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInRow.isNotEmpty) &&
            (availableInRow.last.figure.id !=
                arrayIndexPoss[row]![column]!.id) &&
            (availableInRow.last.figure.lvl ==
                arrayIndexPoss[row]![column]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInRow.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInRow.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInRow];
    }

    return available;
  }

  List<({FigureInfo figure, int availableMovement})>
      _calculateAvailabilityLeft() {
    // Calculate and represent the current positions of figures in a two-dimensional array
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({FigureInfo figure, int availableMovement})> available = [];

    for (int row = 0; row < heightDimension; row++) {
      int availableMovement = 0;
      List<({FigureInfo figure, int availableMovement})> availableInRow = [];

      bool combined = false;
      for (int column = 0; column < widthDimension; column++) {
        if (arrayIndexPoss[row]![column] == null) {
          availableMovement++;
        } else if ((!combined) &&
            (availableInRow.isNotEmpty) &&
            (availableInRow.last.figure.id !=
                arrayIndexPoss[row]![column]!.id) &&
            (availableInRow.last.figure.lvl ==
                arrayIndexPoss[row]![column]!.lvl)) {
          availableMovement++;
          combined = true;

          availableInRow.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        } else {
          combined = false;
          availableInRow.add((
            figure: arrayIndexPoss[row]![column]!,
            availableMovement: availableMovement
          ));
        }
      }

      available = [...available, ...availableInRow];
    }

    return available;
  }

  void _refreshFigureWithNewAvailability(
      List<({FigureInfo figure, int availableMovement})> available) {
    List<FigureInfo> temp = [];

    for (({FigureInfo figure, int availableMovement}) aval in available) {
      FigureInfo figure =
          figuresPossitions.firstWhere((e) => e.id == aval.figure.id);
      temp.add(figure..steps = aval.availableMovement);
    }

    figuresPossitions = temp..sort(((a, b) => a.id.compareTo(b.id)));
  }

  Map<int, Map<int, FigureInfo?>> _initializaedArrayWithCurrentsPossitions() {
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss = {};

    int externalDimension = heightDimension;
    int internalDimension = widthDimension;

    for (int i = 0; i < externalDimension; i++) {
      // Initialize de array in -1 values.
      arrayIndexPoss[i] = {};
      for (int j = 0; j < internalDimension; j++) {
        arrayIndexPoss[i]![j] = null;
      }
    }

    for (int i = 0; i < figuresPossitions.length; i++) {
      int indexRow = figuresPossitions[i].rowIndex;
      int indexColumn = figuresPossitions[i].columnIndex;

      arrayIndexPoss[indexRow]![indexColumn] = figuresPossitions[i];
    }

    return arrayIndexPoss;
  }

  ({int rowIndex, int columnIndex}) _getNewPoss() {
    Map<int, Map<int, FigureInfo?>> arrayIndexPoss =
        _initializaedArrayWithCurrentsPossitions();
    List<({int rowIndex, int columnIndex})> freePosition = [];

    for (int i = 0; i < heightDimension; i++) {
      for (int j = 0; j < widthDimension; j++) {
        if (arrayIndexPoss[i]![j] == null) {
          freePosition.add((rowIndex: i, columnIndex: j));
        }
      }
    }
    int index = Random().nextInt(freePosition.length);
    return (
      rowIndex: freePosition[index].rowIndex,
      columnIndex: freePosition[index].columnIndex
    );
  }

  void _cleanLevelUp() {
    for (var element in figuresPossitions) {
      element.levelUp = false;
    }
  }
}

class FooterPanel extends StatelessWidget {
  const FooterPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Text(
        'Join the same polygons until you get the circle',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
