local ADDON, Addon = ...
local Data = Addon:NewModule('Data')

local KNOWLEDGE_CURRENCY_ID = 1171
local fakeTooltip
local cachedKnowledgeLevel
local cachedPower = {}
local cachedItems = {}

local worldQuestReps = {[42624]=1900,[42021]=1900,[43430]={1894,1900},[43613]={1894,1900},[43609]={1894,1900},[43610]={1894,1900},[43428]={1894,1900},[43427]={1894,1900},[42511]=1900,[42636]={1894,1900},[42211]=1900,[42159]=1900,[42165]=1900,[42146]=1900,[42024]=1900,[41657]=1900,[41663]=1900,[41669]=1900,[41645]=1900,[41327]=1900,[41288]=1900,[41311]=1900,[43804]={1894,1900},[43776]=1948,[43765]=1948,[43608]={1894,1900},[43612]={1894,1900},[43614]={1894,1900},[43607]={1894,1900},[43431]={1894,1900},[43429]={1894,1900},[43192]=1900,[43193]=1900,[42711]=1900,[42631]={1894,1900},[42652]=1900,[42620]={1894,1900},[42623]=1900,[42506]=1900,[42277]=1900,[42275]=1900,[42276]=1900,[42172]=1900,[42154]=1900,[42160]=1900,[42148]=1900,[42123]=1900,[42108]=1900,[42112]=1900,[42119]=1900,[42101]=1900,[42105]=1900,[42063]=1900,[42026]=1900,[42027]=1900,[42022]=1900,[42018]=1900,[42019]=1900,[42014]=1900,[41896]=1900,[41287]=1900,[41267]=1900,[42274]=1900,[42633]={1894,1900},[43325]={1090,1900},[43327]={1090,1900},[43426]={1894,1900},[43432]={1894,1900},[43605]={1894,1900},[43606]={1894,1900},[43611]={1894,1900},[43801]={1894,1900},[43803]={1894,1900},[44287]={1894,1900},[41633]=1900,[41651]=1900,[41639]=1900,[41326]=1900,[41644]=1900,[41680]=1900,[41674]=1900,[41650]=1900,[41638]=1900,[41701]=1828,[41789]=1828,[41779]={1894,1828},[41766]=1828,[41699]=1828,[41819]={1894,1828},[44292]=1894,[43985]=1828,[43455]={1894,1828},[41836]={1894,1828},[41089]=1828,[41122]=1828,[40951]=1828,[41011]=1828,[40925]=1828,[44289]={1894,1828},[43617]={1894,1828},[43619]={1894,1828},[43448]=1828,[42086]=1828,[41884]=1828,[41882]=1828,[41844]={1894,1828},[41835]=1828,[41816]={1894,1828},[41706]=1828,[41703]={1894,1828},[41705]=1828,[41695]={1894,1828},[41696]={1894,1828},[41691]=1828,[41687]=1828,[41677]=1828,[41685]={1894,1828},[41653]=1828,[41641]=1828,[41622]=1828,[41623]=1828,[41624]=1828,[41428]=1828,[41421]=1828,[41416]=1828,[41420]=1828,[41414]=1828,[41321]=1828,[41310]=1828,[41308]=1828,[41257]=1828,[41227]=1828,[41207]=1828,[41144]=1828,[41093]={1894,1828},[41095]=1828,[41077]=1828,[41025]=1828,[41024]=1828,[41013]=1828,[40978]=1828,[40896]=1828,[40850]=1828,[40280]=1828,[39424]=1828,[41983]=1859,[41986]=1859,[41824]={1894,1828},[41826]={1894,1828},[41828]={1894,1828},[41838]={1894,1828},[41821]={1894,1828},[41818]={1894,1828},[41671]=1828,[41665]=1828,[41659]=1828,[41635]=1828,[41647]=1828,[41240]=1828,[41224]=1828,[41237]=1828,[41076]=1828,[41078]=1828,[41055]=1828,[40282]=1828,[39462]=1828,[40920]=1828,[40966]=1828,[40980]=1828,[41014]=1828,[41026]=1828,[41057]=1828,[41091]=1828,[41127]=1828,[41145]=1828,[41692]=1828,[42064]=1828,[43616]={1894,1828},[43618]={1894,1828},[43764]={1090,1828},[43767]={1090,1828},[44290]={1894,1828},[44291]={1894,1828},[44293]=1894,[44294]={1894,1828},[41223]=1828,[41235]=1828,[41427]=1948,[43438]={1894,1948},[43626]={1894,1948},[43786]=1948,[43745]=1948,[43722]=1948,[43625]={1894,1948},[43628]={1894,1948},[43623]={1894,1948},[43621]={1894,1948},[43434]={1894,1948},[42785]={1894,1948},[42067]=1948,[41958]=1948,[41794]=1948,[41344]=1948,[41277]=1948,[43963]=1948,[43951]=1948,[43827]=1948,[43752]=1948,[43751]=1948,[43710]=1948,[43627]={1894,1948},[43624]={1894,1948},[43620]={1894,1948},[43622]={1894,1948},[43600]=1948,[43601]=1948,[43598]=1948,[43599]=1948,[43453]={1894,1948},[43452]={1894,1948},[43451]={1894,1948},[43450]={1894,1948},[43437]={1894,1948},[42991]={1894,1948},[42964]={1894,1948},[42953]={1894,1948},[42861]={1894,1948},[42806]={1894,1948},[42270]=1948,[42269]=1948,[42183]=1948,[42182]=1948,[42176]=1948,[42177]=1948,[42173]=1948,[42025]=1948,[42004]=1948,[41948]=1948,[41949]=1948,[41950]=1948,[41935]=1948,[41936]=1948,[41938]=1948,[41927]=1948,[41930]=1948,[41925]=1948,[41926]=1948,[41642]=1948,[41636]=1948,[41451]=1948,[41672]=1948,[41678]=1948,[41666]=1948,[41660]=1948,[41654]=1948,[41648]=1948,[41345]=1948,[41317]=1948,[41298]=1948,[40278]=1948,[41297]=1948,[41944]=1948,[41984]=1948,[42013]=1948,[42178]=1948,[42820]={1894,1948},[42864]={1894,1948},[43436]={1894,1948},[43454]={1894,1948},[43769]={1090,1948},[43772]={1090,1948},[43964]=1948,[41313]=1948,[42963]={1894,1948},[44299]={1894,1883},[44301]={1894,1883},[44305]={1894,1883},[44298]={1894,1883},[43101]={1894,1883},[43629]={1894,1883},[43709]=1883,[43457]={1894,1883},[42190]=1883,[42150]=1883,[41964]=1883,[41965]=1883,[41992]=1883,[41955]=1883,[41862]=1883,[44303]={1894,1883},[44033]=1883,[44011]=1883,[43784]=1883,[43759]=1883,[43738]=1883,[43632]={1894,1883},[43630]={1894,1883},[43631]={1894,1883},[43460]={1894,1883},[43458]={1894,1883},[43459]={1894,1883},[43456]={1894,1883},[43346]={1894,1883},[43333]={1894,1883},[43336]=1883,[43345]={1894,1883},[43332]=1883,[43324]=1883,[43248]=1883,[43303]=1883,[43247]=1883,[43183]=1883,[43152]={1894,1883},[42779]=1883,[42124]=1883,[42145]=1883,[42087]=1883,[42080]=1883,[42076]=1883,[42077]=1883,[42075]=1883,[42070]=1883,[42028]=1883,[42023]=1883,[41995]=1883,[41996]=1883,[41980]=1883,[41855]=1883,[41860]=1883,[41861]=1883,[41670]=1883,[41658]=1883,[40279]=1883,[41338]=1883,[41312]=1883,[41292]=1883,[41316]=1883,[41634]=1883,[41664]=1883,[41676]=1883,[41700]={1894,1883},[41956]=1883,[42174]=1883,[42927]={1894,1883},[43633]={1894,1883},[43753]={1090,1883},[43758]=1883,[44300]={1894,1883},[44302]={1894,1883},[44304]={1894,1883},[41339]=1883,[41652]=1883,[41640]=1883,[41646]=1883,[44022]={1894,1859},[43435]=1859,[44067]=1859,[43814]=1859,[41697]={1894,1859},[44157]=1859,[44158]=1859,[44114]={1894,1859},[44032]={1894,1900},[44029]={1894,1900},[44027]={1894,1859},[44023]={1894,1859},[44021]={1894,1900},[44019]={1894,1900},[44018]={1894,1900},[44017]={1894,1859},[44016]={1894,1859},[44013]={1894,1900},[44010]={1894,1900},[44002]=1859,[43932]=1859,[43943]=1859,[43930]=1859,[43807]=1859,[43583]=1859,[43445]=1859,[42969]=1859,[42962]=1859,[42859]=1859,[42830]=1859,[42797]={1894,1859},[42796]={1894,1859},[42795]={1894,1859},[42209]=1859,[42169]=1859,[42151]=1859,[42111]=1859,[42106]=1859,[42082]=1859,[42089]=1859,[42090]=1859,[42071]=1859,[42015]=1859,[41931]=1859,[41649]=1859,[41643]=1859,[41302]=1859,[40337]=1859,[41282]=1859,[41351]=1859,[41637]=1859,[41661]=1859,[41667]=1859,[41895]=1859,[42725]=1859,[42880]=1859,[43774]={1090,1859},[43777]={1090,1859},[43959]=1859,[44012]={1894,1859},[44015]={1894,1859},[44026]={1894,1859},[44028]={1894,1900},[44030]={1894,1900},[44031]={1894,1900},[44119]={1894,1859},[44121]=1894,[44122]={1894,1859},[41350]=1859,[41655]=1859,[41303]=1859,[41673]=1859,[41679]=1859,[44054]={1894,1900},[43072]={1894,1900},[43059]={1894,1900},[43121]={1894,1900},[44194]={1894,1900},[44193]={1894,1900},[44192]={1894,1900},[44191]={1894,1900},[44048]={1894,1900},[44044]={1894,1900},[43079]={1894,1900},[43098]={1894,1900},[43040]={1894,1900},[43027]={1894,1900},[44050]={1894,1900},[44190]={1894,1900}}

-- 8: Iron Relics
-- 9: Blood Relics
-- 10: Shadow Relics
-- 11: Fel Relics
-- 12: Arcane Relics
-- 13: Frost Relics
-- 14: Fire Relics
-- 15: Water Relics
-- 16: Life Relics
-- 17: Storm Relics
-- 18: Holy Relics
local itemRelicTypes = {[140815]=8,[140816]=8,[140817]=8,[141521]=8,[139261]=8,[139255]=8,[142061]=8,[137543]=8,[137472]=8,[137469]=8,[137408]=8,[137371]=8,[137359]=8,[137326]=8,[136778]=8,[133763]=8,[141268]=8,[141288]=8,[141262]=8,[141263]=8,[134081]=8,[136684]=8,[135573]=8,[140436]=8,[140417]=8,[140435]=8,[132850]=8,[132792]=8,[132804]=8,[132815]=8,[132989]=8,[133000]=8,[133012]=8,[133035]=8,[133046]=8,[133075]=8,[133086]=8,[133098]=8,[132781]=8,[132321]=8,[133024]=8,[132830]=8,[133120]=8,[133131]=8,[133142]=8,[132351]=8,[132340]=8,[133057]=8,[132294]=8,[132295]=8,[132310]=8,[133109]=8,[140818]=9,[140819]=9,[140820]=9,[141523]=9,[139260]=9,[139257]=9,[139254]=9,[142057]=9,[137544]=9,[137471]=9,[137465]=9,[137412]=9,[137363]=9,[137350]=9,[137302]=9,[136718]=9,[133687]=9,[141264]=9,[141287]=9,[141283]=9,[141280]=9,[136683]=9,[135568]=9,[140426]=9,[140413]=9,[140425]=9,[132846]=9,[132788]=9,[132800]=9,[132811]=9,[132985]=9,[132996]=9,[133008]=9,[133031]=9,[133042]=9,[133071]=9,[133082]=9,[133094]=9,[132777]=9,[132317]=9,[133020]=9,[132826]=9,[133116]=9,[133127]=9,[133138]=9,[132347]=9,[132336]=9,[133053]=9,[132283]=9,[132284]=9,[132306]=9,[133105]=9,[140821]=10,[140822]=10,[140823]=10,[141518]=10,[139268]=10,[139251]=10,[138226]=10,[142063]=10,[137549]=10,[137464]=10,[137463]=10,[137399]=10,[137377]=10,[137347]=10,[137317]=10,[136719]=10,[133684]=10,[141291]=10,[141273]=10,[141254]=10,[141282]=10,[134078]=10,[136689]=10,[135576]=10,[140440]=10,[140419]=10,[140441]=10,[132852]=10,[132794]=10,[132806]=10,[132817]=10,[132991]=10,[133002]=10,[133014]=10,[133037]=10,[133048]=10,[133077]=10,[133088]=10,[133100]=10,[132783]=10,[132323]=10,[132832]=10,[133059]=10,[133122]=10,[133133]=10,[133144]=10,[132353]=10,[133026]=10,[132342]=10,[132298]=10,[132299]=10,[132312]=10,[133111]=10,[140824]=11,[140825]=11,[140826]=11,[141520]=11,[139267]=11,[139253]=11,[142058]=11,[137542]=11,[137491]=11,[137476]=11,[137407]=11,[137351]=11,[136721]=11,[133764]=11,[141281]=11,[141277]=11,[141255]=11,[141289]=11,[136687]=11,[140428]=11,[135569]=11,[140414]=11,[140427]=11,[133043]=11,[132789]=11,[132801]=11,[132812]=11,[133106]=11,[132986]=11,[133095]=11,[133083]=11,[133072]=11,[132997]=11,[133009]=11,[133032]=11,[132778]=11,[132318]=11,[132827]=11,[132847]=11,[133021]=11,[133054]=11,[133117]=11,[133128]=11,[133139]=11,[132337]=11,[132285]=11,[132286]=11,[132307]=11,[132348]=11,[140810]=12,[140812]=12,[140813]=12,[140827]=12,[141515]=12,[139269]=12,[138227]=12,[142056]=12,[137547]=12,[137490]=12,[137473]=12,[137420]=12,[137379]=12,[137303]=12,[133768]=12,[141259]=12,[141292]=12,[141272]=12,[141266]=12,[131731]=12,[136691]=12,[135565]=12,[140424]=12,[140412]=12,[140423]=12,[132845]=12,[132787]=12,[132799]=12,[132810]=12,[132984]=12,[132995]=12,[133007]=12,[133030]=12,[133041]=12,[133070]=12,[133081]=12,[133093]=12,[132776]=12,[132316]=12,[133019]=12,[132825]=12,[133115]=12,[133126]=12,[133137]=12,[132346]=12,[132335]=12,[133052]=12,[132281]=12,[132282]=12,[132305]=12,[133104]=12,[140831]=13,[140832]=13,[140833]=13,[141517]=13,[139259]=13,[139250]=13,[142060]=13,[137545]=13,[137466]=13,[137403]=13,[137380]=13,[137370]=13,[137340]=13,[137308]=13,[137272]=13,[133683]=13,[141274]=13,[141284]=13,[141257]=13,[141267]=13,[134076]=13,[136692]=13,[135570]=13,[140432]=13,[140416]=13,[140431]=13,[132849]=13,[132791]=13,[132803]=13,[132814]=13,[132988]=13,[132999]=13,[133011]=13,[133034]=13,[133045]=13,[133074]=13,[133085]=13,[133097]=13,[132780]=13,[132320]=13,[133023]=13,[132829]=13,[133119]=13,[133130]=13,[133141]=13,[132350]=13,[132339]=13,[133056]=13,[132289]=13,[132290]=13,[132309]=13,[133108]=13,[140834]=14,[140835]=14,[140836]=14,[140837]=14,[141522]=14,[139266]=14,[139256]=14,[142059]=14,[137546]=14,[137492]=14,[137470]=14,[137375]=14,[137358]=14,[137316]=14,[136769]=14,[133686]=14,[141279]=14,[141293]=14,[141261]=14,[141265]=14,[134077]=14,[136686]=14,[135571]=14,[140430]=14,[140415]=14,[140429]=14,[132848]=14,[132790]=14,[132802]=14,[132813]=14,[132987]=14,[132998]=14,[133010]=14,[133033]=14,[133044]=14,[133073]=14,[133084]=14,[133096]=14,[132779]=14,[132319]=14,[133022]=14,[132828]=14,[133118]=14,[133129]=14,[133140]=14,[132349]=14,[132338]=14,[133055]=14,[132287]=14,[132288]=14,[132308]=14,[133107]=14,[135577]=15,[132343]=15,[132795]=15,[132807]=15,[132818]=15,[133015]=15,[133049]=15,[133078]=15,[133089]=15,[133101]=15,[132784]=15,[132324]=15,[132354]=15,[133027]=15,[133060]=15,[133134]=15,[133145]=15,[132300]=15,[132301]=15,[132313]=15,[133112]=15,[140838]=16,[140839]=16,[141516]=16,[139263]=16,[139249]=16,[138228]=16,[142062]=16,[137478]=16,[137411]=16,[137381]=16,[137339]=16,[137327]=16,[137307]=16,[136973]=16,[136720]=16,[141275]=16,[141290]=16,[141256]=16,[141269]=16,[134079]=16,[136693]=16,[135574]=16,[140438]=16,[140418]=16,[140437]=16,[132851]=16,[132793]=16,[132805]=16,[132816]=16,[132990]=16,[133001]=16,[133013]=16,[133036]=16,[133047]=16,[133076]=16,[133087]=16,[133099]=16,[132782]=16,[132322]=16,[133025]=16,[132831]=16,[133121]=16,[133132]=16,[133143]=16,[132352]=16,[132341]=16,[133058]=16,[132296]=16,[132297]=16,[132311]=16,[133110]=16,[140840]=17,[140841]=17,[140842]=17,[141514]=17,[139264]=17,[139262]=17,[138229]=17,[137008]=17,[142064]=17,[137550]=17,[137493]=17,[137468]=17,[137421]=17,[137365]=17,[137313]=17,[137270]=17,[136974]=17,[133682]=17,[141258]=17,[141270]=17,[141285]=17,[141278]=17,[136688]=17,[135578]=17,[140442]=17,[140420]=17,[140443]=17,[132854]=17,[132796]=17,[132808]=17,[132819]=17,[132993]=17,[133004]=17,[133016]=17,[133039]=17,[133050]=17,[133079]=17,[133090]=17,[133102]=17,[132785]=17,[132325]=17,[132834]=17,[133061]=17,[133124]=17,[133135]=17,[133146]=17,[132355]=17,[133028]=17,[132344]=17,[132302]=17,[132303]=17,[132314]=17,[133113]=17,[140843]=18,[140844]=18,[140845]=18,[141519]=18,[139265]=18,[139258]=18,[139252]=18,[142055]=18,[137548]=18,[137495]=18,[137474]=18,[137402]=18,[137366]=18,[137346]=18,[136771]=18,[136717]=18,[133685]=18,[141271]=18,[141276]=18,[141286]=18,[141260]=18,[136685]=18,[135572]=18,[140411]=18,[140433]=18,[140434]=18,[133040]=18,[133103]=18,[133092]=18,[132775]=18,[132786]=18,[132983]=18,[132994]=18,[133006]=18,[133029]=18,[132280]=18,[132279]=18,[132345]=18,[132824]=18,[132844]=18,[133018]=18,[133051]=18,[133114]=18,[133125]=18,[133136]=18,[132334]=18}
local artifactRelicSlots = {
	--  Death Knight
	[128402] = { 9, 10, 8 }, -- Blood
	[128292] = { 13, 10, 13 }, -- Frost
	[128403] = { 14, 10, 9 }, -- Unholy
	-- Demon Hunter
	[127829] = { 11, 10, 11 }, -- Havoc
	[128832] = { 8, 12, 11 }, -- Vengeance
	-- Druid
	[128858] = { 12, 16, 12 }, -- Balance
	[128860] = { 13, 9, 16 }, -- Feral
	[128821] = { 14, 9, 16 }, -- Guardian
	[128306] = { 16, 13, 16 }, -- Restoration
	--  Hunter
	[128861] = { 17, 12, 8 }, -- Beast Mastery
	[128826] = { 17, 9, 16 }, -- Masksmanship
	[128808] = { 17, 8, 9 }, -- Survival
	--  Mage
	[127857] = { 12, 13, 12 }, -- Arcane
	[128820] = { 14, 12, 14 }, -- Fire
	[128862] = { 13, 12, 13 }, -- Frost
	--  Monk
	[128938] = { 16, 17, 8 }, -- Brewmaster
	[128937] = { 13, 16, 17 }, -- Mistweaver
	[128940] = { 17, 8, 17 }, -- Windwalker
	--  Paladin
	[128823] = { 18, 16, 18 }, -- Holy
	[128866] = { 18, 8, 12 }, -- Protection
	[120978] = { 18, 14, 18 }, -- Retribution
	--  Priest
	[128868] = { 18, 10, 18 }, -- Discipline
	[128825] = { 18, 16, 18 }, -- Holy
 	[128827] = { 10, 9, 10 }, -- Shadow
	--  Rogue
	[128870] = { 10, 8, 9 }, -- Assassination
	[128872] = { 9, 8, 17 }, -- Outlaw
	[128476] = { 11, 10, 11 }, -- Subtlety
	--  Shaman
	[128935] = { 17, 13, 17 }, -- Elemental
	[128819] = { 14, 8, 17 }, -- Enhancement
	[128911] = { 16, 13, 16 }, -- Restoration
	--  Warlock
	[128942] = { 10, 9, 10 }, -- Affliction
	[128943] = { 10, 14, 11 }, -- Demonology
	[128941] = { 11, 14, 11 }, -- Destruction
	--  Warrior
	[128910] = { 8, 9, 10 }, -- Arms
	[128908] = { 14, 17, 8 }, -- Fury
	[128289] = { 8, 9, 14 }, -- Protection
}

function Data:TestArtifacts()
	local relicNames = {
		[8] = "Iron",
		[9] = "Blood",
		[10] = "Shadow",
		[11] = "Fel",
		[12] = "Arcane",
		[13] = "Frost",
		[14] = "Fire",
		[15] = "Water",
		[16] = "Life",
		[17] = "Storm",
		[18] = "Holy",
	}

	for itemID, relics in pairs(artifactRelicSlots) do
		local itemName = GetItemInfo(itemID)
	end

	for itemID, relics in pairs(artifactRelicSlots) do
		local itemLink = select(2, GetItemInfo(itemID))
		if (itemLink) then
			print( string.format("%s: %s, %s, %s", itemLink, relicNames[relics[1]], relicNames[relics[2]], relicNames[relics[3]]) )
		end
	end

end

local NUM_RELICS = 3
local UNLOCK_RELIC_SLOT_ACHIEVEMENT = 10994

local invtype_locations = {
	INVTYPE_HEAD = { INVSLOT_HEAD },
	INVTYPE_NECK = { INVSLOT_NECK },
	INVTYPE_SHOULDER = { INVSLOT_SHOULDER },
	INVTYPE_BODY = { INVSLOT_BODY },
	INVTYPE_CHEST = { INVSLOT_CHEST },
	INVTYPE_ROBE = { INVSLOT_CHEST },
	INVTYPE_WAIST = { INVSLOT_WAIST },
	INVTYPE_LEGS = { INVSLOT_LEGS },
	INVTYPE_FEET = { INVSLOT_FEET },
	INVTYPE_WRIST = { INVSLOT_WRIST },
	INVTYPE_HAND = { INVSLOT_HAND },
	INVTYPE_FINGER = { INVSLOT_FINGER1, INVSLOT_FINGER2 },
	INVTYPE_TRINKET = { INVSLOT_TRINKET1, INVSLOT_TRINKET2 },
	INVTYPE_CLOAK = { INVSLOT_BACK },
	INVTYPE_WEAPON = { INVSLOT_MAINHAND, INVSLOT_OFFHAND },
	INVTYPE_SHIELD = { INVSLOT_OFFHAND },
	INVTYPE_2HWEAPON = { INVSLOT_MAINHAND },
	INVTYPE_WEAPONMAINHAND = { INVSLOT_MAINHAND },
	INVTYPE_WEAPONOFFHAND = { INVSLOT_OFFHAND },
	INVTYPE_HOLDABLE = { INVSLOT_OFFHAND },
}

local cachedArtifactRelics = nil
local function GetAllArtifactRelics()
	if cachedArtifactRelics then return cachedArtifactRelics end

	local ret = {}

	local unlockEarned = select(13, GetAchievementInfo(UNLOCK_RELIC_SLOT_ACHIEVEMENT))

	local currentSpec = GetSpecializationInfo(GetSpecialization())
	local artifactInvSlot = INVSLOT_MAINHAND
	if (currentSpec == 266 or currentSpec == 73 or currentSpec == 66) then artifactInvSlot = INVSLOT_OFFHAND end -- Demonology Warlock, Protection Warrior, Protection Paladin

	local currentLink = GetInventoryItemLink("player", artifactInvSlot)

	local currentItemID = currentLink and tonumber( currentLink:match("item:(%d+):") )
	if artifactRelicSlots[currentItemID] then
		local relics = {}
		for i=1, NUM_RELICS do
			if i == NUM_RELICS and not unlockEarned then
				relics[i] = false
			else
				relics[i] = select(2, GetItemGem(currentLink, i))
			end
		end
		ret[currentItemID] = relics
	end

	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = GetContainerNumSlots(container)
		for slot=1, slots do
			local _, _, _, _, _, _, slotLink, _, _, slotItemID = GetContainerItemInfo(container, slot)
			if artifactRelicSlots[slotItemID] then
				local relics = {}
				for i=1, NUM_RELICS do
					if i == NUM_RELICS and not unlockEarned then
						relics[i] = false
					else
						relics[i] = select(2, GetItemGem(slotLink, i))
					end
				end
				ret[slotItemID] = relics
			end
		end
	end
	cachedArtifactRelics = ret
	return ret
end

function Data:ItemArtifactPower(itemID)
	local currentKnowledge = select(2, GetCurrencyInfo(KNOWLEDGE_CURRENCY_ID))
	if cachedKnowledgeLevel ~= currentKnowledge then
		wipe(cachedPower)
		cachedKnowledgeLevel = currentKnowledge
	end

	if cachedPower[itemID] ~= nil then
		return cachedPower[itemID]
	end

	fakeTooltip:ClearLines()
	fakeTooltip:SetItemByID(itemID)

	local textLine2 = AWQFakeTooltipTextLeft2 and AWQFakeTooltipTextLeft2:IsShown() and AWQFakeTooltipTextLeft2:GetText()
	local textLine4 = AWQFakeTooltipTextLeft4 and AWQFakeTooltipTextLeft4:IsShown() and AWQFakeTooltipTextLeft4:GetText()

	if textLine2 and textLine4 and textLine2:match("|cFFE6CC80") then
		local power = textLine4:gsub("%p", ""):match("%d+")
		power = tonumber(power)

		cachedPower[itemID] = power
		return power
	else
		cachedPower[itemID] = false
		return false
	end
end

function Data:QuestHasFaction(questID, factionID)
	local reps = worldQuestReps[questID]
	if reps then
		if (type(reps) == "table") then
			for _, fID in ipairs(reps) do
				if fID == factionID then return true end
			end
			return false
		else
			return reps == factionID
		end
	else
		return false
	end
end

function Data:RewardIsUpgrade(questID)
	local _, _, _, _, _, itemID = GetQuestLogRewardInfo(1, questID)
	local _, _, _, _, _, _, _, _, equipSlot, _, _ = GetItemInfo(itemID)
	local ilvl = self:RewardItemLevel(questID)

	if equipSlot and invtype_locations[equipSlot] then
		local isUpgrade = false

		for _, slotID in ipairs(invtype_locations[equipSlot]) do
			local currentItem = GetInventoryItemLink("player", slotID)
			if currentItem then
				local currentIlvl = select(4, GetItemInfo(currentItem))
				if not currentIlvl or ilvl > currentIlvl then
					isUpgrade = true
				end
			else
				isUpgrade = true
			end
		end

		return isUpgrade
	elseif itemRelicTypes[itemID] then 
		local isUpgrade = false
		local itemRelicType = itemRelicTypes[itemID]

		local currentRelics = GetAllArtifactRelics()
		for artifactID, relics in pairs(currentRelics) do
			for i=1, NUM_RELICS do
				local relic = relics[i]
				local relicType = artifactRelicSlots[artifactID][i]
				if relic ~= false and relicType == itemRelicType then
					if relic then
						local relicIlvl = select(4, GetItemInfo(relic))
						if relicIlvl and ilvl > relicIlvl then
							isUpgrade = true
						end
					else
						isUpgrade = true
					end
				end 
			end
		end
	
		return isUpgrade
	else
		return true
	end
end

function Data:RewardItemLevel(itemID, questID)
	local key = itemID..":"..questID
	if cachedItems[key] == nil then
		fakeTooltip:ClearLines()
		fakeTooltip:SetQuestLogItem("reward", 1, questID)

		-- local itemLink = select(2, fakeTooltip:GetItem())
		if false and itemLink then
			local itemName, _, _, itemLevel, _, _, _, _, itemEquipLoc, _, _, itemClassID, itemSubClassID = GetItemInfo(itemLink)
			if itemName then
				if (itemClassID == 3 and itemSubClassID == 11) or (itemEquipLoc ~= nil and itemEquipLoc ~= "") then
					cachedItems[key] = itemLevel
				else
					cachedItems[key] = false
				end
			end
		else
			local textLine2 = AWQFakeTooltipTextLeft2 and AWQFakeTooltipTextLeft2:IsShown() and AWQFakeTooltipTextLeft2:GetText()
			local textLine3 = AWQFakeTooltipTextLeft3 and AWQFakeTooltipTextLeft3:IsShown() and AWQFakeTooltipTextLeft3:GetText()
			local matcher = string.gsub(ITEM_LEVEL_PLUS, "%%d%+", "(%%d+)+")
			local itemLevel

			if textLine2 then
				itemLevel = tonumber(textLine2:match(matcher))
			end
			if textLine3 and not itemLevel then
				itemLevel = tonumber(textLine3:match(matcher))
			end

			cachedItems[key] = itemLevel or false
		end
	end
	return cachedItems[key]
end

function Data:UNIT_QUEST_LOG_CHANGED(arg1)
	if arg1 == "player" then
		wipe(cachedItems)
	end
end

function Data:ClearArtifactCache()
	cachedArtifactRelics = nil
end

function Data:Startup()
	fakeTooltip = CreateFrame('GameTooltip', 'AWQFakeTooltip', UIParent, 'GameTooltipTemplate')
	fakeTooltip:SetOwner(UIParent, "ANCHOR_NONE")

	self:RegisterEvent('UNIT_QUEST_LOG_CHANGED')
	self:RegisterEvent('BAG_UPDATE', 'ClearArtifactCache')
end
