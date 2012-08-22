(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  window.Cipher || (window.Cipher = {});

  Cipher.Integer = (function(_super) {

    __extends(Integer, _super);

    function Integer() {
      Integer.__super__.constructor.apply(this, arguments);
    }

    Integer.prototype.className = 'Integer';

    return Integer;

  })(Cipher.Numeric);

}).call(this);
