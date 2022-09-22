# Prisma
A flexible Character System that can be integrated in any Framework

## Why Prisma?
Prisma is an easy plug-and-play framework that you can easily integrate with a few lines of code.
It supports visuals and physics similar to Minecraft and Quake Engine respectively.

## Features
* Head Facing Mouse or Camera
* Arm following Mouse or Camera while tool is equipped
* Torso lag (Minecraft like)
* Acceleration and Deceleration (TBA)
* Bunny hopping (TBA)
* Fall Damage (TBA)

# API
## Client Functions
**:ToggleMouseTracking(Enabled: *boolean*)**

If set to true, the head and other moving limbs follow the mouse instead of the camera.

---

**:ToggleTorsoLag(Enabled: *boolean*)**

If set to true, disables Humanoid.AutoRotate and enables the torso movement thing. (I don't know what it's called)
<br>Else, it reenables AutoRotate, skipping all calculations.

---

**:ToggleArms(Left: *boolean*, Right: *boolean*)**
**:ToggleLeftArm(Enabled: *boolean*)** or **:ToggleRightArm(Enabled: *boolean*)**

Enables respective arms

# Credits
Authored/Co-Authored by: [Me](https://github.com/reimakesgames/) and [Synthranger_](https://github.com/synthranger/)
