import 'dart:html';
import 'package:game_loop/game_loop_html.dart';


TextureManager textures = new TextureManager();


main() {
  var gameContainer = querySelector("#gameContainer");
  CanvasElement canvas = new CanvasElement(width: 640, height: 480);

  CanvasRenderingContext2D ctx = canvas.context2D;
  ctx.imageSmoothingEnabled = false;
  gameContainer.append(canvas);

  RenderContext renderContext = new RenderContext(ctx, canvas);
  GameLoopHtml gameLoop = new GameLoopHtml(canvas);
  gameLoop.onUpdate = update;
  gameLoop.onRender = (gameLoop) => render(gameLoop, renderContext);

  textures.add(#invader, "sprites.png", 0, 0, 16, 16);
  textures.add(#player, "sprites.png", 16, 0, 16, 16);

  gameLoop.start();
}

update(GameLoopHtml gameLoop) {
}

render(GameLoopHtml gameLoop, RenderContext r) {
  r.ctx.setFillColorRgb(0, 0, 0, 255);
  r.ctx.fillRect(0, 0, r.w, r.h);

  textures[#player].draw(r, 0, 0);
}


class RenderContext {
  CanvasRenderingContext2D ctx;
  CanvasElement _canvas;

  RenderContext(this.ctx, this._canvas);

  int get w => _canvas.width;
  int get h => _canvas.height;
}


class Texture {
  ImageElement _tex;
  int _tx, _ty, _tw, _th;
  Texture(this._tex, this._tx, this._ty, this._tw, this._th);

  draw(RenderContext r, int x, int y) {
    r.ctx.drawImage(_tex, x, y);
  }
}

class TextureManager {
  Map<String, ImageElement> _images = new Map<String, ImageElement>();
  Map<Symbol, Texture> _textures = new Map<Symbol, Texture>();

  add(Symbol id, String filename, int x, int y, int w, int h) {
    ImageElement img = _images.putIfAbsent(filename, () => new ImageElement(src: filename));
    _textures[id] = new Texture(img, x, y, w, h);
  }

  // TODO Callback when all are complete

  Texture operator[](Symbol id) => _textures[id];
}


/*class Ship {
  ImageElement sprite
}

}*/
