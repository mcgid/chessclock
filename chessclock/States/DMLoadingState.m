//
//  DMLoadingState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

@implementation DMLoadingState

- (void)willExitWithNextState:(GKState *)nextState
{
    // Regardless of where we're going, put the current clock times up
    [self.game.interface interfaceShouldUpdateWithWhiteTime:[self.game.white remainingTime]];
    [self.game.interface interfaceShouldUpdateWithBlackTime:[self.game.black remainingTime]];

    if ([nextState isKindOfClass:[DMNewGameState class]]) {
        [self.game.interface interfaceShouldTransitionFromLoadingToNewGame:self];
    } else if ([nextState isKindOfClass:[DMSettingsState class]]) {
        [self.game.interface interfaceShouldTransitionFromLoadingToSettings:self];
    } else if ([nextState isKindOfClass:[DMPausedState class]]) {
        [self.game.interface interfaceShouldTransitionFromLoadingToPaused:self];
    } else if ([nextState isKindOfClass:[DMWhiteLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromLoadingToWhiteLost:self];
    } else if ([nextState isKindOfClass:[DMBlackLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromLoadingToBlackLost:self];
    }
}

@end