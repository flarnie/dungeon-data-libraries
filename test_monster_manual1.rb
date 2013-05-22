require './monster_manual'
include MonsterManual

def name_tester(race)
  puts ''
  puts "  #{race.capitalize} female names"
  5.times { puts MonsterManual.name_it(race, "female")}
  puts "  #{race.capitalize} male names"
  5.times { puts MonsterManual.name_it(race, "male")}
end

def attr_tester(type, options1, options2=false)
  puts ''
  puts type.capitalize
  3.times { puts MonsterManual.pick_a(type, options1)}
  if options2
    puts 'alt options--'
    3.times { puts MonsterManual.pick_a(type, options2)}
  end
end

puts "NAME TESTS:"
name_tester("dwarf")
name_tester("elf")
name_tester("gnome")
name_tester("half-elf")
name_tester("half-orc")
name_tester("human")
name_tester("halfling")
puts ''
puts "ATTRIBUTE TESTS:"
attr_tester("race", {})
attr_tester("name", {race:"human",gender:"female"}, {race:"halfling",gender:"male"})
attr_tester("color", {playable:true, race:"dwarf"}, {playable:false, race:"halfling"})
attr_tester("type", {})
attr_tester("hairstyle", {race:"dwarf"}, {race:"human"})
attr_tester("attack", {})
attr_tester("quirks", {total:2})
attr_tester("personality", {})
puts "Testing Dragon Colors"
attr_tester("color", {playable:false, race:"chromatic dragon"})
attr_tester("color", {playable:false, race:"metallic dragon"})
