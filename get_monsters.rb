require "net/http"
require "uri"
require "open-uri"
require "yaml"

monster_page = open("http://www.d20srd.org/indexes/monsters.htm"){|f| f.read }
startchar = monster_page.index('<a href="javascript:void(0);" id="aActuator">A</a><ul id="aMenu">')
endchar = monster_page.index('<div class="footer">')
monster_links = monster_page.slice(startchar..endchar);
#puts monster_links
monster_urls = monster_links.scan(/<li><a href="([^<]+?)">[^<]+?<\/a><\/li>/)
puts "Total monsters: #{monster_urls.length}"
#monster_urls.each do |url|
  #puts url
#end
main_types = ["Aberration", "Animal", "Construct", "Dragon", "Elemental", "Fey", "Giant", 
"Humanoid", "Magical Beast", "Monstrous Humanoid", "Ooze", "Outsider", "Plant", "Undead",
"Vermin"]
subtypes = ["Air", "Angel", "Aquatic", "Archon", "Augmented", "Chaotic", "Cold", 
"Earth", "Evil", "Extraplanar", "Fire", "Goblinoid", "Good", "Incorporeal", "Lawful", 
"Native", "Reptilian", "Shapechanger", "Swarm", "Water"]
sizes = ["Fine", "Diminutive", "Tiny", "Small", "Medium", "Large", "Huge", "Garganuan", "Colossal"]
alignments = ["Lawful", "Neutral", "Chaotic", "Good", "Evil"]
requested_urls = []
past_monsters = []
all_data = []
monster_urls.each do |url_ending|
  if requested_urls.include?(url_ending[0])
    puts "repeat request of #{url_ending[0]}"
    puts "#{requested_urls.length} pages requested so far."
    next
  else
    requested_urls << url_ending[0]
  end
  #how to stop repeats??
  url = "http://www.d20srd.org"+url_ending[0]
  begin
  profile = open(url){|f| f.read }
  rescue OpenURI::HTTPError
    puts "failed to open the url at #{url}"
    next
  end
  name = profile.match(/<h1>(.+?)</m).captures[0]
  #Begin special case for Dragons
  if name == "Dragon, True"
    if past_monsters.include?(name) || past_monsters.include?("Chromatic Dragon")
    puts "repeat monster"
    next
    else
    past_monsters << name
    data = {"name"=>"Chromatic Dragon", "type"=>["Dragon", "Magical Creature"], "subtype"=>["Reptilian"], 
      "size"=>["Huge"], "alignment"=>["Chaotic", "Evil"], "attack"=>"14d10+34", 
      "hit_pts"=>"25d12+150", 
      "desc"=>"The chromatic dragons are black, blue, green, red, and white; they are all evil and extremely fierce.\n"} 
    past_monsters << "Chromatic Dragon"
    all_data << data
    data = {"name"=>"Metallic Dragon", "type"=>["Dragon", "Magical Creature"], "subtype"=>["Reptilian"], 
      "size"=>["Huge"], "alignment"=>["Good"], "attack"=>"14d10+34", 
      "hit_pts"=>"25d12+150", 
      "desc"=>"The metallic dragons are brass, bronze, copper, gold, and silver; they are all good, usually noble, and highly respected by the wise. \n"} 
    past_monsters << "Metallic Dragon"
    all_data << data
    end
    #puts data["desc"]
    puts data.inspect
    File.open('monster_data.yml', 'w') do |f|
      YAML::dump(all_data, f)
    end
    next
  end
  #end special case for
  puts "#{name}~"
  types = profile.match(/ype<\/a>.*?:.*?<\/th>.*?<td>.*?<a .+?(">.+?)<\/t/m)
  if types == nil || types.length == 0
    puts "#{name}: did not find subtypes or types"
    next
  else
    types = profile.match(/ype<\/a>.*?:.*?<\/th>.*?<td>.*?<a .+?(">.+?)<\/t/m).captures[0]
  end
  #my additions
  case name.downcase
  when "gnoll", "ogre", "ogre mage", "shadow", "ghoul", "wight", "wraith", "gnoll ", "ogre ", "ogre mage ", "shadow ", "ghoul ", "wight ", "wraith "
    types << "Evil"
  when "vampire", "harpy", "ogre", "ogre mage", "dryad", "sprite", "nymph", "satyr", "giant", "troll", "golem", "mummy", "vampire ", "harpy ", "ogre ", "ogre mage ", "dryad ", "sprite ", "nymph ", "satyr ", "giant ", "troll ", "golem ", "mummy " 
    types << "Humanoid"
  when "dwarf", "dwarf "
    types << "Lawful"
    types << "Good"
  when "orc", "orc "
    types << "Chaotic"
    types << "Evil"
  when "unicorn", "pegasus", "unicorn ", "pegasus "
    types << "Good"
  else
    #nothing
  end
  types = types.scan(/">(.+?)<\/a>/).to_a.flatten.each { |type| type.downcase }
  type = types & main_types == nil ? false : types & main_types
  subtype = types & subtypes == nil ? false : types & subtypes
  alignment = types & alignments == nil ? false : types & alignments
  size = types & sizes == nil ? false : types & sizes
  attack = profile.match(/'Base Attack','(\d*d\d*\+?\d*?)/)
  if attack == nil
    puts "#{name}: did not find attack"
    next
  else
    attack = profile.match(/'Base Attack','(\d*d\d*\+?\d*)'/).captures[0]
  end
  hit_pts = profile.match(/'Hit Points','(\d*d\d+\+?\d*?)'/)
  if hit_pts == nil
    hit_pts = profile.match(/<td>.*\(.*?(\d+).*?hp\)/).captures[0]
    if hit_pts == nil
      puts "hit pts truly not found for #{name}"
      next
    else
      hit_pts = profile.match(/<td>.*\(.*?(\d+).*?hp\)/).captures[0]
    end
  else
    hit_pts = profile.match(/'Hit Points','(\d*d\d+\+?\d*?)'/).captures[0]
  end
  descript = profile.match(/<p>(.+)<h\d>Combat<\/h\d>/m)
  if descript == nil
    puts "#{name}: did not find desc"
    next
  else
    descript = profile.match(/<p>(.+?)<h\d>Combat<\/h\d>/m).captures[0]
    if descript.include?("<table") 
      descript = profile.match(/<\/h1>.*?<p>(.+?)<\/p>/m)
      if descript == nil
        puts "#{name}: did not find desc"
        next
      else
        descript = profile.match(/<\/h1>.*?<p>(.+?)<\/p>/m).captures[0]
      end
    end
    #descript = descript.gsub(/(<h.*?>.+?<\/h\d>.*?<table.+)/m,"")
    descript = descript.gsub(/(<.+?>)/m,"")
    if descript.is_a?(String)
      descript.force_encoding("UTF-8")
    end
  end
  data = {"name"=>name.downcase, "type"=>type, "subtype"=>subtype, "size"=>size, 
    "alignment"=>alignment, "attack"=>attack, "hit_pts"=>hit_pts, "desc"=>descript}
  if past_monsters.include?(name)
    puts "repeat monster"
    next
  else
    past_monsters << name
    all_data << data
  end
  #puts data["desc"]
  puts data.inspect
  File.open('monster_data.yml', 'w') do |f|
    YAML::dump(all_data, f)
  end
end
