# Co::Engine

This is a gen to implement the game engine for a 'Code Breaker' style game

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'co-engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install co-engine

## Usage

The gem is designed to be able to load or export the games state at any point (currently only via JSON).
 
This is done using:

    CoEngine.load(<json-data>) => <engine>
    
and:
    
    <engine>.export => <json>

### States

The game is have 4 main states:

* WaitingForPlayers
* InitialTileSelection
* GameTurn
* Completed

Each state has a specific list of actions that can be performed, to view the current list of actions call:

    engine.actions
    
and to perform an action call:

    engine.perform(<action_name>, *<action_args>)
    
Please read through the feature tests for further documentation on the available actions.

Each **GameTurn** is composed of a series of process states:
 
* TileSelection
* GuessTile
* FinaliseTurnOrGuessAgain
* FinaliseTurn

NOTE: you only enter the **FinaliseTurnOrGuessAgain** state if you correctly guess an opponents tile.  

## Contributing

1. Fork it ( https://github.com/[my-github-username]/co-engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
