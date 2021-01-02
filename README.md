# MicroWords

Microwords is an online content sharing platform/game.
As a "character" you create and explore a world of content.
One can think of it as a mix between minecraft and twitter.

## How to get up and running

To setup run the following commands.

```
$> mix do ecto.create, event_store.create, event_store.init, event_store.migrate
$> npm install --prefix ./assets
```

After Everything was succesfully installed you can start the server with

`mix phx.server`

One can move around with the `aswd` keys as well as the arrows.
To create a random artefact press `m` to place a random artefact to your current location press `p`

Due to asynchronous actions, right now placing an artefact will only show up after you move back to the location. This will be fixed once a PubSub for locations gets implemented.

## Introduction to Concept

The game consists of the following entities. Worlds & Locations, Explorers and Artefacts.

### World & Location

A world is a space that can be explored and is consisted of locations and
a Ruleset.

A World can be explored and content can be created inside it.
The space available in a world can be represented by a 2 dimensional (or more) integer field where each coordinate e.x `[12,34]` represents a location in that world.

Multiple worlds can exist each with it's own explorers, contentm ruleset and dimensions.

World rulesets define how a world functions, we will explain them in more details in _Rulesets & Mechanics_.

To consider:

- World can have global tick (time), for evolution of artefacts and explorers

### Explorer

An explorer is the character of the "user" of the application. Explorers will have energy that can be used to do actions.
Available actions depend on the ruleset and on the state of the character (position, level and stats).
Example actions can be to create content, "feed" it, "hurt" it etc.

### Artefact

Artefacts is the content of the application. Like Explorers artefacts will have energy and will react to user actions.
Based on the energy the artefacts they will

Note that content will begin as short text in the beggining but then can be extended to hyperlinks, images, video and audio content.

Artefacts start with some energy that the user spend to create them, then by interactions they can either gain or lose energy.
Depending on the ruleset an artefact after obtaining a certain amount of energy will "evolve" to a new stage, the opossite can happen if from a higher stage
an artefact will lose enough energy it will be devolved to a lower stage.

The type of stages and their behavior will also be part of the defined ruleset.

An artefact can die (gets removed) when it's energy is depleted (getting to 0). That will destroy the artefact and release the space it was occupying to
allow for other artefact to take its place.

Artefacts with sufficient energy will create seeds that can be planted for the same content to grow elsewhere.

### Ruleset & Mechanics

As explained earlier how an explorer can act and how the artefacts reacts as well as various other characteristics of the world are defined by the world ruleset. However to better understand what the ruleset actually does lets explore the mechanics.

The explorer can move across the world field, on each step the "land" below him (lets call it a field) can have a piece of content or be empty.
On empty fields the explorer can place pieces of content (artefacts) they have and on fields that already have placed artefacts the explorer can interact with them.

Overall how interactions happen is that a user will receive a set of actions that they can do at this moment to the artefact. When they do an action the artefact will do a reaction that in turn affects the explorer.

For example an explorer can "nourish" an artefact, that will cost him 20 energy then the artefact will re-react by receiving 20 energy, and sending a link to the user.
Then with that link the artefact can further benefit the user if it "evolves" into the next stage.

All these will be defined by the ruleset the world is under but the ExplorerActionTake -> ArtefactReacted -> ExplorerAffected are global mechanics that will be always present.

### Landmarks & NPCs

In order to make the game more interesting there is a vision to create "special" system generated artefacts and NPCs.
Overall these will be used to aid players generate content (by providing energy or helping with seed dispersal).
How many and types of NPCs and Landmarks are also part of world ruleset.
