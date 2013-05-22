require './classes'
require './monster_manual'
include MonsterManual

puts "Making a new dungeon with a player..."
testDungeon = DTA::Dungeon.new
puts "Making a random character..."
testDungeon.makeCharacter(true)
puts "Making a half-elf character..."
testDungeon.makeCharacter(true, {"race"=>"half-elf"})
puts "Making an orc character..."
testDungeon.makeCharacter(true, {"race"=>"orc"})
puts "Maknig a Mummy character..."
testDungeon.makeCharacter(false, {"race"=>"mummy"})
puts "Maknig a random non-playable character..."
testDungeon.makeCharacter(false)
puts "Making a dragon character..."
testDungeon.makeCharacter(false, {"race"=>"metallic dragon"})
