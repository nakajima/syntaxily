$LOAD_PATH << File.dirname(__FILE__) + '/core_ext'
$LOAD_PATH << File.dirname(__FILE__) + '/syntaxily'
$LOAD_PATH << File.dirname(__FILE__) + '/../vendor'

require 'rubygems'
require 'nokogiri'
require 'albino'
require 'string'

module Syntaxily
  class LexerNotFound < StandardError; end
  
  def self.parse(text)
    doc = Nokogiri::HTML.parse(text)
    doc.search('pre.code').each do |node|
      lexer = node['rel']
      begin
        lexed = node.text.syntaxify(lexer)
        node.replace Nokogiri::HTML.parse(lexed)
      rescue LexerNotFound
        next
      end
    end
    doc.to_html
  end
  
  def self.available_lexers
    @available_lexers ||= begin
      `pygmentize -L`.split(/\n\n/)[1] \
        .split(/\n/) \
        .select { |line| line =~ /^\*/ } \
        .map { |line| line.gsub(/\* ([^:]+):/, '\1') } \
        .join(', ')
    end
  end
end