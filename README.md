# esx_planting
Modification created by the Oesis Server allowing the production of drugs whose production is based on planting.
![Script in Action](https://mwojtasik.pl/img_zarabiam/portfolio/fivem/1.png)

# Requirements
* es_extended - [github.com](https://github.com/ESX-Org/es_extended)
* pNotify - [github.com](https://github.com/Nick78111/pNotify)


## Usage
The application of the script is to allow players to produce drugs (or maybe also other plants?), Requiring them to integrate to complete the drug making process.
The script due to its construction (rising from the ground) is adapted to the production of drugs that are produced by planting.
The integration with the user consists in choosing the answer to the given question.
The script is adapted to different combinations of questions and answers and the possibility of adding various types of drugs.
To start the process of creating a drug, the player must have the right item and be in the location set for the given drug.

## Adding a new drug
Configuration is done via the config.lua file.
The addition of a new drug requires the creation of an array nested in the main array "options", but remember that the name of the created array should correspond to the name of the object that will be required to start the process.
An example of starting the config:
```
Config.cancel_buttons - Array in which we nest a list of buttons that cause the planting process to be interrupted.
options =
{
      seed_weed = { "Configuration option for a given item" },
}
```

## Update 27.04.2019 - Support multiple items
From now on you can add new items/drugs without taking care of the server/main.lua file.
The Config.CopsOnDuty variable was also removed from the server / main.lua file.
You can now set an independent number of required policemen on duty to start the proccess with it.


## Config options for specified drug
###### Update 27.04.2019
```
cops - The required cops on duty to start the proccess of planting
```
###### End Update 27.04.2019
```
object - The name of the object that will appear after the beginning of the process ex. prop_weed_01
```
```
end_object - The name of the object that appears after the process is completed and the answer to the last question is answered ex. prop_weed_02
```
```
fail_msg - Message content when the player gave an incorrect answer
```
```
success_msg - The content of the message when the player goes through the entire creation process
```
```
success_item = The name of the item that the player will receive after successful completion of the process (the quantity is determined in the last question that allows RNG for the number of items)
```
```
first_step - number of double ex format. 2.24 responsible for 'pressing' the object into the ground at the start of planting
```
```
steps - The number of int which corresponds to the number of steps the player has to make, otherwise - the number of questions
```
```
animations_start = {} - In the middle should be arrayed array of animations that are performed immediately after starting the planting process
```
```
animations_start = {} - In the middle should be arrayed array of animations that are performed after the successful completion of the planting process
```
```
animations_step = {} -  In the middle should be arrayed array of animations that are performed after each answer to the question
```
```
grow - A list of double numbers separated by a comma corresponding to pressing the plant into the ground (simulation of growing the plant)
```
```
questions = {} - In the middle should be arrayed, corresponding to the information about each of the questions
```

## An example of Array for animation
```
animations_start = {
  {lib = 'amb@world_human_gardener_plant@male@enter', anim = 'enter', timeout = '1'},
  {lib = 'amb@world_human_gardener_plant@male@idle_a', anim = 'idle_a', timeout = '1'},
}
```

## An example of the Array responsible for the question
```
{
    title = 'Twoja roślinka jest już prawie gotowa do ścięcia, co robisz?',
    steps = {
        {label = 'Podlewam Roślinę', value = 1},
        {label = 'Nawożę Roslinę', value = 2},
        {label = 'Czekam', value = 3}
    },
    correct = 1
},
```

## Last Question and RNG
As you may have learned earlier, the last question contains quantitative information on the minimum (max) and minimum (min) amount of the final product that a player can receive.
Example for the last question:
```
{
    title = 'Twoja roślinka jest gotowa do zbiorów, co robisz?',
    steps = {
        {label = 'Zbierz przy użyciu nożyczek', value = 1, min = 5, max = 25},
        {label = 'Zbierz rękoma', value = 1, min = 10, max = 15},
        {label = 'Zetnij sekatorem', value = 1, min = 2, max = 40}
    },
    correct = 1
}
```
