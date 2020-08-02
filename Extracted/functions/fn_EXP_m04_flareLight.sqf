params ["_light", "_flare"];

// Determine color RGB
private _colorArray = [0.2,0.2,0.2];
if (typeOf _flare == "F_20mm_Red_Infinite") then {_colorArray = [0.25,0,0]};

// Configure light
_light setLightBrightness 2;
_light setLightColor _colorArray;
_light setLightAmbient _colorArray;
_light setLightAttenuation [200, 10, 0.0001, 0.05];
_light setLightDayLight false;
_light setLightUseFlare false;

// Pulse light like a flare
private _limit = 1500;
_light setLightIntensity _limit;

while {!(isNull _light)} do {
	// Randomize intensity
	private _intensity = _limit - (random 300);
	_light setLightIntensity _intensity;

	// Small delay
	private _time = time + (0.01 + random 0.02);
	waitUntil {time >= _time || { isNull _light }};
};

true