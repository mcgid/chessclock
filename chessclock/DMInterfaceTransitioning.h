//
//  DMInterfaceTransitioning.h
//  chessclock
//
//  Created by Dan on 2016-01-05.
//
//

// Ugly import for DMClockTime, hopefully to be removed later
#import "DMClock.h"

@protocol DMInterfaceTransitioning <NSObject>

// From Loading state
- (void)interfaceShouldTransitionFromLoadingToNewGame:(id)sender;
- (void)interfaceShouldTransitionFromLoadingToSettings:(id)sender;
- (void)interfaceShouldTransitionFromLoadingToPaused:(id)sender;
- (void)interfaceShouldTransitionFromLoadingToConfirmReset:(id)sender;
- (void)interfaceShouldTransitionFromLoadingToWhiteLost:(id)sender;
- (void)interfaceShouldTransitionFromLoadingToBlackLost:(id)sender;

// From NewGame state
- (void)interfaceShouldTransitionFromNewGameToSettings:(id)sender;
- (void)interfaceShouldTransitionFromNewGameToWhiteTurn:(id)sender;

// From Settings state
- (void)interfaceShouldTransitionFromSettingsToNewGame:(id)sender;

// From Paused state
- (void)interfaceShouldTransitionFromPausedToWhiteTurn:(id)sender;
- (void)interfaceShouldTransitionFromPausedToBlackTurn:(id)sender;
- (void)interfaceShouldTransitionFromPausedToConfirmReset:(id)sender;

// From ConfirmReset state
- (void)interfaceShouldTransitionFromConfirmResetToWhiteLost:(id)sender;
- (void)interfaceShouldTransitionFromConfirmResetToBlackLost:(id)sender;
- (void)interfaceShouldTransitionFromConfirmResetToPaused:(id)sender;
- (void)interfaceShouldTransitionFromConfirmResetToNewGame:(id)sender;

// From WhiteTurn state
- (void)interfaceShouldTransitionFromWhiteTurnToWhiteLost:(id)sender;
- (void)interfaceShouldTransitionFromWhiteTurnToPaused:(id)sender;
- (void)interfaceShouldTransitionFromWhiteTurnToBlackTurn:(id)sender;

// From BlackTurn state
- (void)interfaceShouldTransitionFromBlackTurnToBlackLost:(id)sender;
- (void)interfaceShouldTransitionFromBlackTurnToPaused:(id)sender;
- (void)interfaceShouldTransitionFromBlackTurnToWhiteTurn:(id)sender;

// From WhiteLost state
- (void)interfaceShouldTransitionFromWhiteLostToConfirmReset:(id)sender;

// From BlackLost state
- (void)interfaceShouldTransitionFromBlackLostToConfirmReset:(id)sender;

// Updating clock times
- (void)interfaceShouldUpdateWithWhiteTime:(DMClockTime)remainingTime;
- (void)interfaceShouldUpdateWithBlackTime:(DMClockTime)remainingTime;

@end
