import 'dart:math';

import 'package:circule_game/models/figure.dart';
import 'package:circule_game/navigation_service.dart';
import 'package:circule_game/pages/game_page.dart';
import 'package:circule_game/pages/home_page.dart';
import 'package:circule_game/widgets/figure_view.dart';
import 'package:circule_game/widgets/others/clip_shadow_path.dart';
import 'package:flutter/material.dart';

class ScorePanel extends StatefulWidget {
  const ScorePanel({
    super.key,
  });

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return ClipShadowPath(
          clipper: HeaderClip(),
          shadow: const BoxShadow(color: Colors.blue, blurRadius: 5),
          child: AnimatedContainer(
            padding: const EdgeInsets.only(bottom: 30, top: 90),
            height: isExpanded ? constraints.maxHeight - 28 : 280,
            width: double.infinity,
            color: Colors.blueGrey,
            duration: const Duration(milliseconds: 400),
            child: Stack(
              children: [
                const FloatingFigures(),
                Row(
                  children: [
                    Menu(
                      isExpandedPanel: isExpanded,
                      backHome: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 40),
                          alignment: Alignment.center,
                          child: Container(
                            width: 1,
                            height: constraints.maxHeight * 0.8,
                            color: const Color.fromRGBO(50, 53, 55, 1),
                          ),
                        ),
                        Expanded(
                            child: InformationBar(
                                start: start, isExpandedPanel: isExpanded))
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void backHome() {
    // setState(() {
    //   isExpanded = true;
    // });
  }

  void start() {
    // setState(() {
    //   isExpanded = false;
    // });
  }
}

class InformationBar extends StatelessWidget {
  const InformationBar({
    super.key,
    required this.start,
    required this.isExpandedPanel,
  });

  final bool isExpandedPanel;
  final Function start;

  @override
  Widget build(BuildContext context) {
    return _buildContracted(context);
  }

  Widget _buildContracted(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      alignment: isExpandedPanel ? Alignment.center : Alignment.topLeft,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Polygon',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34),
          ),
          SizedBox(
            height: 10,
          ),
          // Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.isExpandedPanel,
    required this.backHome,
  });

  final bool isExpandedPanel;
  final Function backHome;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.red,
      height: double.infinity,
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                print('BACK!');
                widget.backHome();
              },
              icon: const Icon(
                Icons.home,
                color: Colors.white,
                size: 32,
              )),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      "Game Pause",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                    content: SizedBox(
                      height: 280,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 200,
                              height: 60,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green,
                              ),
                              child: const Text(
                                "Continues",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                NavigationService.navigatorKey.currentContext ??
                                    context,
                                MaterialPageRoute(
                                    builder: (context) => const GamePage()),
                              );
                            },
                            child: Container(
                              width: 200,
                              height: 60,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.orangeAccent,
                              ),
                              child: const Text(
                                "Replay",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                NavigationService.navigatorKey.currentContext ??
                                    context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            child: Container(
                              width: 200,
                              height: 60,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.redAccent,
                              ),
                              child: const Text(
                                "Exits",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.pause,
                color: Colors.white,
                size: 32,
              )),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class HeaderClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    double heightDesign = 15.0;

    path.lineTo(0, h);
    path.lineTo(w / 4, h - heightDesign);
    path.lineTo(w / 2, h);
    path.lineTo(w * 3 / 4, h - heightDesign);
    path.lineTo(w, h);
    path.lineTo(w, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FloatingFigures extends StatefulWidget {
  const FloatingFigures({super.key});

  @override
  State<FloatingFigures> createState() => _FloatingFiguresState();
}

class _FloatingFiguresState extends State<FloatingFigures>
    with TickerProviderStateMixin {
  late final AnimationController _controllerMoving;
  late Animation<double> animationMovements;

  @override
  void initState() {
    super.initState();

    _controllerMoving =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();
    animationMovements =
        Tween<double>(begin: 0, end: 1).animate(_controllerMoving)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controllerMoving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<FigureInfo> figures = [
      FigureInfo(id: 0, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 5),
      FigureInfo(id: 1, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 2),
      FigureInfo(id: 2, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 1),
      FigureInfo(id: 3, rowIndex: -1, columnIndex: -1, steps: -1, lvl: 7),
    ];

    return Stack(
      children: [
        Positioned(
          top: -50 * cos(animationMovements.value * 2 * pi),
          right: 30 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[0].id),
            figureInfo: figures[0],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          top: 300 +
              200 * cos(animationMovements.value * 2 * pi) +
              30 * sin(animationMovements.value * 1 * pi),
          left: 150 +
              100 * cos(animationMovements.value * 2 * pi) +
              10 * sin(animationMovements.value * 1 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[1].id),
            figureInfo: figures[1],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          bottom: 350 + -80 * cos(animationMovements.value * 2 * pi),
          left: 200 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[2].id),
            figureInfo: figures[3],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
        Positioned(
          bottom: -10 * cos(animationMovements.value * 2 * pi),
          left: 30 + 20 * sin(animationMovements.value * 2 * pi),
          // left: 200 + -50*sin(animationMovements.value * 2 * pi) ,
          child: FigureView(
            key: ValueKey(figures[2].id),
            figureInfo: figures[2],
            maxWidth: 40,
            maxHeight: 40,
          ),
        ),
      ],
    );
  }
}
