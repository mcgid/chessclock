//
//  DMConfirmResetState.m
//  chessclock
//
//  Created by Dan on 2015-12-24.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMConfirmResetState

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMWhiteLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromConfirmResetToWhiteLost:self];
    } else if ([nextState isKindOfClass:[DMBlackLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromConfirmResetToBlackLost:self];
    } else if ([nextState isKindOfClass:[DMPausedState class]]) {
        [self.game.interface interfaceShouldTransitionFromConfirmResetToPaused:self];
    } else if ([nextState isKindOfClass:[DMNewGameState class]]) {
        [self.game.interface interfaceShouldTransitionFromConfirmResetToNewGame:self];
    }
}

@end