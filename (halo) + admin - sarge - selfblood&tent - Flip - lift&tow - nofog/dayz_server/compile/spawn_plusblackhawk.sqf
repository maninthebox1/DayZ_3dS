private ["_position", "_veh", "_num", "_config", "_itemType", "_itemChance", "_weights", "_index", "_iArray"];

waitUntil {!isNil "BIS_fnc_selectRandom"};

if (isDedicated) then {
	_position = [getMarkerPos "center", 0, 4000, 10, 0, 2000, 0] call BIS_fnc_findSafePos;
	_veh = createVehicle ["UH60Wreck_DZ",_position, [], 0, "CAN_COLLIDE"];
	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
	_veh setVariable ["ObjectID", 1, true];
	
	_num = round(random 4) + 3;
	
	dayzFire = [_veh, 2, time, false, false];
	publicVariable "dayzFire";
	if (isServer) then { nul = dayzFire spawn BIS_Effects_Burn; };

	_itemType =	[] + getArray (configFile >> "CfgBuildingLoot" >> "UH60Crash" >> "itemType");
	_itemChance = [] + getArray (configFile >> "CfgBuildingLoot" >> "UH60Crash" >> "itemChance");

	diag_log ("DEBUG: Spawning a UH60Wreck_DZ at " + str(_position));

	waituntil {!isnil "fnc_buildWeightedArray"};
	
	_weights = [];
	_weights = [_itemType, _itemChance] call fnc_buildWeightedArray;
	
	for "_x" from 1 to _num do {
		_index = _weights call BIS_fnc_selectRandom;
		sleep 1;
		if (count _itemType > _index) then {
			_iArray = _itemType select _index;
			_iArray set [2, _position];
			_iArray set [3, 5];
			_iArray call spawn_loot;
			_nearby = _position nearObjects ["WeaponHolder", 20];
			
			{
				_x setVariable ["permaLoot", true];
			} forEach _nearBy;
		};
	};
};