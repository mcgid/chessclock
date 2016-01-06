//
//  DMPausedState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMPausedState

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromPausedToWhiteTurn:self];
    } else if ([nextState isKindOfClass:[DMBlackTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromPausedToBlackTurn:self];
    } else if ([nextState isKindOfClass:[DMConfirmResetState class]]) {
        [self.game.interface interfaceShouldTransitionFromPausedToConfirmReset:self];
    }
}

@end