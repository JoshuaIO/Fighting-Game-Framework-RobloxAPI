# Fighting-Game-Framework-RobloxAPI
Simple fighting game framework written in Lua. This framework uses Roblox API for Physics and part Creation. This project is still being updated.

To test the project, Just open the folder and run the "Fighting Game Framework.rbxl" file.
You will need Roblox Studio installed to continue.

*UPDATE 1.01*
- Deprecated CreateHitbox Method
This method was originally used for hitbox detection, this is being deprecated due to Touched Signals in roblox being very inaccurate.
This Method will be replaced with BoundingRayBox and MagnitudeHitbox.

- Added BoundingRayBox
Bounding Raybox is my take on combining the method of "GetPartInBoundingBox()" with a Blockcast validation to check if the user is hidden behind an object.

- Added Magnitude Hitbox
Simple hitbox method that compares range with every HumanoidRootPart Detected in Workspace.
