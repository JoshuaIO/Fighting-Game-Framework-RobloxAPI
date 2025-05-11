local physicsService = game:GetService("PhysicsService")
local collisionGroupPlayer = "PlayerCollision"
local collisionGroupHitPlayer = "HitPlayerCollision"
local collisionRayGroup = "RayGroup"

physicsService:RegisterCollisionGroup(collisionGroupPlayer)
physicsService:RegisterCollisionGroup(collisionGroupHitPlayer)
physicsService:RegisterCollisionGroup(collisionRayGroup)

physicsService:CollisionGroupSetCollidable(collisionGroupHitPlayer,collisionRayGroup,false)

