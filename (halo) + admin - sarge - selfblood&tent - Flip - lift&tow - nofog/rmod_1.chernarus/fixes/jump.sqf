player action [ "eject", vehicle player];
sleep 1;
player removeWeapon "ParachuteWest";
sleep 0.1;
player spawn bis_fnc_halo;
player setvelocity [0,120*0.8,0];
player setdir 0;