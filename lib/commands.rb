module Rubino
  class Commands
    attr_accessor :message
    def initialize(irc=nil, config=nil)
      @irc = irc
      @config = config
      @commands = Hash.new(0)
      set_defaults
      set_custom
      handle(@irc.last) if @irc
    end

    def inspect
      "{" + names.join("=>..., ") + "}"
    end

    def names
      @commands.map {|k,v| k.downcase.gsub('_', ' ') }
    end

    def handle(message)
      words = message.words

      return unless words[0] =~ /^#{@irc.self.nick}.?$/

      i = words.length-1
      command = words[1..i].join('_').upcase
      until @commands.include?(command) || i < 1
        i -= 1
        command = words[1..i].join('_').upcase
      end

      if @commands.include?(command)
        @irc.args = words[(i+1)..-1]
        block = @commands[command]
        begin
          @irc.instance_eval &block
        rescue => e
          puts "----------------------------------------------------"
          puts "Error running command \"#{command}\", details below:"
          puts e
          puts "----------------------------------------------------"
          @irc.reply_highlight "Error running command \"#{command}\"."
        end
      end   # if @commands.respond_to?(command)
    end

    def command(name, &block)
      @commands[name.to_s.upcase] = block
    end

    def set_defaults
      command :commands do
        reply_highlight Commands.new.names.join(', ')
      end
    
      command :about do
        reply "Information about the rubino IRC bot is at http://duckinator.net/rubino"
      end

      command :source do
        reply "I'm written in ruby by duckinator. You can find my source at http://github.com/RockerMONO/rubino"
      end
    end # set_defaults

    def set_custom
    end
  end   # class Commands
end     # module Rubino
