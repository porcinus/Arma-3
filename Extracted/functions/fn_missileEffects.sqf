private _projectile = _this param [0, objNull, [objNull]];
if (isNull _projectile) exitWith {"Provided _projectile is NULL" call BIS_fnc_error};

private _light = "#lightpoint" createVehicleLocal getPos _projectile;
if (isNull _light) exitWith {"Unable to create light source" call BIS_fnc_error};

_light setLightBrightness 10.0;
_light setLightAmbient [1.0, 0.2, 0.0];
_light setLightColor [1.0, 0.2, 0.0];
//_light setLightIntensity 4;
//_light setLightAttenuation [2,4,4,0,9,10];
_light setLightUseFlare true;
_light setLightFlareSize 2;
_light setLightFlareMaxDistance 500;
_light setLightDayLight true;

_light lightAttachObject [_projectile, [0,0,0]];

waitUntil {isNull _projectile};

deleteVehicle _light;