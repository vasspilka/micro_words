# MicroWords

Mircowords is an online content sharing platform/game.
The idea is that as a character you create and explore a world of content.

## Introduction to Concept

The game consists of three main entities. Worlds, Explorers and Artefacts. 


### World

Worlds are spaces that can be explored and content can be created.
They are represented by a two dimensional field in which each "square" is a place where explorers can move to and view or create content.

Multyple worlds can exist each with it's own explorers, content and ruleset.

World rulesets define how a world functions, we will explain them in more details in *Rulesets & Mechanics*

### Explorer

An explorer is the character of the "user" of the application. Exlorers will have energy and based on it they can do actions.
Actions available depend on the ruleset and if state of the character (position, level and stats).
One of the actions available will ofcourse be to create create content.


### Artefact

Artefacts is the content of the application. Like Explorers artefacts will have energy and will react to user actions.
Based on the energy the artefacts they will

Note that content will begin as short text in the beggining but then can be extended to hyperlinks, images, video and audio content.

### Ruleset & Mechanics

As explained earlier how can an explorer act and how the artefacts reacts as well as various other characteristics of the world are defined
by the world ruleset. However to better understand what the ruleset actually does lets explore the mechanics.

The explorer can move across the world field, on each step the "land" below him (lets call it a field) can have a piece of content or be empty.
On empty fields the explorer can create new pieces of content (artefacts) however on fields that there are existing artefacts the explorer can interact with them.

Overall how interactions happen is that a user will receive a set of actions that they can do at this moment to the artefact. When they do an action the artefact will do a reaction that in turn affects the explorer.

For example an explorer can "nurish" an artefact, that will cost him 20 energy then the artefact will rereact by receiving 20 energy, and sending a link to the user.
Then with that link the artefact can further benefit the user if it "evolves" into the next stage.

All these will be defined by the ruleset the world is under but the ExplorerActionTake -> ArtefactReacted -> ExplorerAffected are global mechanics that will be always present

### Landmarks & NPCs

In order to make the game more interesting there are going to be "special" system generated artefacts and explorers.
Overall these will be used to aid players generate content (by providing energy or helping with seed dispersal).
How many and types of NPCs and Landmarks are also part of world ruleset.

