# pyhula

A Python package used by hula.

## Installing

Input the following code in PowerShell (cmd.exe) to install `pyhula`:

```sh
pip install pyhula
pip install pyhula-1.1.7-cp36-cp36m-win_amd64.whl
```

## Checking version

Input `pip list` in PowerShell (cmd.exe) to get pyhula's version.

```python
import pyhula
ver = pyhula.get_version()
print(ver)
```

## Usage

Use the following code to create a `UserApi` instance. Its interfaces can be used to control the fylo plane.  
Go to `doc/html/English/index.html` to see the interface specification.

**Python version:** 3.6.7

```python
import pyhula
api = pyhula.UserApi()
if not api.connect():
    print("connect error")
else:
    print('connection to station by wifi')
```

---

readmewhl.md 2024-07-09

---

## Interface

### Connected drone

#### Takeoff

```python
api.single_fly_takeoff()      # Takeoff
api.single_fly_touchdown()    # Landing
```

#### connect(server_ip)

```python
# description:
#   Connect drone.
# parameter:
#   optional: server_ip: If the drone IPv4 address is not specified,
#   the return value is automatically obtained:
#   True: True, False: False
```

Example code:

```python
api.connect('192.168.1.118')
api.connect()
```

#### single_fly_takeoff(led)

```python
# description:
#   Control drone takeoff in real time
# parameter:
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on,
#   2/ light off, 4/ RGB cycle light, 16/ colorful light,
#   32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_takeoff()
api.single_fly_takeoff({'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Fly_backward  
### Fly to left

#### single_fly_left(distance, speed, led)

```python
# description:
#   Control drone fly to left in real time
# parameter:
#   distance: Flight distance (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_left(100)
api.single_fly_left(100, 100, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_back(distance, speed, led)

```python
# description:
#   Control drone fly_backward in real time
# parameter:
#   distance: Flight distance (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_back(100)
api.single_fly_back(100, 100, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Fly to right  
### Fly_up  
### Fly_down

#### single_fly_right(distance, speed, led)

```python
# description:
#   Control drone fly to right in real time
# parameter:
#   distance: Flight distance (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_right(100)
api.single_fly_right(100, 100, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_up(distance, speed, led)

```python
# description:
#   Control drone fly_up in real time
# parameter:
#   height: Flight height (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_up(100)
api.single_fly_up(100, 100, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Turn left  
### Turn right  
### Bounce

#### single_fly_down(distance, speed, led)

```python
# description:
#   Control drone fly_down in real time
# parameter:
#   height: Flight height (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_down(100)
api.single_fly_down(100, 100, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_turnleft(angle, led)

```python
# description:
#   Control drone turn left in real time
# parameter:
#   angle: Rotation Angle (degree)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_turnleft(90)
api.single_fly_turnleft(90, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_turnright(angle, led)

```python
# description:
#   Control drone turn right in real time
# parameter:
#   angle: Rotation Angle (degree)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_turnright(90)
api.single_fly_turnright(90, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

#### single_fly_bounce(frequency, height, led)

```python
# description:
#   Control drone bounce in real time
# parameter:
#   frequency: Bounce times
#   height: Bounce distance (cm)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_bounce(3, 50)
api.single_fly_bounce(3, 50, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Straight_flight  
### Flight around

#### single_fly_straight_flight(x, y, z, speed, led)

```python
# description:
#   straight_flight to co-ordinate (x, y, z)
# parameter:
#   x: co-ordinate x (cm)
#   y: co-ordinate y (cm)
#   z: co-ordinate z (cm)
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_straight_flight(100, 100, 100)
api.single_fly_straight_flight(100, 100, 100, 50, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_radius_around(radius, led)

```python
# description:
#   Flight around a point ahead of the plane
# parameter:
#   radius: radius (cm, positive: anticlockwise, negative: clockwise)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_radius_around(100)
api.single_fly_radius_around(100, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Autogyration  
### Somersault

#### single_fly_somersault(direction)

```python
# description:
#   The drone forward, backward, left or right somersault
# parameter:
#   DIRECTION_FORWARD = 0  # forward
#   DIRECTION_BACK = 1     # back
#   DIRECTION_LEFT = 2     # left
#   DIRECTION_RIGHT = 3    # right
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_somersault(0)
api.single_fly_somersault(0, {'r':16,'g':15,'b':100,'mode':1})
```

#### single_fly_autogyration360(num, led)

```python
# description:
#   Clockwise, counterclockwise rotation a certain number of turns
# parameter:
#   num: (positive: anticlockwise, negative: clockwise)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_autogyration360(2)
api.single_fly_autogyration360(2, {'r':16,'g':15,'b':100,'mode':1})
```

---

readmewhl.md 2024-07-09

---

### Curvilinear Flight

#### single_fly_curvilinearFlight(x, y, z, speed, led)

```python
# description:
#   Curvilinear flight to (x, y, z)
# parameter:
#   x: x co-ordinate (cm) (Body left and right, right is positive)
#   y: y co-ordinate (cm) (Front and back of the body, front is positive)
#   z: z co-ordinate (cm) (Body up and down, up is positive)
#   direction: True: anticlockwise, False: clockwise, Default: True
#   speed: If left blank, it will default to 100 speed (0-100cm/s)
#   led: The default value is 0,
#   format: {'r':0,'g':0,'b':0,'mode':1}
#   r,g,b: color gamut, mode: 1/ light on, 2/ light off, 4/ RGB cycle light,
#   16/ colorful light, 32/ blink light, 64/ breathing light
```

Example code:

```python
api.single_fly_curvilinearFlight(100, 100, 0, True, 50)
api.single_fly_curvilinearFlight(100, 100, 0, False, 50, {'r':16,'g':15,'b':100,'mode':1})
```

---

## Optical Flow and QR Code Recognition

### Optical Flow Recognition QR Code

#### single_fly_Optical_flow_recognition(qr_id, qr_size)

```python
# description:
#   Optical flow recognition QR code
# parameter:
#   qr_id: QR code id [0-9]
#   qr_size: The physical size of the QR code, range [6, 30], default value 20 (unit: cm)
# return:
#   {
#     result: False (failed), True (succeed)
#     x: Distance between the drone and the QR code
#     y: Distance between the drone and the QR code
#     z: Distance between the drone and the QR code
#     yaw: Angle between the drone and the QR code
#     qr_id: Identified QR code id
#   }
```

Example code:

```python
api.single_fly_recognition_Qrcode(0, 1)
```

### Front Camera Align QR Code

#### single_fly_Proactive_alignment(qr_id)

```python
# description:
#   Front camera align QR code
# parameter:
#   qr_id: QR code id [0-9]
# return:
#   result: False (failed), True (succeed)
```

Example code:

```python
api.single_fly_Proactive_alignment(1)
```

### Front Camera Recognition QR Code

#### single_fly_Anticipatory_recognition(qr_id)

```python
# description:
#   Front camera recognition QR code
# parameter:
#   qr_id: QR code id [0-9]
# return:
#   {
#     result: False (failed), True (succeed)
#     x: Distance between the drone and the QR code
#     y: Distance between the drone and the QR code
#     z: Distance between the drone and the QR code
#     yaw: Angle between the drone and the QR code
#     qr_id: Identified QR code id
#   }
```

Example code:

```python
api.single_fly_Anticipatory_recognition(1)
```

### Track QR Code

#### single_fly_track_Qrcode(qr_id, time)

```python
# description:
#   Track QR code [0-9] for [time] seconds
# parameter:
#   qr_id: QR code id
#   time: Tracking time (seconds)
# return:
#   result: 0 (failed), 1 (succeed)
```

Example code:

```python
api.single_fly_track_Qrcode(1, 10)
```

---

## Color Recognition and Lighting

### Color Recognition

#### single_fly_getColor()

```python
# description:
#   Color recognition, get the color of the current video stream frame
# parameter:
#   Mode: 1 (Run a frame)
# return:
#   r, g, b: color gamut
#   state: 0 (failed), 1 (succeed)
```

Example code:

```python
ret = api.single_fly_getColor()  # return: r, g, b: color gamut, state: 0 failed, 1 succeed
```

### Set Light Color and Mode

#### single_fly_lamplight(r, g, b, time, mode)

```python
# description:
#   Set light color and mode (does not block the main thread)
# parameter:
#   r, g, b: color gamut
#   time: duration (seconds)
#   mode: 1 (light on), 2 (light off), 4 (RGB cycle light), 16 (colorful light), 32 (blink light), 64 (breathing light)
```

Example code:

```python
api.single_fly_lamplight(255, 0, 0, 1, 1)  # Set light color and mode
```

---

## Lasing and Laser Receiver

### Lasing

#### plane_fly_generating(type, data, reserve)

```python
# description:
#   Lasing
# parameter:
#   type: 0 (single shot), 1 (keep shooting), 2 (turn on laser receiver), 3 (turn off laser receiver), 4 (keep firing), 5 (turn off laser)
#   data: frequency, times/s, range 1-14
#   reserve: Laser gap, range 1-255
```

Example code:

```python
api.plane_fly_generating(0, 10, 100)  # single shot
api.plane_fly_generating(2, 10, 100)  # turn on the laser receiver
```

### Laser Receiver Been Hit

#### plane_fly_laser_receiving()

```python
# description:
#   Laser receiver been hit
# return:
#   True: Received laser
#   False: No laser was received
```

Example code:

```python
api.plane_fly_laser_receiving()
```

---

## Positioning and Video

### Positioning QR Code Switch

#### Plane_cmd_switch_QR(type)

```python
# description:
#   Positioning QR code switch
# parameter:
#   type: 0 (turn on), 1 (turn off)
```

Example code:

```python
api.Plane_cmd_switch_QR(0)
```

### Take Photo

#### Plane_fly_take_photo()

```python
# description:
#   Before taking pictures, the video stream must be turned on
```

Example code:

```python
api.Plane_fly_take_photo()  # shot
```

### Recording

#### Plane_cmd_switch_video(type)

```python
# description:
#   Start recording
# parameter:
#   type: 0 (start), 1 (end)
```

Example code:

```python
api.Plane_cmd_switch_video(0)  # start recording
```

### Video Stream Turn On

#### Plane_cmd_swith_rtp(type)

```python
# description:
#   Video stream turn on
# parameter:
#   type: 0 (turn on), 1 (turn off)
```

Example code:

```python
api.Plane_cmd_swith_rtp(0)  # video stream turn on
```

### Open Video Stream Window

#### single_fly_flip_rtp()

```python
# description:
#   Open the video stream window (the video stream must be turned on)
```

Example code:

```python
api.single_fly_flip_rtp()  # Open the video stream window
```

### Set Front Camera Tilt Angle

#### Plane_cmd_camera_angle(type, data)

```python
# description:
#   Set the front camera tilt angle
# parameter:
#   type: 0 (up), 1 (down absolutely), 2/3 (algorithm control), 4 (calibration), 5 (scratch block up), 6 (scratch block down relatively)
#   data: Angle range 0~90
```

Example code:

```python
api.Plane_cmd_camera_angle(0, 30)  # Set the front camera tilt angle
```

---

## Propeller and Obstacle Avoidance

### Unlock/Lock Low Speed Propeller

#### plane_fly_arm()

```python
# description:
#   Unlock drone motor propeller
```

Example code:

```python
api.plane_fly_arm()  # Low speed propeller
```

#### plane_fly_disarm()

```python
# description:
#   Turn off drone motor
```

Example code:

```python
api.plane_fly_disarm()  # Lock the low speed propeller
```

### Get Obstacle Avoidance Direction Information

#### Plane_getBarrier()

```python
# description:
#   Get obstacle avoidance direction information
# return:
#   Dictionary: Obstacle status in each direction
#   True: There is an obstacle, False: No obstacle
#   {
#     'forward': True,
#     'back': True,
#     'left': True,
#     'right': True,
#   }
```

Example code:

```python
ret = api.Plane_getBarrier()  # Get obstacle avoidance direction information
```

---

## Drone Status and Sensors

### Get Drone Battery Percentage

#### get_battery()

```python
# description:
#   Get drone battery percentage
# return:
#   Integer: battery percentage
```

Example code:

```python
ret = api.get_battery()  # Get drone battery percentage
```

### Get Drone Coordinates

#### get_coordinate()

```python
# description:
#   Get drone coordinates [x, y, z]
# return:
#   [x, y, z]
```

Example code:

```python
ret = api.get_coordinate()  # Get drone coordinates [x, y, z]
```

### Get Drone Angle

#### get_yaw()

```python
# description:
#   Get drone angle (degree)
# return:
#   Integer: [yaw angle, pitch angle, roll angle]
```

Example code:

```python
ret = api.get_yaw()
```

### Get Drone Speed

#### get_plane_speed()

```python
# description:
#   Get drone speed (X axis, Y axis, Z axis)
# return:
#   Integer: [X, Y, Z]
```

Example code:

```python
ret = api.get_plane_speed()
```

### Get Drone Tof Height Value

#### get_plane_distance()

```python
# description:
#   Get the drone Tof height value
# return:
#   Integer: drone Tof height value
```

Example code:

```python
ret = api.get_plane_distance()
```

### Get Drone ID

#### get_plane_id()

```python
# description:
#   Get drone ID
# return:
#   Integer: drone ID
```

Example code:

```python
ret = api.get_plane_id()
```

---

## External Devices

### External Electromagnet

#### Plane_cmd_electromagnet(type)

```python
# description:
#   External electromagnet
# parameter:
#   type: 2 (Electromagnet attracts), 3 (Electromagnet pops out)
```

Example code:

```python
ret = api.Plane_cmd_electromagnet(2)
```

### External Clamp

#### Plane_cmd_clamp(type, angle)

```python
# description:
#   External clamp
# parameter:
#   type: 0 (Clamp disable), 1 (Clamp enable), 2 (Clamp angle), 3 (Electromagnet pops out), 4 (Electromagnet attracts)
#   angle: (for type 2) Clamp angle in degrees
```

Example code:

```python
api.Plane_cmd_clamp(0)        # Clamp disable
api.Plane_cmd_clamp(1)        # Clamp enable
api.Plane_cmd_clamp(2, 30)    # Enable clamp, then set angle to 30 degrees
api.Plane_cmd_clamp(3)        # Electromagnet pops out
api.Plane_cmd_clamp(4)        # Electromagnet attracts
```

---
