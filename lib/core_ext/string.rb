class String
  def syntaxify(lexer)
    unless Syntaxily.available_lexers.include?(lexer.to_s)
      raise Syntaxily::LexerNotFound.new("No `#{lexer}` lexer found.")
    end
    
    Albino.new(self, lexer).colorize
  end
end