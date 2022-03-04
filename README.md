# arena-tools
A collection of tools to make working with [Arena-Rosnav-3D](https://github.com/ignc-research/arena-rosnav-3D/) easier. It currently includes:
- Scenario Editor
- Flatland Model Editor
- Map Generator (2D)
- Map to Gazebo world converter (3D)

## Prerequisites
- Python 3.6 or higher
- preferably virtual environment [rosnav] from [arena-rosnav-3d](https://github.com/ignc-research/arena-rosnav-3D/tree/main/docs/Installation.md)

## Installation
You can use the bash script to install the neccessary python packages and the git repository to enable compatibility with arena-rosnav-3d
```bash
chmod +x install.sh && ./install.sh     # make script executable and execute
```

If you have problems with the installation, we recommend to step through the [installation script](./install.sh) by hand.

# Run
To start the gui and select your task, run:
```bash
roscd arena-tools
python arena_tools.py
```
## Map Generator
How to create a custom map blueprint like shown here:


https://user-images.githubusercontent.com/74921738/130034174-fa6b334b-e220-47ea-91ba-4bc815663ae5.mov



1. Map Generator is a tool to generate random ROS maps. Firstly select map generator in the *arena-tools* menue. Or run `python MapGenerator.py`

> **NOTE:**
>- Maps can be either an indoor or an outdoor type map. For **indoor** maps you can adjust the **Corridor With** and number of **Iterations**. For **outdoor** maps you can adjust the number of **Obstacles** and the **Obstacle Extra Radius**.
>- Generate maps in bulk by setting **Number of Maps**
>- Each map will be saved in its own folder. Folders will be named like "map[number]". [number] will be incremented starting from the highest number that already exists in the folder, so as not to overwrite any existing maps.

2. To convert the 2D maps into 3D Gazebo worlds:
![Screenshot from 2021-10-25 23-42-46](https://user-images.githubusercontent.com/41898845/138775328-6609cd98-cf5f-4942-aa3d-bcf9314a5714.png)
Press the button **Convert existing maps into Gazebo worlds** and all of the maps in subfolder map_ will be automatically converted into Gazebo worlds, as well as their respective Pedsim scene obstacles file will be generated and placed under **simulator_setup/scenarios/ped_scenarios/map_{i}.xml**.
\
When you see an output like the following in your terminal, the worlds have been successfully converted to Gazebo maps and you can close the map generator interface.
    ```txt
    Loaded map in /home/usr/catkin_ws/src/arena-rosnav-3D/simulator_setup/maps/map4/map.yaml with metadata:
    {'image': 'map4.png', 'resolution': 0.5, 'origin': [0.0, 0.0, 0.0], 'negate': 0, 'occupied_thresh': 0.65, 'free_thresh': 0.196}
    Lossy conversion from int64 to uint8. Range [0, 255]. Convert image to uint8 prior to saving to suppress this warning.
    Writing scene in /home/usr/catkin_ws/src/arena-rosnav-3D/simulator_setup/scenarios/ped_scenarios/map4.xml...
    Done.
    ```
Now all of the maps can be used in Gazebo, have a look at [arena-rosnav-3D](https://github.com/ignc-research/arena-rosnav-3D/blob/main/docs/Usage.md) for more information.

>**NOTE**
>- For now maps can only be converted in bulk, that is all of the **arena_tools** generated maps found in the setup folder will be converted at once.
>- If you wish to convert a single map or be able to specify the conversion parameters, use textures refer to [LIRS_World_Construction_Tool](https://gitlab.com/LIRS_Projects/LIRS-WCT).

3. To use the worlds with the arena-rosnav-3d repository, there are additional steps you need to take:

    __a)__ Navigate to the newly created world file under: `arena-rosnav-3D/simulator_setup/worlds/{NAME_OF_YOUR_MAP}/worlds/{NAME_OF_YOUR_MAP}.world`\
    __b)__ add the following line somewhere between your xml world tags `<world>`:
    ```xml
        <include>
            <uri>model://ground_plane</uri>
        </include>
    ```
    like so:
    ```xml
    <sdf version="1.4">
    <world name="default">
        <include>
            <uri>model://ground_plane</uri>
        </include>
    ```
    __c)__ Replace the line: ``<pose frame="">-12.5 -12.5 -1 0 0 0</pose>`` by `<pose frame="">-12.5 -12.5 -1 0 0 0</pose>`\
    __d)__ Replace the absolute map paths: e.g: `file:///home/usr/catkin_ws/src/arena-rosnav-3D/simulator_setup/worlds/map5/worlds` with `/` so that the lines say:
    ```xml
    <uri>//map2.dae</uri>
    ```
    __e)__ Add the pose correction to the collision model. Add the following section:
    ```xml
        <collision name="collision1">
            <geometry>
    ```
    By adding the corrected pose, like so:
    ```xml
        <collision name="collision1">
            <pose frame="">-12.5 -12.5 -1 0 0 0</pose>
            <geometry>
    ```

Now you should be able to use the world. It is also advisable to use arena-tools to create scenarios for these worlds. This process will be described in the following section.



# Scenario Editor
![](img/scenario_editor.png)
Scenario Editor is a tool to create scenarios for use in Arena-Rosnav. Run it using Python:
```bash
roscd arena-tools
python ArenaScenarioEditor.py
```
## Example Usage


https://user-images.githubusercontent.com/74921738/127912004-4e97af74-b6b8-4501-a463-afbce78a0a13.mov


## General Usage
- Drag the scene or items around by pressing the LEFT mouse button
- Zoom in and out using the mouse scroll wheel
- Select multiple items by drawing a selection rectangle pressing the RIGHT mouse button
- Copy selected items by pressing CTRL+C
- Paste items by pressing CTRL+V
- Delete selected items by pressing DELETE on your keyboard


## Load and Save Scenarios
Click on File->Open or File->Save. Scenarios can be saved in YAML or JSON format, just use the according file ending.

## Set Scenario Map
Click on Elements->Set Map. Select a `map.yaml` file in the format of a typical ROS map (see [map_server Docs](http://wiki.ros.org/map_server#YAML_format)). The map will be loaded into the scene.

## Set Robot initial position and goal
Robot position and goal is always part of a scenario.

## Add Pedsim Agents

https://user-images.githubusercontent.com/74921738/126493822-88e94f7b-3595-4cce-93cd-df3a8a664607.mov


- Click on Elements->Add Pedsim Agent. An agent widget will be added on the left and the default Flatland Model for Pedsim Agents will be added to the scene.
- Open the Pedsim Agent Editor by clicking on Edit or double click the model in the scene. Here you can set the Flatland Model, type and all other attributes of your agent.
- Click on 'Add Waypoints...' or select an agent and press CTRL+D to enter Waypoint Mode. Click anywhere in the scene to add a waypoint for this agent. Press ESC or click OK when finished.


## Add Flatland Object (Static Obstacle)


https://user-images.githubusercontent.com/74921738/126516348-d2c4ab92-fb8b-4b57-9a4f-3bdefeb9e665.mov



https://user-images.githubusercontent.com/74921738/127176906-98ab58bb-9c40-4d56-b65e-049072f45a5d.mov


- Click on Elements->Add Flatland Object. A widget will be added on the left and the default Flatland Model for objects will be added to the scene.
- Choose a model YAML file by double clicking the item in the scene
- Rotate object by holding CTRL while clicking on the object (keep mouse button pressed) and dragging the mouse.

# Flatland Model Editor
![](img/model_editor.png)

Flatland Model Editor is a tool to create models used by Flatland. See the [Flatland Documentation](https://flatland-simulator.readthedocs.io/en/latest/core_functions/models.html) for a description of a model file. Run it using Python:
```bash
roscd arena-tools
python FlatlandModelEditor.py
```
## Load and Save Models
Click on File->Open or File->Save.
## Add Bodies
Click on 'Add Body'.
## Flatland Body Editor


https://user-images.githubusercontent.com/74921738/126547646-d491a712-a2d7-4881-940a-81134da04555.mov


Click on the 'edit'-Button of the Body you want to edit. The Flatland Body Editor will open. You can edit basic properties of the body and add polygon and circle footprints. You can drag the scene around using left mouse button and zoom in and out using scroll wheel.
### Polygon Footprints:
- Click on 'Add Polygon' to add a polygon footprint. A Footprint widget will be added on the left.
- Delete polygon footprint by clicking on delete.
- Edit the layers by writing them in the layers edit box. Layer names need to be separated by commas (e.g. like this: "layer1, layer2, layer3").
- Increase or decrease the number of vertices by clicking on + or -.
- Set position of the footprint by dragging it around in the scene.
- Set position of each vertice by holding the mouse near the vertice (cursor should change) and dragging the vertice.
- Duplicate footprint by selecting it in the scene and then pressing SHIFT + D
- Save body by clicking 'Save and Close'
### Circle Footprints
Not yet implemented.

# Mesure complexity of you map
1. run: `roscd arena-tools`
2. run: `python world_complexity.py --image_path {IMAGE_PATH} --yaml_path {YAML_PATH} --dest_path {DEST_PATH}`

with:\
 IMAGE_PATH: path to the floor plan of your world. Usually in .pgm format\
 YAML_PATH: path to the .yaml description file of your floor plan\
 DEST_PATH: location to store the complexity data about your map

Example launch:
```bash
python world_complexity.py --image_path ~/catkin_ws/src/forks/arena-tools/aws_house/map.pgm --yaml_path ~/catkin_ws/src/forks/arena-tools/aws_house/map.yaml --dest_path ~/catkin_ws/src/forks/arena-tools/aws_house
```
