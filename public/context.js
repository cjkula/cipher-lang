(function() {

  Cipher.Context = (function() {

    function Context() {
      this._locals = {};
    }

    Context.literalMatcher = function() {
      return Cipher.Literal.matcher();
    };

    Context.prototype.parseLiteral = function(string) {
      var match, remain, rx;
      rx = new RegExp("^(\\s*(" + (Context.literalMatcher()) + "))");
      match = rx.exec(string);
      if (match) {
        remain = string.substring(match[0].length);
        if (remain && remain.trim().length === 0) remain = null;
        return [match[0].trim(), remain];
      } else {
        return [null, string];
      }
    };

    Context.prototype.locals = function() {
      return this._locals;
    };

    Context.prototype.assign = function(key, value) {
      return this._locals[key] = value;
    };

    Context.prototype.retrieve = function(key) {
      return this._locals[key];
    };

    return Context;

  })();

}).call(this);
