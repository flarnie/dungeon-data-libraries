require './monster_manual'
include MonsterManual
#{"name"=>name, "type"=>type, "subtype"=>subtype, "size"=>size, 
    #"alignment"=>alignment, "attack"=>attack, "hit_pts"=>hit_pts, "desc"=>descript}

#
#MonsterManual.get_the("hitpoints", {race:@race})

def get_attr_tester(attribute, monster_name, expected)
  puts ''
  puts "Fetching #{attribute} for #{monster_name}:"
  found = MonsterManual.get_the(attribute, monster_name)
  puts found
  puts found == expected ? "Pass: #{found} = #{expected}" : "Fail: #{found} != #{expected}"
end

def test_dice(type, monster_name, max=false)
  puts ''
  puts "Rolling #{type} dice for #{monster_name}"
  puts "(#{MonsterManual.get_the(type, monster_name)})"
  rolled = MonsterManual.dice(type, monster_name, max)
  puts rolled
end

def encyc_tester(attribute, value)
  puts ''
  puts "Fetching all monsters with the following: #{attribute} of #{value}"
  MonsterManual.encyc(attribute, value).each do |monster|
    puts monster["name"]
  end
end

puts "TESTING ATTRIBUTE GETTER:"
get_attr_tester("type", "aboleth", ["Aberration"])
get_attr_tester("type", "orc", ["Humanoid"])
get_attr_tester("subtype", "barghest", ["Evil", "Extraplanar", "Lawful", "Shapechanger"])
get_attr_tester("size", "frost worm", ["Huge"])
get_attr_tester("alignment", "night hag", ["Evil"])
get_attr_tester("attack", "badger", "1d20+0")
get_attr_tester("hit_pts", "ogre", "4d8+11")

puts "--descriptions of monsters---"
puts "  Chaos Beast"
puts MonsterManual.get_the("desc", "chaos beast")
puts "  Chimera"
puts MonsterManual.get_the("desc", "chimera")
puts "  Golem"
puts MonsterManual.get_the("desc", "golem")
puts "  Ooze"
puts MonsterManual.get_the("desc", "ooze")
puts "  Orc"
puts MonsterManual.get_the("desc", "orc")
puts ''

puts "TESTING MONSTER DICE:"
puts "regular rolls..."
test_dice("attack", "fungus")
test_dice("attack", "xorn")
puts "max attack-"
test_dice("hit_pts", "ghoul", true)
test_dice("hit_pts", "rust monster", true)


puts "TESTING MONSTER ENCYCLOPEDIA:"
puts "  get by types/alignment"
encyc_tester("alignment", "evil")
encyc_tester("type","fey")
encyc_tester("type", "giant")
encyc_tester("type", "construct")
encyc_tester("type", "monstrous humanoid")
encyc_tester("type", "undead")
encyc_tester("type","humanoid")
encyc_tester("subtype","aquatic")

puts "  get by attack/hitpoints"
encyc_tester("attack",(1..20))
encyc_tester("hit_pts",(1..10))
encyc_tester("attack",(50..100))
encyc_tester("hit_pts",(50..60))
puts "  searching within description"
encyc_tester("alignment", "good")
encyc_tester("description", "good")
encyc_tester("alignment", "evil")
encyc_tester("description", "evil")
encyc_tester("alignment", "chaotic")

