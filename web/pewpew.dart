library pewpewgame;

import 'dart:html';
import 'package:game_loop/game_loop_html.dart';
import 'package:pewpew/gamewrapper.dart';


const int numRows = 5;
const int numCols = 11;

List<Invader> invaders = new List<Invader>();

main() {
  initGameWrapper(querySelector("#gameContainer"), init);
}

init() {
  entities.add(new Ship(100, 100));

  int invaderStartX = 20;
  int invaderStartY = 40;
  int invaderGapX = 30;
  int invaderGapY = 35;
  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numCols; x++) {
      Invader invader = new Invader(
          invaderStartX + invaderGapX * x,
          invaderStartY + invaderGapY * y);
      invaders.add(invader);
      entities.add(invader);
    }
  }

  entities.add(new InvaderController(invaders));
}


class Ship extends Entity {
  Texture _tex;
  int _x, _y;

  Ship(this._x, this._y) {
    _tex = textures.add(#player, "sprites.png", 16, 0, 16, 16);
  }

  update(UpdateContext u) {
    if (u.gameLoop.keyboard.isDown(Keyboard.LEFT)) {
      _x -= 1;
    }
    else if (u.gameLoop.keyboard.isDown(Keyboard.RIGHT)) {
      _x += 1;
    }
  }

  render(RenderContext r) {
    _tex.draw(r, _x, _y);
  }
}


class Invader extends Entity {
  Texture _tex;
  int x, y;

  Invader(this.x, this.y) {
    _tex = textures.add(#invader, "sprites.png", 0, 0, 16, 16);
  }

  update(UpdateContext u) {
  }

  render(RenderContext r) {
    _tex.draw(r, x, y);
  }
}

class InvaderController extends Entity {
  List<Invader> _invaders;
  InvaderController(this._invaders);

  int _updateIdx = 0;

  update(UpdateContext u) {
    int row = _updateIdx % numRows;
    int firstInvader = row * numCols;
    int lastInvader = firstInvader + numCols;
    for (int i = firstInvader; i < lastInvader; i++) {
      _invaders[i].x += 1;
    }

    _updateIdx++;
  }
}