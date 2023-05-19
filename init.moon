import Clamp from math

PUNCH_DAMPING, PUNCH_SPRING_CONSTANT = 9, 65
PunchAngle  = Angle!
Velocity    = Angle!
LastAngle   = PunchAngle

hook.Add 'Think', tostring(_PKG), ->
    --decays viewpunch
    unless PunchAngle\IsZero! and Velocity\IsZero!
        ft = FrameTime!
        PunchAngle = PunchAngle + Velocity * ft
        damping = 1 - (PUNCH_DAMPING * FrameTime!)
        damping = 0 if damping < 0
        Velocity = Velocity * damping
        spring_force_magnitude = Clamp PUNCH_SPRING_CONSTANT * ft, 0, .2 / ft
        Velocity = Velocity - PunchAngle * spring_force_magnitude
        x, y, z = PunchAngle\Unpack!
        PunchAngle = Angle Clamp(x, -89, 89), Clamp(y, -179, 179), Clamp(z, -89, 89)
    else
        PunchAngle = Angle!
        Velocity = Angle!
    --applies viewpunch
    return if PunchAngle\IsZero! and Velocity\IsZero!
    lp = LocalPlayer!
    return if lp\InVehicle!
    lp\SetEyeAngles lp\EyeAngles! + PunchAngle - LastAngle
    LastAngle = PunchAngle

{
    :PunchAngle
    :Velocity
    :LastAngle
    SetAngles:      (ang=Angle!)   => PunchAngle    = ang
    SetVelocity:    (ang=Angle!)   => Velocity      = ang * 20
    Punch:          (ang=Angle!)   => Velocity      = Velocity + ang * 20
}