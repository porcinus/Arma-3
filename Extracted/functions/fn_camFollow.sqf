#define CAMUPDATE \
	private ["_fov"];\
	_distance = _camera distance _cameraTarget;\
	_fov = (10 / (_distance)) min 0.7 max 0.01;\
	_camera campreparetarget _cameraTarget;\
	_camera campreparefov _fov;

private ["_camera","_cameraTarget","_refresh"];
_camera =	_this param [0,objnull,[objnull]];
_cameraTarget =	_this param [1,objnull,[objnull,[]],[2,3]];
_refresh =	_this param [2,1,[1]];

if (_refresh < 0) then {
	_refresh = abs _refresh;
	while {!isnull _camera} do {
		CAMUPDATE
		_camera camcommitprepared _refresh;
		sleep _refresh;
	};
} else {
	CAMUPDATE
	_camera camCommitPrepared _refresh;
};