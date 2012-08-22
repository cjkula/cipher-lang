(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  window.Cipher || (window.Cipher = {});

  Cipher.String = (function(_super) {

    __extends(String, _super);

    function String(value) {
      this.value = value;
    }

    String.prototype.className = 'String';

    String.matcher = function() {
      var dbl, sgl;
      sgl = "'(\\\\'|[^'])*'";
      dbl = '"(\\\\"|[^"])*"';
      return "" + sgl + "|" + dbl;
    };

    return String;

  })(Cipher.Object);

}).call(this);
