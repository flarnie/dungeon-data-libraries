require "./monster_manual"

#stands for Dungeon Text Adventure
module DTA 
class Dungeon
  attr_accessor :player, :rooms
  def initialize()
    #test options
    options = {name:"Player One",race:"human", type:"Humaniod", color:"your skin color", 
      eyes:"your eye color", hairstyle:"your hairstyle", gender:"female",
     attack:{weapon:"with fists", points:10}, hitpoints:20, alignment:["Neutral", "Neutral"],
     description:"A lone adventurer in the world."}
    @player = Player.new(options)
    @rooms = []
  end 

  def add_room(reference, name, description, connections)
    puts "Creating room: #{reference}, #{name}- #{description}"
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "You go #{direction}."
    @player.location = find_room_in_direction(direction)
    show_current_description
  end

  def makeCharacter(playable, options=false)
    character = Character.new(playable, options)
  end

  class Character
    attr_accessor :name, :playable_race, :gender, :type, :color, :eyes, :hairstyle, :attack, :hitpoints, :alignment, :quirks, :personality
    #The character object stores data to generate a description of the character
    def initialize(playable_race, options=false)
      if options
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
          puts "assigned this.#{key} = #{value}"
        end
      end
      @playable_race = playable_race
      @race ||= MonsterManual::pick_a("race", {playable:@playable_race})
      @gender ||= ["male", "female"].sample
      @pronoun = {"male"=>"he", "female"=>"she"}[@gender]
      @name ||= MonsterManual.pick_a("name", {race:@race, gender:@gender})
      @type ||= MonsterManual.get_the("type", @race) + MonsterManual.get_the("subtype", @race)
      puts @type
      @color ||= MonsterManual.pick_a("color", {playable:@playable_race, race:@race})
      @eyes ||= MonsterManual.pick_a("color", {playable:@playable_race, race:@race})
      if @playable_race || (@type.length > 0 && @type.include?("Humanoid"))
        @hairstyle ||= MonsterManual.pick_a("hairstyle", {race:@race})
        @trait ||= false
      else
        @hairstyle ||= false
        @trait ||= MonsterManual.pick_a("trait", {race:@race, subtype:(MonsterManual.get_the("subtype", @race))})
      end
      @attack ||= MonsterManual.pick_a("attack")
      @hitpoints ||= MonsterManual.get_the("hit_pts", @race)
      @alignment ||= MonsterManual.get_the("alignment", @race)
      @quirks = MonsterManual.pick_a("quirks",{total:2})
      @personality = MonsterManual.pick_a("personality",{total:3, alignment:@alignment})
      @race_desc = MonsterManual.get_the("desc", @race)
      @desc = gen_desc
    end

    def gen_desc()
      desc = "#{@name} is a #{@race} with #{@color} skin and #{@eyes} eyes.\n"
      desc += @hairstyle ? "#{@pronoun.capitalize} has #{@hairstyle}." : "#{@pronoun.capitalize} has #{@trait}."
      if @quirks
        desc += "#{@pronoun.capitalize} #{@quirks[0]} and #{@quirks[1]}.\n"
      end
      desc += "#{@name} fights with #{@attack[:weapon]}.\n"
      if @personality 
        desc += "#{@pronoun.capitalize} is #{@personality[0]}, #{@personality[2]}, and #{@personality[1]}."
      end
      puts desc
      desc
    end
  end#end character class

  class Player < Character
    attr_accessor :name, :playable_race, :desc, :location
    #The character object stores data to generate a description of the character
    def initialize(options)
      @name = options[:name]
      @gender = options[:gender]
      @pronoun = {"male"=>"he", "female"=>"she"}[@gender]
      @race = options[:race]
      @type = options[:type]
      @color = options[:color]
      @eyes = options[:eyes]
      @hairstyle = options[:hairstyle]
      @trait = false
      @attack = options[:attack]
      @hitpoints = options[:hitpoints] #Make this a standardized starting amount?
      @alignment = options[:alignment]
      @quirks = nil
      @personality = nil
      @desc = gen_desc+"\n"+options[:description]
    end
  end#end player class

  class Room
  attr_accessor :reference, :name, :description, :connections
    def initialize(reference, name, desciption, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      "#{@name}\n\nYou are in #{@description}"
    end
  end#end room class

end#end Dungeon outer class
end#end module


#Note: if picking hair color dwarf, must be black, gray, or brown.

#Testing
#Create main dungeon object
#my_dungeon = Dungeon.new()

#Add rooms to the dungeon
#my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west=>:smallcave})
#my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east=>:largecave})

#my_dungeon.start(:largecave)
    