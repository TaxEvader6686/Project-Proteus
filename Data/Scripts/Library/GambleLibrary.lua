return {
    -- "DUMMY_RANDOM_UNIT_" always has to be, "NAME" can be whatever
    -- extra_params: true or false, true to use extra params - false or no data to not use extra params 
    -- chance: 0-100
    -- min_era: 1-X
    -- max_era: 1-X
    -- dont set unused params (put nil)

    --IMPORTANT: extra params not yet coded in, will do if a group should need it

    -- ["DUMMY_RANDOM_UNIT_NAME"] = {
    --     ["Example_Unit"] = {true, 23, 2, 7},         -- 23% chance to be rolled, only available between Era 2 and 7 (including both)
    --     ["Example_Unit2"] =  {true, 75, nil, 5},     -- 75% chance to be rolled, only available til Era 5
    --     "Example_Unit3"                              -- no special params given
    -- },
    ["DUMMY_RANDOM_UNIT_RENDILI_VSD"] = {
        "Victory_I_Star_Destroyer",
        "Victory_II_Star_Destroyer",
        "Victory_II_Carrier",
        "Victory_I_Fleet_Star_Destroyer",
        "Vector_Star_Destroyer",
		"Victory_I_Star_Destroyer_Patrol",
    }, 
    ["DUMMY_RANDOM_UNIT_RENDILI_DHC"] = {
        "PDF_DHC",
        "Rep_DHC",
        "Imperial_DHC",
        "DHC_Gunboat",
        "DHC_Carrier",
        "Picket_DHC",
        "Modernized_DHC",
		"DHC_Interdictor",
		"Alliance_Assault_Frigate",
		--"Katana_DHC",
    },
    ["DUMMY_RANDOM_UNIT_RENDILI_NSBC"] = {
		"Neutron_Star",
        "Neutron_Star_Tender",
        "Neutron_Star_Mercenary",
        "Battle_Horn",
	},
    ["DUMMY_RANDOM_UNIT_RENDILI_GSD"] = {
		"Gladiator_I",
        "Gladiator_II",
        --"Gladiator_Carrier",
		--"Gladiator_Siege_Refit",
	},
}
