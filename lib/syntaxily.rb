$LOAD_PATH << File.dirname(__FILE__) + '/core_ext'
$LOAD_PATH << File.dirname(__FILE__) + '/syntaxily'
$LOAD_PATH << File.dirname(__FILE__) + '/../vendor'

require 'rubygems'
require 'nokogiri'
require 'albino'
require 'string'

module Syntaxily
  def self.parse(text)
    doc = Nokogiri::HTML.parse(text)
    doc.search('pre.code').each do |node|
      lexer = node['rel'].to_sym
      lexed = node.text.syntaxify(lexer)
      node.replace Nokogiri::HTML.parse(lexed)
    end
    doc.to_html
  end
end