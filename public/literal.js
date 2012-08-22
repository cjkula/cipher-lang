(function() {

  window.Cipher || (window.Cipher = {});

  Cipher.Literal = (function() {

    function Literal() {}

    Literal.matcher = function() {
      return "" + (Cipher.String.matcher()) + "|" + (Cipher.Numeric.matcher());
    };

    return Literal;

  })();

}).call(this);
