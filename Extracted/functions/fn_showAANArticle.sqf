/*
	Author: Karel Moricky

	Description:
	Show AAN article

	Parameter(s):
		0: ARRAY of ARRAYS - each subarray defines part of an article, can be:

			["title", <text:string>]
				Article title

			["meta", [<author:string>, <date:array Y,M,D,H,M>, <timezoneName:string>]]
				Article author and date

			["text",<text:string>]
				Paragraph

			["textbold",<text:string>]
				Bold paragraph

			["textlocked",[<text:string>,<prompt:string>]]
				Locked paragraph with subscriber prompt. There should be no paragraph after it.

			["image",[<path:string>, <description:string>, <source:string>]]
				Image with description. The image should have 2:1 ratio.

			["box",[<path:string>, <description:string>]]
				Link to another "fake" article displayed on left. The image should have 2:1 ratio.

			["author",[<path:string>, <description:string>]]
				Author's bio. The iage should have 1:1 ratio.

			["draft",[<text:string>, <color:arrayRGB>]]
				Draft notification. Text and color are optional, default notification will be shown when they're undefined.

		1: DISPLAY - parent display
		2: BOOL - true to fade from black (default: false)

	Example:
		[
			[
				["title","My Title"],
				["meta",["Catherine Bishop",[2035,2,24,11,38],"CET"]],
				["textbold","This is a bold text"],
				["image",["\a3\Missions_F_Orange\Data\Img\orange_overview_ca.paa","Some image description"]],
				["box",["\a3\Missions_F_Orange\Data\Img\Faction_IDAP_overview_CA.paa","You won't believe what playing IDAP showcase can bring you"]],
				["text","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi tincidunt pretium ultricies. Etiam ac ornare est, quis posuere nisl. Mauris facilisis lectus eu turpis maximus consequat. Donec ut metus nec risus tristique mattis. Ut posuere rutrum tellus, ut molestie orci mattis id. Cras ultrices euismod diam, in venenatis nunc commodo eget. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi congue dolor rutrum lectus euismod, ac faucibus magna molestie. Aliquam in libero sit amet eros sagittis tristique. Nam pellentesque dignissim aliquam."],
				["textlocked",["Sed non est risus. Nulla condimentum at leo sed bibendum. Phasellus laoreet sit amet leo tincidunt consequat. Curabitur nec hendrerit purus. Nam massa nisi, mattis in aliquet consectetur, ornare eget nibh. Nunc dignissim, nibh sit amet ultrices tincidunt, mi nulla fermentum quam, non condimentum dolor eros vulputate massa.","SUBSCRIBE PLZ"]],
				["author",["\a3\Missions_F_Orange\Data\Img\avatar_journalist_ca.paa","Catherine Bishop is a journalist"]]
			]
		] call bis_fnc_showAANArticle;

	Returns:
	DISPLAY
*/


params [
	["_data",[],[[]]],
	["_display",displaynull,[displaynull]],
	["_fade",false,[false]]
];

if (isnull _display) then {_display = [] call bis_fnc_displayMission;};
if (isnull _display) then {
	private _allDisplays = alldisplays select {!(ctrlidd _x in [12,56])};
	_display = _allDisplays select (count _allDisplays - 1);
};

missionnamespace setvariable ["RscDisplayOrangeArticle_data",_data];
missionnamespace setvariable ["RscDisplayOrangeArticle_fade",_fade];
_display createdisplay "RscDisplayAANArticle";