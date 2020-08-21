/*
NNS
Not Mario Kart Knockoff
Compute and return angle difference.
*/

abs (abs ((((_this select 0) - (_this select 1)) + 180) mod 360) - 180); //return angle difference