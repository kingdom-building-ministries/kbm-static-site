require 'shellwords'
class Player < Liquid::Tag
  def initialize(tag_name, input, tokens)
     super 
     params = Shellwords.shellwords input
     @title = params[0]
     @url = params[1]
  end

  def render(context)
  	"This is a player named #{@title} and its url is #{@url}"
  end
end

Liquid::Template.register_tag('player', Player)