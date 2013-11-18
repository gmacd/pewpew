import 'dart:html';
import 'package:game_loop/game_loop_html.dart';

main() {
  final String canvasID = '#gameElement';
  var canvas = querySelector(canvasID);
  var gameLoop = new GameLoopHtml(canvas);
  
  gameLoop.onUpdate = ((gameLoop) {
    print('${gameLoop.frame}: ${gameLoop.gameTime} [dt = ${gameLoop.dt}].');
  });
  
  gameLoop.onRender = ((gameLoop) {
    print('Interpolation factor: ${gameLoop.renderInterpolationFactor}');
  });
  gameLoop.start();
}
