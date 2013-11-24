library pewpewgame;

import 'dart:html';
import 'package:game_loop/game_loop_html.dart';
import 'package:pewpew/gamewrapper.dart';


main() {
  Element gameContainer = querySelector("#gameContainer");
  initGameWrapper(gameContainer, init);
}

init() {
  entities.add(new Ship(100, 100));
  entities.add(new Invader(50, 100));
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
  int _x, _y;

  Invader(this._x, this._y) {
    _tex = textures.add(#invader, "sprites.png", 0, 0, 16, 16);
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
