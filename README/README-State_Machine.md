[← README](../README.md)

iOS 9.0 gave us `GameplayKit`, which gives us `GKStateMachine` and `GKState`.
Let's use them to keep track of what our interface is doing. The
`GKStateMachine` object can live in our `Game` class, since the latter holds
the game state.

What states do we need?

Well, the app will start in a `NewGame`:

> *diagram: NewGameState*

If the players want to change the time limit on their clocks  (to account for
differing skill levels, for instance), they can tap on the **TIMES** button, to
change those settings:

> *diagram: NewGameState, SettingsState*

Once they've chosen their times, they can start the game. That means the white
player's clock starts counting down:

> *diagram: NewGameState, SettingsState, WhiteTurnState*

When the white player ends their turn, the black player's turn begins:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState*

If there's an interruption, the players need to be able to pause their game:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState, PausedState*

When either of the players' clocks run out of time, that player loses:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState,
> PausedState, WhiteLostState, BlackLostState*

If the game is paused, the players may wish to reset their clocks and start a
new game. We'd better confirm that first, though:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState,
> PausedState, WhiteLostState, BlackLostState, ConfirmResetState*

After a player loses, they'll need to reset the clocks, too:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState,
> PausedState, WhiteLostState, BlackLostState, ConfirmResetState*

We'd like to be able to save the game state and load it later. To make sure the
interface animations happen nicely, and also to be conceptually pleasant, let's
add an initial state while the app is loading. From that state we can
transition to the other states:

> *diagram: NewGameState, SettingsState, WhiteTurnState, BlackTurnState,
> PausedState, WhiteLostState, BlackLostState, ConfirmResetState, LoadingState*

[← Keep reading the README…](../README.md)

