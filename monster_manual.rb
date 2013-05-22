=begin       
        @race ||= MonsterManual::pick_a("race")
        @gender ||= ["male", "female"].sample
        @pronoun = {"male"=>"he", "female"=>"she"}[@gender]
        @name ||= MonsterManual::pick_a("name", @race, @gender)
        @type ||= MonsterManual::pick_a("type")
        @color ||= MonsterManual::pick_a("color", @playable_race)
        @eyes ||= MonsterManual::pick_a("color")
        @hairstyle ||= MonsterManual::pick_a("hairstyle")
        @attack ||= MonsterManual::pick_a("attack")
        @hitpoints ||= MonsterManual::get_the("hitpoints", @race)
        @alignment ||= MonsterManual::get_the("alignment", @race)
        @quirks = MonsterManual::pick_a("quirks",2)
        @personality = MonsterManual::pick_a("personality",3)
        @desc = gen_desc

=end
require 'yaml'

module MonsterManual
  begin
  CHAR_DATA = YAML.load(File.read('character_data.yml'))
  NAME_DATA =YAML.load(File.read('names_data.yml'))
  MONST_DATA = YAML.load(File.read('monster_data.yml'))
  rescue
    raise "Can't load character and name data"
  end

  def char_data
    CHAR_DATA
  end

  def name_data
    NAME_DATA
  end

  def monst_data
    MONST_DATA
  end

  def name_it(race, gender)
    if race == "half-elf"
      race = ["elf", "human"].sample
    elsif race == "half-orc"
      race = ["orc", "human"].sample
    end
    case race
    when "dwarf"
      name = "#{name_data[:dwarf_first].sample.capitalize} #{name_data[:dwarf_last_1].sample.capitalize}#{name_data[:dwarf_last_2].sample}"
    when "elf"
      elf_mid = (gender == "female") ? name_data[:f_elf_last].sample : name_data[:m_elf_last].sample
      name = "#{name_data[:elf_first].sample.capitalize}#{elf_mid} #{name_data[:fey_plant_names].sample.capitalize}"
    when "gnome"
      first = (gender == "female") ? name_data[:f_gnome_first].sample : name_data[:m_gnome_first].sample
      name = "#{first.capitalize} #{name_data[:gnome_last].sample.capitalize}"
    when "human"
      first = (gender == "female") ? name_data[:f_human_first].sample : name_data[:m_human_first].sample
      name = "#{first.capitalize} #{name_data[:human_last].sample.capitalize}"
    when "halfling"
      first = (gender == "female") ? name_data[:f_halfling_first].sample : name_data[:m_halfling_first].sample
      name = "#{first.capitalize} #{name_data[:halfling_last].sample.capitalize}"
    when "orc"
      name = "#{name_data[:evil_first].sample.capitalize}#{name_data[:evil_last].sample} #{name_data[:gross_names_first].sample.capitalize}#{name_data[:gross_names_last].sample}"
    else
      name = "The Creature"
    end
    name
  end

  def MonsterManual.pick_a(type, options=false)
    puts type
    case type
    when "race"
      return options[:playable] ? char_data[:playable_races].sample : monst_data[rand(monst_data.length)]["name"]
    when "name"
      return name_it(options[:race], options[:gender])
    when "color"
      if options[:race] == "chromatic dragon"
        return ["black", "blue", "green", "red", "white"].sample
      elsif options[:race] == "metallic dragon"
        return ["brass", "bronze", "copper", "gold", "silver"].sample
      else
        return options[:playable] ? char_data[:skin_tones].sample : char_data[:all_colors].sample
      end
    when "hairstyle"
      hair_color = options[:race] == "dwarf" ? ["black", "gray", "brown"].sample : char_data[:all_colors].sample
      return "#{char_data[:hair_lengths].sample} #{char_data[:hair_styles].sample} #{hair_color} hair"
    when "trait"
      trait_pair = char_data[:non_playable_attrs].sample
      trait = "#{trait_pair[0].sample} #{trait_pair[1].sample}"
      if options[:subtype].include?("Reptilian")
        trait += " and #{char_data[:non_playable_attrs][2][0].sample} scales."
      end
      trait
    when "attack"
      weapon = char_data[:fights_with].sample
      return {weapon:weapon, points:"fill in later points"}
    when "quirks"
      if options[:total] <= 4
        return ["is a #{char_data[:is_a].sample}", "knows how to #{char_data[:knows_how_to].sample}", 
    "studies #{char_data[:studies].sample.downcase}", "often #{char_data[:does_often].sample}"].sample(options[:total])
      else
        raise "error- maximum number of quirks is 4"
      end
    when "personality"
      puts "picking personality traits"
      if options[:alignment].include?("Good")
        personality = char_data[:pos_adj].sample(options[:total])
      elsif options[:alignment].include?("Evil")
        personality = char_data[:neg_adj].sample(options[:total])
      else
        pos =char_data[:pos_adj].sample(options[:total]-1)
        neg =char_data[:neg_adj].sample
        personality = pos << neg
      end
      return personality
    end
  end

  def MonsterManual.get_the(attribute, name)
    if name.match(/half\-.*/)
      name = name.match(/half\-(.*)/).captures[0]
    end
    monster_i = monst_data.index { |monst| monst["name"].match(/#{name}\s*/i) }
    return "could not find #{name}" if monster_i == nil
    monst_data[monster_i][attribute]
  end

  def MonsterManual.dice(type, name, max=false)
    dice = MonsterManual.get_the(type, name)
    if dice.match(/\dd\d+/)
      dice_count = dice.match(/(\d)d\d+/).captures[0].to_i
      dice_type = dice.match(/\dd(\d+)/).captures[0].to_i
      roll = 0
      dice_count.times do 
        #puts "rolling..."
        roll += max ? dice_type : rand(dice_type)
        #puts "total is now #{roll}"
      end
      if dice.match(/\dd\d+\+\d+/)
        modifier = dice.match(/\dd\d+\+(\d+)/).captures[0].to_i
        roll += modifier
      end
      return roll

    elsif dice.match(/\d+/)
      return dice.match(/(\d+)/).captures[0].to_i
    else
      raise "something went wrong in MonsterManual.dice"
    end
  end

  def MonsterManual.encyc(attribute, value)
    case attribute
    when "type", "subtype", "size", "alignment"
      results = monst_data.select do |monster|
        monster[attribute].include?(value.capitalize)
      end
    when "attack", "hit_pts"
      results = monst_data.select do |monster|
        value.include?(MonsterManual.dice(attribute, monster["name"], true))
      end
    when "description"
      results = monst_data.select do |monster|
        monster["desc"].include?(value)
      end
    end
    results
  end

end

