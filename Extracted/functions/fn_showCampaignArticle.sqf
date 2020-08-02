disableserialization;

params [
	["_Orange_AirDrop",-1,[0]],
	["_Orange_Leaflets",-1,[0]],
	["_Orange_Cluster",-1,[0]],
	["_Orange_Escape",-1,[0]],
	["_Orange_MineDispenser",-1,[0]],
	["_choice",-1,[0]]
];

//--- Use Steam stats
if (_Orange_AirDrop < 0 && {		([getstatvalue "OrangeCampaignAirDropDecisionB"] param [0,-1]) == 1		}) then {_Orange_AirDrop = 1;};
if (_Orange_Leaflets < 0 && {		([getstatvalue "OrangeCampaignLeafletsDecisionB"] param [0,-1]) == 1		}) then {_Orange_Leaflets = 1;};
if (_Orange_Cluster < 0 && {		([getstatvalue "OrangeCampaignClusterDecisionB"] param [0,-1]) == 1		}) then {_Orange_Cluster = 1;};
if (_Orange_Escape < 0 && {		([getstatvalue "OrangeCampaignEscapeDecisionB"] param [0,-1]) == 1		}) then {_Orange_Escape = 1;};
if (_Orange_MineDispenser < 0 && {	([getstatvalue "OrangeCampaignMineDispenserDecisionB"] param [0,-1]) == 1	}) then {_Orange_MineDispenser = 1;};
if (_choice < 0) then {
	switch true do {
		case (([getstatvalue "OrangeCampaignArticleDecisionA"] param [0,-1]) == 1): {_choice = 0;};
		case (([getstatvalue "OrangeCampaignArticleDecisionB"] param [0,-1]) == 1): {_choice = 1;};
		case (([getstatvalue "OrangeCampaignArticleDecisionC"] param [0,-1]) == 1): {_choice = 2;};
		case (([getstatvalue "OrangeCampaignArticleDecisionD"] param [0,-1]) == 1): {_choice = 3;};
		//--- No need to check DecisionE, it's used as default
	};
};
_Orange_AirDrop call bis_fnc_log;

//--- Use profile var when Steam stats are not available for some reason
private _profileDecisions = profilenamespace getvariable ["BIS_Orange_Decisions",[]];
if (_Orange_AirDrop < 0) then {		_Orange_AirDrop = _profileDecisions param [0,-1];	};
if (_Orange_Leaflets < 0) then {	_Orange_Leaflets = _profileDecisions param [1,-1];	};
if (_Orange_Cluster < 0) then {		_Orange_Cluster = _profileDecisions param [2,-1];	};
if (_Orange_Escape < 0) then {		_Orange_Escape = _profileDecisions param [3,-1];	};
if (_Orange_MineDispenser < 0) then {	_Orange_MineDispenser = _profileDecisions param [4,-1];	};
if (_choice < 0) then {			_choice = _profileDecisions param [5,-1];		};

//--- Not finished campaign yet - show paywalled article
if ({_x < 0} count [_Orange_AirDrop,_Orange_Leaflets,_Orange_Cluster,_Orange_Escape,_Orange_MineDispenser,_choice] > 0 && missionname != "Orange_Hub") exitwith {

	private _display = [
		[
			[
				"title",
				localize "STR_A3_Orange_Campaign_briefingName"
			],
			[
				"meta",
				[
					localize "STR_A3_Orange_Campaign_CfgIdentities_Journalist_name",
					[2035,8,27,14,42]
				]
			],
			[
				"textbold",
				localize "STR_A3_Orange_AAN_bold_1"
			],
			[
				"image",
				[
					"\a3\Missions_F_Orange\Data\Img\AAN\aan_0_co.paa",
					localize "STR_A3_Orange_AAN_image_1"
				]
			],
			["text",localize "STR_A3_Orange_AAN_text_1"],
			["text",localize "STR_A3_Orange_AAN_text_2"],
			["text",localize "STR_A3_Orange_AAN_text_3"],
			["text",localize "STR_A3_Orange_AAN_text_4"],
			["textlocked",localize "STR_A3_Orange_AAN_text_5",localize "str_a3_orange_aan_paywall"],
			[
				"author",
				[
					"\a3\Missions_F_Orange\Data\Img\avatar_journalist_ca.paa",
					localize "STR_A3_Orange_AAN_author"
				]
			]
		]
	] call bis_fnc_showAANArticle;
	waituntil {isnull _display};
};

//--- Full article
private _display = [
	[
		["title",localize "STR_A3_Orange_Campaign_briefingName"],
		["meta",[localize "STR_A3_Orange_Campaign_CfgIdentities_Journalist_name",[2035,8,27,14,42]]],

		["textbold",localize "STR_A3_Orange_AAN_bold_1"],
		["image",["\a3\Missions_F_Orange\Data\Img\AAN\aan_0_co.paa",localize "STR_A3_Orange_AAN_image_1"]],
		["box",["\a3\Missions_F_Orange\Data\Img\AAN\aan_box_0_co.paa",localize "STR_A3_Orange_AAN_box_1"]],
		["text",localize "STR_A3_Orange_AAN_text_1"],
		["text",localize "STR_A3_Orange_AAN_text_2"],
		["text",localize "STR_A3_Orange_AAN_text_3"],
		["text",localize "STR_A3_Orange_AAN_text_4"],
		["text",localize "STR_A3_Orange_AAN_text_5"],

		//--- Orange_AirDrop
		[
			"text",
			localize (if (_Orange_AirDrop == 1) then {"STR_A3_Orange_AAN_text_AirDrop_1"} else {"STR_A3_Orange_AAN_text_AirDrop_0"})
		],
		["text",localize "STR_A3_Orange_AAN_text_6"],
		["text",localize "STR_A3_Orange_AAN_text_7"],

		//--- Orange_Leaflets
		[
			"image",
			if (_Orange_Leaflets == 1) then {
				["\a3\Missions_F_Orange\Data\Img\AAN\aan_1_0_co.paa",localize "STR_A3_Orange_AAN_image_AirDrop_1"]
			} else {
				["\a3\Missions_F_Orange\Data\Img\AAN\aan_1_1_co.paa",localize "STR_A3_Orange_AAN_image_AirDrop_0"]
			}
		],
		[
			"text",
			localize (if (_Orange_Leaflets == 1) then {"STR_A3_Orange_AAN_text_Leaflets_1"} else {"STR_A3_Orange_AAN_text_Leaflets_0"})
		],
		["text",localize "STR_A3_Orange_AAN_text_8"],
		["box",["\a3\Missions_F_Orange\Data\Img\AAN\aan_box_1_co.paa",localize "STR_A3_Orange_AAN_box_2"]],
		["text",localize "STR_A3_Orange_AAN_text_9"],

		//--- Orange_Cluster
		[
			"text",
			(localize "STR_A3_Orange_AAN_text_10") + " " + localize (if (_Orange_Cluster == 1) then {"STR_A3_Orange_AAN_text_Cluster_1"} else {"STR_A3_Orange_AAN_text_Cluster_0"})
		],
		["text",localize "STR_A3_Orange_AAN_text_11"],

		//--- Orange_Escape
		[
			"image",
			if (_Orange_Escape == 1) then {
				["\a3\Missions_F_Orange\Data\Img\AAN\aan_2_0_co.paa",localize "STR_A3_Orange_AAN_image_Escape_1"]
			} else {
				["\a3\Missions_F_Orange\Data\Img\AAN\aan_2_1_co.paa",localize "STR_A3_Orange_AAN_image_Escape_0"]
			}
		],

		[
			"text",
			localize (if (_Orange_Escape == 1) then {"STR_A3_Orange_AAN_text_Escape_1"} else {"STR_A3_Orange_AAN_text_Escape_0"})
		],
		["box",["\a3\Missions_F_Orange\Data\Img\AAN\aan_box_2_co.paa",localize "STR_A3_Orange_AAN_box_3"]],
		["text",localize "STR_A3_Orange_AAN_text_12"],

		//--- Orange_MineDispenser
		[
			"text",
			(localize "STR_A3_Orange_AAN_text_13") + " " + localize (if (_Orange_MineDispenser == 1) then {"STR_A3_Orange_AAN_text_MineDispenser_1"} else {"STR_A3_Orange_AAN_text_MineDispenser_0"})
		],

		//--- Choice
		[
			"image",
			switch _choice do {
				case 0: {["\a3\Missions_F_Orange\Data\Img\AAN\aan_3_0_co.paa",localize "STR_A3_Orange_AAN_image_Choice_0"]};
				case 1: {["\a3\Missions_F_Orange\Data\Img\AAN\aan_3_1_co.paa",localize "STR_A3_Orange_AAN_image_Choice_1"]};
				case 2: {["\a3\Missions_F_Orange\Data\Img\AAN\aan_3_2_co.paa",localize "STR_A3_Orange_AAN_image_Choice_2"]};
				case 3: {["\a3\Missions_F_Orange\Data\Img\AAN\aan_3_3_co.paa",localize "STR_A3_Orange_AAN_image_Choice_3"]};
				default {["\a3\Missions_F_Orange\Data\Img\AAN\aan_3_4_co.paa",localize "STR_A3_Orange_AAN_image_Choice_4"]};
			}
		],
		[
			"text",
			switch _choice do {
				case 0: {localize "STR_A3_Orange_AAN_text_Choice_0"};
				case 1: {localize "STR_A3_Orange_AAN_text_Choice_1"};
				case 2: {localize "STR_A3_Orange_AAN_text_Choice_2"};
				case 3: {localize "STR_A3_Orange_AAN_text_Choice_3"};
				default {localize "STR_A3_Orange_AAN_text_Choice_4"};
			}
		],
		["text",localize "STR_A3_Orange_AAN_text_14"],

		//--- Author
		[
			"author",
			[
				"\a3\Missions_F_Orange\Data\Img\avatar_journalist_ca.paa",
				localize "STR_A3_Orange_AAN_author"
			]
		],
		if (missionname == "Orange_Hub") then {["draft"]} else {[]}
	],
	nil,
	true
] call bis_fnc_showAANArticle;

playsound "Orange_Read_Article";

waituntil {isnull _display};