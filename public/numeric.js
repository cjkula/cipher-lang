(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  window.Cipher || (window.Cipher = {});

  Cipher.Numeric = (function(_super) {

    __extends(Numeric, _super);

    function Numeric(value) {
      this.value = value;
    }

    Numeric.matcher = function() {
      return '-?\\d*\\.?\\d+';
    };

    return Numeric;

  })(Cipher.Object);

}).call(this);
