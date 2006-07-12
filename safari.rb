require 'safari/scripter.rb'
require 'watir/exceptions'

module Watir
  include Watir::Exception

  module Elements
    class Element
      def initialize(scripter, how, what)
        @scripter = scripter
        @how = how
        @what = what
      end
    end
    
    class Button < Element
      def initialize(scripter, how, what)
        super(scripter, how, what)
      end      

      def click
        @scripter.click_button(@what);
      end
    end
    
    class Link < Element
      def initialize(scripter, how, what)
        super(scripter, how, what)
      end
      
      def click
        case @how
          when :text:
            @scripter.click_link_with_text(@what)
          when :url:
            @scripter.click_link_with_url(@what)
          end
      end
    end
    
    class TextField < Element
      def initialize(scripter, how, what)
        super(scripter, how, what)
      end      
      
      def set(value)
        @scripter.highlight(@what) do |scripter|
          scripter.clear_text_input(@what)
          for i in 0 .. value.length-1
            scripter.append_text_input(@what, value[i, 1]);
          end
        end
      end
    end
  end
  
  class Safari
    include Elements

    attr_reader :scripter

    # Create a new Safari Window, starting at the specified url.
    # If no url is given, start empty.
    def self.start(url=nil)
      safari = new
      safari.goto(url) if url
      safari
    end
    
    def initialize
      @scripter = AppleScripter.new
    end
    
    def goto(url)
      scripter.navigate_to(url)
    end

    def text_field(how, what)
      TextField.new(scripter, how, what)
    end
    
    def button(how, what)
      Button.new(scripter, how, what)
    end

    def link(how, what)
      Link.new(scripter, how, what)
    end 
    
    def contains_text(what)
      text = scripter.document_text
      case what
        when Regexp:
          text =~ what
        when String:
          text.index(what)
        else
          raise MissingWayOfFindingObjectException
        end
    end
  end # class Safari
end