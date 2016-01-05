[← README](../README.md)

# State Machine

Let's start with the main classes: the `AppDelegate` and the view controller, `GameViewController`.

> *diagram: AppDelegate; GameViewController*

Let's avoid throwing every outlet and subview init in the view controller, by making a UIView subclass. We can use that class for the `GameViewController`'s `view` outlet in the storyboard.

> *diagram: AppDelegate; GameViewController view->GameView*

We'll need a class to be the actual clock, holding the time limit and current time for a player.

> *diagram: AppDelegate; GameViewController view->GameView, Clock*

Instead of holding the `Clock`s in the controller directly, let's make a class that will represent the whole model of the game, including the `Clock`s. The controller can own that.

> *diagram: AppDelegate; GameViewControler view->GameView, game->(Game white->Clock, black->Clock)*

That should be all the states we need for now.

[← Keep reading the README…](../README.md)

