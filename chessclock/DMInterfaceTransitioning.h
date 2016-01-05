//
//  DMInterfaceTransitioning.h
//  chessclock
//
//  Created by Dan on 2016-01-05.
//
//

@protocol DMInterfaceTransitioning <NSObject>

// From Loading state
- (void)transitionFromLoadingToNewGame;
- (void)transitionFromLoadingToSettings;
- (void)transitionFromLoadingToPaused;
- (void)transitionFromLoadingToConfirmReset;
- (void)transitionFromLoadingToWhiteLost;
- (void)transitionFromLoadingToBlackLost;

// From NewGame state
- (void)transitionFromNewGameToSettings;
- (void)transitionFromNewGameToWhiteTurn;

// From Settings state
- (void)transitionFromSettingsToNewGame;

// From WhiteTurn state
- (void)transitionFromWhiteTurnToWhiteLost;
- (void)transitionFromWhiteTurnToPaused;
- (void)transitionFromWhiteTurnToBlackTurn;

// From BlackTurn state
- (void)transitionFromBlackTurnToBlackLost;
- (void)transitionFromBlackTurnToPaused;
- (void)transitionFromBlackTurnToWhiteTurn;

// From Paused state
- (void)transitionFromPausedToWhiteTurn;
- (void)transitionFromPausedToBlackTurn;
- (void)transitionFromPausedToConfirmReset;

// From WhiteLost state
- (void)transitionFromWhiteLostToConfirmReset;

// From WhiteLost state
- (void)transitionFromBlackLostToConfirmReset;

// From ConfirmReset state
- (void)transitionFromConfirmResetToWhiteLost;
- (void)transitionFromConfirmResetToBlackLost;
- (void)transitionFromConfirmResetToPaused;
- (void)transitionFromConfirmResetToNewGame;

@end
