library pewpewgame;

import 'dart:html';
import 'dart:math';
import 'package:game_loop/game_loop_html.dart';
import 'package:pewpew/gamewrapper.dart';


const int sceneLeft = 10;
const int sceneRight = 500;

const int numRows = 5;
const int numCols = 11;


List<Invader> invaders = new List<Invader>();

main() {
  initGameWrapper(querySelector("#gameContainer"), init);
}

init() {
  entities.add(new BulletPool());
  entities.add(new Ship(100, 250));

  int invaderStartX = sceneLeft + 10;
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

  int _delta = 2;

  BulletPool _bulletPool;

  Ship(this._x, this._y) {
    _tex = textures.add(#player, "sprites.png", 16, 0, 16, 16);
    _bulletPool = entities.getOfType(BulletPool).single;
  }

  update(UpdateContext u) {
    if (u.gameLoop.keyboard.isDown(Keyboard.LEFT)) {
      _x = max(sceneLeft, _x - _delta);
    }
    else if (u.gameLoop.keyboard.isDown(Keyboard.RIGHT)) {
      _x = min(sceneRight, _x + _delta);
    }

    if (u.gameLoop.keyboard.released(Keyboard.SPACE)) {
      const int bulletInitialOffsetY = -6;
      _bulletPool.fire(_x, _y + bulletInitialOffsetY, -1);
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

  render(RenderContext r) {
    _tex.draw(r, x, y);
  }
}

class InvaderController extends Entity {
  List<Invader> _invaders;
  InvaderController(this._invaders);

  int _updateIdx = 0;
  int delta = 2;

  update(UpdateContext u) {
    int firstInvader = 0;
    int lastInvader = _invaders.length;

    int minX = sceneRight;
    int maxX = sceneLeft;
    for (int i = firstInvader; i < lastInvader; i++) {
      Invader invader = _invaders[i];
      invader.x += delta;
      minX = min(minX, invader.x);
      maxX = max(maxX, invader.x + 16);
    }

    if ((minX <= sceneLeft) || (maxX >= sceneRight))
      delta *= -1;

    _updateIdx++;
  }
}

class Bullet {
  bool _active = false;
  int x, y;
  int deltaY;

  activate(int x, int y, int deltaY) {
    this.x = x;
    this.y = y;
    this.deltaY = deltaY;
    _active = true;
  }

  deactivate() {
    _active = false;
  }

  bool get active => _active;
}

class BulletPool extends Entity {
  List<Bullet> _bullets;
  int _lastUsed = -1;

  Texture _bulletTex;

  BulletPool() {
    _bulletTex = textures.add(#bullet, "sprites.png", 32, 0, 16, 16);
    _bullets = new List<Bullet>.generate(1000, (i) => new Bullet());
  }

  update(UpdateContext u) {
    for (Bullet b in _bullets.where((b) => b.active)) {
      b.y += b.deltaY;
      if (b.y <= 0)
        b.deactivate();
    }
  }

  render(RenderContext r) {
    for (Bullet b in _bullets.where((b) => b.active)) {
      _bulletTex.draw(r, b.x, b.y);
    }
  }

  fire(int x, int y, int deltaY) {
    _lastUsed++;
    if (_lastUsed >= _bullets.length)
      _lastUsed = 0;

    _bullets[_lastUsed].activate(x, y, deltaY);
  }
}
