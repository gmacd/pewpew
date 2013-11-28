library pewpewgame;

import 'dart:html';
import 'dart:math';
import 'package:game_loop/game_loop_html.dart';
import 'package:pewpew/gamewrapper.dart';


const double sceneLeft = 10.0;
const double sceneRight = 400.0;

const int numRows = 5;
const int numCols = 11;


List<Invader> invaders = new List<Invader>();

main() {
  initGameWrapper(querySelector("#gameContainer"), init);
}

init() {
  entities.add(new BulletPool());

  double midX = ((sceneRight - sceneLeft) / 2.0) + sceneLeft;
  entities.add(new Player(midX, 300.0));

  double invaderStartX = sceneLeft + 20;
  double invaderStartY = 40.0;
  double invaderGapX = 30.0;
  double invaderGapY = 35.0;
  for (double y = 0.0; y < numRows; y++) {
    for (double x = 0.0; x < numCols; x++) {
      Invader invader = new Invader(
          invaderStartX + invaderGapX * x,
          invaderStartY + invaderGapY * y);
      invaders.add(invader);
      entities.add(invader);
    }
  }

  entities.add(new InvaderController(invaders));
}


class Player extends Entity {
  Texture _tex;
  double _x, _y;

  double _delta = 2.0;

  BulletPool _bulletPool;
  double _lastShotTime = 0.0;
  double _minRepeatHeldShotInterval = 0.4;
  double _minRepeatSingleShotInterval = 0.1;

  Player(this._x, this._y) {
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

    // Allow rapid single shots or slower repeat shots
    bool repeatShot = u.gameLoop.keyboard.isDown(Keyboard.SPACE)
                      && (u.gameLoop.gameTime > (_lastShotTime + _minRepeatHeldShotInterval));
    bool singleShot = u.gameLoop.keyboard.released(Keyboard.SPACE)
                      && (u.gameLoop.gameTime > (_lastShotTime + _minRepeatSingleShotInterval));
    if (repeatShot || singleShot) {
      const double bulletInitialOffsetY = -6.0;
      _bulletPool.fire(_x, _y + bulletInitialOffsetY, -1.0, Bullet.Player);
      _lastShotTime = u.gameLoop.gameTime;
    }
  }

  render(RenderContext r) {
    _tex.draw(r, _x, _y);
  }
}


class Invader extends Entity {
  Texture _tex;
  double x, y;

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
  double delta = 0.7;

  update(UpdateContext u) {
    int firstInvader = 0;
    int lastInvader = _invaders.length;

    double minX = sceneRight;
    double maxX = sceneLeft;
    for (int i = firstInvader; i < lastInvader; i++) {
      Invader invader = _invaders[i];
      invader.x += delta;
      minX = min(minX, invader.x);
      maxX = max(maxX, invader.x + 16);
    }

    if ((minX <= sceneLeft) || (maxX >= sceneRight))
      delta *= -1.0;

    _updateIdx++;
  }
}


class Bullet {
  bool _active = false;
  double x, y;
  double deltaY;

  static const Unknown = -1;
  static const Player = 0;
  static const Enemy = 1;
  int bulletType = Unknown;

  activate(double x, double y, double deltaY, int bulletType) {
    this.x = x;
    this.y = y;
    this.deltaY = deltaY;
    this.bulletType = bulletType;
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
    _bullets = new List<Bullet>.generate(1000, (_) => new Bullet());
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

  fire(double x, double y, double deltaY, int bulletType) {
    for (int i = 0; i < _bullets.length; i++) {
      _lastUsed++;
      if (_lastUsed >= _bullets.length)
        _lastUsed = 0;

      if (!_bullets[_lastUsed].active) {
        _bullets[_lastUsed].activate(x, y, deltaY, bulletType);
        break;
      }
    }
  }
}
