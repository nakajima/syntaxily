require File.dirname(__FILE__) + '/spec_helper'

describe Syntaxily do
  include Elementor
  
  attr_reader :result
  
  before(:each) do
    @result = elements(:from => :render) do |tag|
      tag.headers "h1"
      tag.keywords ".highlight pre span.k"
      tag.symbols ".highlight pre span.ss"
    end
  end
  
  describe "available lexers" do
    it "finds available lexers from pygments" do
      Syntaxily.available_lexers.should include('ruby')
      Syntaxily.available_lexers.should_not include('foobar')
    end
  end
  
  describe "regular string helper" do
    def render
      "def foo; :bar end".syntaxify(:ruby)
    end
    
    it "adds syntaxify helper to string" do
      result.should have(2).keywords
      result.should have(1).keywords.with_text('def')
      result.should have(1).keywords.with_text('end')
      result.should have(1).symbols.with_text(':bar')
    end
    
    it "raises LexerNotFound when lexer doesn't exist" do
      proc {
        "def foo; :bar end".syntaxify(:foobar)
      }.should raise_error(Syntaxily::LexerNotFound)
    end
  end
  
  describe "rendering from markup" do
    def render
      Syntaxily.parse <<-TEXT
        <div>
          <h1>This is normal</h1>
          <pre class="code" rel="ruby">def foo; :bar end</pre>
          <h1>Good bye</h1>
        </div>
      TEXT
    end
    
    it "retains old markup" do
      result.should have(2).headers
    end
    
    it "does not include a bunch of dtd crap" do
      result.doc.at('html').should be_nil
      result.doc.at('body').should be_nil
    end
    
    it "syntax highlights within pre tag" do
      result.should have(2).keywords
      result.should have(1).keywords.with_text('def')
      result.should have(1).keywords.with_text('end')
      result.should have(1).symbols.with_text(':bar')
    end
    
    it "rescues LexerNotFound errors" do
      proc {
        string = %(<pre class="code" rel="foobar">Something</pre>)
        Syntaxily.parse(string)
      }.should_not raise_error
    end
  end
end
