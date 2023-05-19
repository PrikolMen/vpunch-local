local Clamp
Clamp = math.Clamp
local PUNCH_DAMPING, PUNCH_SPRING_CONSTANT = 9, 65
local PunchAngle = Angle()
local Velocity = Angle()
local LastAngle = PunchAngle
hook.Add('Think', tostring(_PKG), function()
  if not (PunchAngle:IsZero() and Velocity:IsZero()) then
    local ft = FrameTime()
    PunchAngle = PunchAngle + Velocity * ft
    local damping = 1 - (PUNCH_DAMPING * FrameTime())
    if damping < 0 then
      damping = 0
    end
    Velocity = Velocity * damping
    local spring_force_magnitude = Clamp(PUNCH_SPRING_CONSTANT * ft, 0, .2 / ft)
    Velocity = Velocity - PunchAngle * spring_force_magnitude
    local x, y, z = PunchAngle:Unpack()
    PunchAngle = Angle(Clamp(x, -89, 89), Clamp(y, -179, 179), Clamp(z, -89, 89))
  else
    PunchAngle = Angle()
    Velocity = Angle()
  end
  if PunchAngle:IsZero() and Velocity:IsZero() then
    return 
  end
  local lp = LocalPlayer()
  if lp:InVehicle() then
    return 
  end
  lp:SetEyeAngles(lp:EyeAngles() + PunchAngle - LastAngle)
  LastAngle = PunchAngle
end)
return {
  PunchAngle = PunchAngle,
  Velocity = Velocity,
  LastAngle = LastAngle,
  SetAngles = function(self, ang)
    if ang == nil then
      ang = Angle()
    end
    PunchAngle = ang
  end,
  SetVelocity = function(self, ang)
    if ang == nil then
      ang = Angle()
    end
    Velocity = ang * 20
  end,
  Punch = function(self, ang)
    if ang == nil then
      ang = Angle()
    end
    Velocity = Velocity + ang * 20
  end
}
