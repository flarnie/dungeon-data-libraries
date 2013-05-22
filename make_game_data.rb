require 'yaml'

character_data = {
:data_type => "character",
:playable_races => %w[ human dwarf elf gnome half-elf half-orc halfling ],
:skin_tones => %w[ivory beige ghost-white snow white maroon brown sienna saddle-brown chocolate sandybrown rosybrown tan wheat blanced-almond salmon dark-salmon light-salmon pink light-pink light-yellow],
:all_colors => %w[ maroon red orange yellow olive green purple fuchsia lime teal aqua blue black gray silver white crimson coral gold peach-puff plum amethyst indigo dark-slate-blue midnight-blue cornflower-blue sky-blue aquamarine dark-sea-green forest-green pale-green cornsilk white snow ivory slate-gray light-gray],
:hair_lengths => %w[long medium short],
:hair_styles => %w[straight wavy curly frizzy glossy tufted braided feathered spiked slick flowing],
:non_playable_attrs => [[["long", "short", "sharp", "color", "quick", "razor"],["claws", "spikes", "fangs", "talons"]], 
[["downy", "coarse", "greasy", "tufts", "of", "braided", "matted", "glossy", "sleek", "long", "short", "color", "well-groomed", ""],["fur", "hair", "feathers"]], 
[["glistening", "bumpy", "sparkling", "rough", "smooth", "clean", "speckled", "spotted", "striped"],["skin"]]],
:pos_adj => %w[adaptable adventurous affable affectionate agreeable ambitious amiable amicable amusing brave bright broad-minded calm careful charming communicative compassionate  conscientious considerate convivial courageous courteous creative decisive determined diligent diplomatic discreet dynamic easygoing emotional energetic enthusiastic extroverted exuberant fair-minded faithful fearless forceful frank friendly funny generous gentle gregarious hard-working helpful honest humorous imaginative impartial independent intellectual intelligent intuitive inventive kind loving loyal modest neat nice optimistic passionate patient persistent pioneering philosophical placid plucky polite powerful practical pro-active quick-witted quiet rational reliable reserved resourceful romantic self-confident self-disciplined sensible sensitive shy sincere sociable straightforward sympathetic thoughtful tidy tough unassuming understanding versatile warmhearted willing witty],
:neg_adj => %w[aggressive aloof arrogant belligerent big-headed boastful bone-idle boring bossy callous cantankerous careless changeable clinging compulsive conservative cowardly cruel cunning cynical deceitful detached dishonest dogmatic domineering finicky flirtatious foolish foolhardy fussy greedy grumpy gullible harsh  impatient impolite impulsive inconsiderate inconsistent indecisive indiscreet inflexible interfering intolerant introverted irresponsible jealous lazy Machiavellian materialistic mean miserly moody narrow-minded nasty naughty nervous obsessive obstinate overcritical overemotional parsimonious patronizing perverse pessimistic pompous possessive pusillanimous quarrelsome quick-tempered resentful rude ruthless sarcastic secretive selfish self-centred self-indulgent silly sneaky stingy stubborn stupid superficial tactless timid touchy thoughtless truculent unkind unpredictable unreliable untidy untrustworthy vague vain vengeful vulgar weak-willed],
:is_a => %w[escape-artist alchemist aristocrat brigand doctor hunter scholar blacksmith farmer fisher fletcher gambler pickpocket tanner locksmith mason merchant minstrel sailor sentinel],
:knows_how_to => %w[appraise balance bluff climb spy listen ride swim],
:studies => %w[History Linguistics Literature Acting Philosophy Religion Painting Anthropology Archaeology Space Science Chemistry Physics Logic Mathematics Statistics Systems Agriculture Architecture Business Divinity Education Engineering Forestry Healthcare Journalism Law Administration Arithmatic Magic Weaving Dragons Elves Lore Curses Blessings],
:does_often => %w[writes chants hums whistles sings paints sails reads studies encourages listens sleeps teaches protects learns fails gambles sneers smirks sighs giggles twitches dances],
:fights_with => [ "glaives", "lances", "a longspear", "ranseurs", "a spiked chain", "a whip", "a quarterstaff", "a sword", "an axe", "a dagger", "a club", "a shortspear", "a spear", "darts", "javelins", "a hammer", "a trident", "shuriken", "a net", "a crossbow", "a sling", "a shortbow", "a longbow", "their bare fists", "magic", "psi-powers", "spells", "kicking", "boxing", "a samurai-sword", "trickery and poison", "a flame-thrower"]
}

name_data = {
  :data_type => "names",
  :elf_first => %w[celyl faren alta berla mare mithe lego ar vanai al llara ness calend adon aini janth laina halato meril vani saer he ar caun ren da saba lar berdra era erura gale gala renlan erit aul rev amon aelga nenmi maer roch ago fae ery lithli mare verma],
  :f_elf_last => %w[ligh wyn viel las driel niel wen dra wien nil nia riel stiel diel thea ra sinria ranna mirya],
  :m_elf_last => %w[dor las dur fing riand alad ahad fil lien dal del sion lno neil vaul tinu vir nar thir vaul son than thil nan thion myr taur ron tion horil non ren don],
  :dwarf_first => %w[Fultauk Fultin Oak Dain Dunnur Agamm Starkral Dunaur Bakar Belerl Bazdar Stardel Birgal Toralim Kirtak Vallad Gomof Karad Gruar Rak Bokral Oburt Elgus Dunalel Bofnorn Thorur Bertak Mogig Bazar Garnek Gnok Vonar Gomggruk Fulin Ygdgruk Gordkas Dain Varor Hiror Baz Kordan Garan Donhud Dwalzin Rened Toraar Rov Hirbar Thir Torthic Magan Vonel Torar Arer Rak Orden Geto Matar Gret Yurdgrim Tol Garnli Vonrimm Matar Belus Relir Zundrin Belerl Havin Fultlond Thoradin Del Tol Ygdur Torlo Thir Thirlo Nibar Thothic Keldar Gimon Faern Thifan Starko Kelddrek Bofgrim Rorkas Raok Elor Caurn Varar Vorn Dwaler Beris Garandal Geggan Vagrim Dag Donathic Tybor],
  :dwarf_last_1 => %w[chert thunder boulder stone fire strong red iron armor earth bronze giant iron hammer thunder gravel silver steel marble axe anvil metal gray onyx ring ground rock blue boulder oak],
  :dwarf_last_2 => %w[dweller heart hewer tracker pick beard digger carver cutter cheek thewer worker fist foot shadow axe sword blade hammer dig breaker crusher oath forger foot smith smash hand caster spike back hand],
  :f_halfling_first => %w[ amaranth peony esmerelda robyn anelica asphodel prinula mimosa merimae rose violet],
  :m_halfling_first => %w[holfast milo hamson bingo samwise otho orgulas hal peregrin],
  :halfling_last => %w[foxburr griddlemitt swindletuck took flummster loamsworth soggybasket longbottom],
  :f_gnome_first => %w[pipi pitty bixy jubie lil lilliput peanut penny tallie trixie topsy tallie adan adva aiko aithne allison amorette armida belita bonita brenna brooke carlin charlene darra demi jenna kiara koemi maleah miette miki nina piera posy rosine rowan shanna solita tawnie teagan tulla viveca whitley yves zita],
  :m_gnome_first => %w[bingles bink dinky gnorbitt herble knaz krankle toby two-bit wizzle ziggy arno babak beagan carlin cerin coty dell egan fishel gair gelano gavin giles girvin goban gorman hackett hamlet hampton hewitt iven kane keegan keller killian leib loman lorcan mainchin malin mannix miki renny rordan rowan tomlin],
  :gnome_last => %w[cogglefix electrogauge fusegadget gearbit greasesprocket gyroscope rocketfuel sprocketcog thermobolt thermogauge thermojet gyrojet sprocketcog tiddlywink tinkertonk triggerblast puzzlecrank wizzbolt wobblecog littlefoot],
  :f_human_first => %w[ mary anna millicent alys ayleth anastas alianor cedany ellyn helewys malkyn peronell sybbyl ysmay thea jacquelyn amelia gloriana bess arabella heldegard brunhild adelaide alice lady selda ],
  :m_human_first => %w[john william james george charles frank joseph henry robert thomas merek carac ulric tybalt borin sadon terrowin rowan forthwind althalos fendrel brom hadrian crewe walter oliver alvin calvin kelvin roger ],
  :human_last => %w[cartwright rowntree writingham mckinnon wallington fenwick derwintwater bolbec derwent watersworth aragon degrey montagu smith binnety denvorn mickney sydney tanner potter smithson anderson fletcher cooper],
  :fey_plant_names => %w[alder amber ash aspen aster auburn autumn azalea bay beech birch calla briar camellia cedar celeste citron clay clementine clover dahlia daisy daphne drake ebony ember emerald fawn fern flora fleur forrest garnet gemma ginger hazel heath holly hyacinth indigo ivy jade jasmin jasper june juniper lake laurel lavender leaf lilac lily meadow magnolia luna olive opal oriel pearl petal plum poppy rain reed river rose rowan ruby saffron sage sapphire savannah shade sierra sky sorrel spring stella summer tulip fiolet willow winter wren ],
  :evil_first => %w[draco gall mal ali can avaris chaos caeron ysell nrill zant grag vusa incata quitu wither thoro mael miasma demont demon utoyel momento whitu zerman],
  :evil_last => %w[ievo vae shondra thus breather var ian thas nell asi blood tooth dor tion uryd ilin yss dan ador],
  :gross_names_first => %w[bumble pendantic slurry pureed gargle moist omnipotent queasy vile infested creamy weeping filthy quartered pestulent clogged],
  :gross_names_last => %w[dander googloplex filth pustule cluster welt puss boil dripping munch slurp postulation folding squirch kumquat smear one]
}

#Write the YAML data to file 
[character_data, name_data].each do |data|
  filename = "#{data[:data_type]}_data.yml"
  f = File.open(filename, "w")
  f.puts data.to_yaml
  f.close
end