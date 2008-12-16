class String
  def syntaxify(lexer)
    Albino.new(self, lexer).colorize
  end
end