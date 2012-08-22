(function() {

  window.Cipher || (window.Cipher = {});

  Cipher.Block = (function() {

    Block.prototype.className = 'Block';

    function Block(parent) {
      this.list = [];
    }

    Block.prototype.first = function() {
      if (this.list[0]) {
        return this.list[0].first();
      } else {
        return null;
      }
    };

    Block.prototype.appendValue = function(object) {
      if (this.list.length === 1) {
        return this.list[0].append(object);
      } else {
        return this.appendLine(new Cipher.Block.Line([object]));
      }
    };

    Block.prototype.appendLine = function(line) {
      return this.list.push(line);
    };

    return Block;

  })();

  Cipher.Block.Line = (function() {

    Line.prototype.className = 'Line';

    function Line(objects) {
      this.values = objects;
    }

    Line.prototype.first = function() {
      return this.values[0];
    };

    Line.prototype.append = function(object) {
      return this.values.push(object);
    };

    return Line;

  })();

}).call(this);
