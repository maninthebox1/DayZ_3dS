private ["_hcx", "_helicrash", "_veh", "_num", "_config", "_itemType", "_itemChance", "_weights", "_index", "_iArray", "_wpos", "_lootpos"];

waitUntil {!isNil "BIS_fnc_selectRandom"};

if (isDedicated) then {
	_hcx = _this select 0;
	_helicrash = [0, 0, 0];

	switch (_hcx) do {
		case 1: { _helicrash = ([4210.79,8913.34,0] nearestObject "Land_mi8_crashed"); };
		case 2: { _helicrash = ([5433.65,9282.45,0] nearestObject "Land_mi8_crashed"); };
		case 3: { _helicrash = ([5645.02,7973.14,0] nearestObject "Land_mi8_crashed"); };
		case 4: { _helicrash = ([5363.63,7161.82,0] nearestObject "Land_mi8_crashed"); };
		case 5: { _helicrash = ([2814.39,6391.89,0] nearestObject "Land_mi8_crashed"); };
		case 6: { _helicrash = ([4335.19,6424.07,0] nearestObject "Land_mi8_crashed"); };
		case 7: { _helicrash = ([4073.73,6457.54,0] nearestObject "Land_mi8_crashed"); };
		case 8: { _helicrash = ([5496.03,5985.08,0] nearestObject "Land_mi8_crashed"); };
		case 9: { _helicrash = ([3189.98,7507.8 ,0] nearestObject "Land_wreck_c130j_ep1"); };
		default { diag_log("ERROR: Cannot spawn helicrash loot (objNull)!"); };
	};
	
	diag_log ("DEBUG: Spawning a crashed helicopter at " + str(getPos _helicrash));

	_config = 		configFile >> dayzNam_buildingLoot >> "HeliCrashNamalsk";
	_itemType =		[] + getArray (_config >> "itemType");
	_itemChance =	[] + getArray (_config >> "itemChance");
	
	waituntil {!isnil "fnc_buildWeightedArray"};
	
	_weights = [];
	_weights = [_itemType, _itemChance] call fnc_buildWeightedArray;
	_lootpos = [] + getArray (configFile >> dayzNam_buildingLoot >> (typeOf _helicrash) >> "lootPos");

	if (_helicrash != objNull) then {
		for "_x" from 1 to (count _lootpos) do {
			_wpos = _helicrash modelToWorld (_lootpos select (_x - 1));
			_index = _weights call BIS_fnc_selectRandom;
			sleep 1;
			if (count _itemType > _index) then {
				_iArray = _itemType select _index;
				_iArray set [2, _wpos];
				_iArray set [3, 5];
				_iArray call spawn_loot;
				_nearby = _wpos nearObjects ["WeaponHolder", 20];
				
				{
					_x setVariable ["permaLoot",true];
				} forEach _nearBy;
			};
		};
	};
};