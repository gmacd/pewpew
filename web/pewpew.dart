import 'dart:html';
import 'package:game_loop/game_loop_html.dart';


TextureManager textures = new TextureManager();
List<Entity> entities = new List<Entity>();


main() {
  var gameContainer = querySelector("#gameContainer");
  CanvasElement canvas = new CanvasElement(width: 640, height: 480);

  CanvasRenderingContext2D ctx = canvas.context2D;
  ctx.imageSmoothingEnabled = false;
  gameContainer.append(canvas);

  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  UpdateContext updateContext = new UpdateContext(gameLoop, canvas);
  RenderContext renderContext = new RenderContext(gameLoop, ctx, canvas);
  gameLoop.onUpdate = (gameLoop) => update(updateContext);
  gameLoop.onRender = (gameLoop) => render(renderContext);

  entities.add(new Ship(100, 100));

  gameLoop.start();
}

update(UpdateContext u) {
  entities.forEach((e) => e.update(u));
}

render(RenderContext r) {
  r.ctx.setFillColorRgb(0, 0, 0, 255);
  r.ctx.fillRect(0, 0, r.w, r.h);
  entities.forEach((e) => e.render(r));
}


class UpdateContext {
  GameLoopHtml gameLoop;
  CanvasElement _canvas;

  UpdateContext(this.gameLoop, this._canvas);

  int get w => _canvas.width;
  int get h => _canvas.height;
}

class RenderContext {
  GameLoopHtml gameLoop;
  CanvasRenderingContext2D ctx;
  CanvasElement _canvas;

  RenderContext(this.gameLoop, this.ctx, this._canvas);

  int get w => _canvas.width;
  int get h => _canvas.height;
}


class Texture {
  ImageElement _tex;
  int _tx, _ty, _tw, _th;
  Texture(this._tex, this._tx, this._ty, this._tw, this._th);

  draw(RenderContext r, int x, int y) {
    r.ctx.drawImageScaledFromSource(
        _tex, _tx, _ty, _tw, _tw,
        x, y, _tw, _th);
  }
}

class TextureManager {
  Map<String, ImageElement> _images = new Map<String, ImageElement>();
  Map<Symbol, Texture> _textures = new Map<Symbol, Texture>();

  Texture add(Symbol id, String filename, int x, int y, int w, int h) {
    ImageElement img = _images.putIfAbsent(filename, () => new ImageElement(src: filename));
    return _textures[id] = new Texture(img, x, y, w, h);
  }

  // TODO Callback when all are complete

  Texture operator[](Symbol id) => _textures[id];
}


class Entity {
  update(UpdateContext u) {}
  render(RenderContext r) {}
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
