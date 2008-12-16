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
  end
  
  
  
  describe "rendering from markup" do
    def render
      Syntaxily.parse <<-TEXT
      <h1>This is normal</h1>
      <pre class="code" rel="ruby">def foo; :bar end</pre>
      <h1>Good bye</h1>
      TEXT
    end
    
    it "retains old markup" do
      result.should have(2).headers
    end
    
    it "syntax highlights within pre tag" do
      result.should have(2).keywords
      result.should have(1).keywords.with_text('def')
      result.should have(1).keywords.with_text('end')
      result.should have(1).symbols.with_text(':bar')
    end
  end
end