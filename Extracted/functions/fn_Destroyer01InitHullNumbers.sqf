/*
	Author: Bravo Zero One development
	- John_Spartan

	Description:
	- This is a sub function designed to customize ships hull numbers.

	Execution:
	- Call from vehicles config of eden attributes.

		Example:
			class CustomShipNumber1
			{
				displayName="$STR_3den_object_attribute_CustomShipNumber1_displayname";
				tooltip="$STR_3den_object_attribute_CustomShipNumber1_tooltip";
				property="CustomShipNumber1";
				control="EditShort";
				expression="[([_this, 'Land_Destroyer_01_hull_01_F'] call bis_fnc_destroyer01GetShipPart), _value, 0] spawn bis_fnc_destroyer01InitHullNumbers;";
				defaultValue="0";
				validate = "number";
				condition = "object";
				typeName = "NUMBER";
			};

	Required:
		Object (ship) must have predefined hidden selections for hull number. Pass object of ship part component which contains numbered selections.

	Parameter(s):
		_this select 0: mode (Scalar)
		0: ship-part object
		and
		1: number that should be displayed on the selection
		2: selection number

	Returns: nothing
	Result: Ship's hull number is set to specified number.

*/
if (!isServer) exitWith {};

private _shipPart = param [0, objNull];
private _number = param [1, 0];
private _selection = param [2, 0];

_shipPart setObjectTextureGlobal [_selection, (format ["\A3\Boat_F_Destroyer\Destroyer_01\Data\Destroyer_01_N_0%1_co.paa",_number])];
