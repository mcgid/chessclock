# chessclock

This is *chessclock*. You can clone it and build it and install it and run it and use it, but that's not why it's here.

It is here to be an object lesson in building an iOS app with a non-standard interface.

This README explains the design and construction of *chessclock*, starting with why you would want a clock for your chess.

## Why

What's a chess clock?

Why would you use one?

Why would you make one?

Can we make any tangentially related 1980's science fiction references?

[Read the answers here…](README/README-Why.md)

## What

Let's build a chess clock app that targets `iOS 9.0` with `Xcode 7.2`.

Chess is a game. The standard interface metaphors for an iOS app would not be very pretty.

> *Screenshot: Interface with standard metaphors*

Eugh. Gross.

Let's design a custom interface.

> *Screenshot: Design of New Game screen*

Much better. Let's make it fancy with animations, too.

## How

#### Class Structure

We need classes to make our app.

[What classes will we need?](README/README-Class_Structure.md)

I prepared this baking sheet of classes beforehand:

> *diagram: AppDelegate; GameViewControler view->GameView, game->(Game white->Clock, black->Clock)*


#### Fanciness Begets Complexity

We're going to make the interface fancy. The fancier an interface is, the harder it is to keep track of which controls should be visible, which should be enabled, and what should be updated.

A useful tool to deal with fancy interfaces is a [state machine](https://en.wikipedia.org/wiki/Finite-state_machine).

#### State Machine

iOS 9.0 gave us `GameplayKit`, which gives us `GKStateMachine` and `GKState`. Let's use them to keep track of what our interface is doing. The `GKStateMachine` object can live in our `Game` class, since the latter holds the game state.

What will our state machine look like?

[I'm glad you asked!](README/README-State-machine.md)

> *diagram: AppDelegate; GameViewControler view->GameView, game->(Game white->Clock, black->Clock)*

