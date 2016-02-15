//
//  DMBlackTurnState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMBlackTurnState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];

    // Start the black clock
    [self.game.black start];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];

    // Stop the white clock
    [self.game.black stop];

    if ([nextState isKindOfClass:[DMBlackLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromBlackTurnToBlackLost:self];
    } else if ([nextState isKindOfClass:[DMPausedState class]]) {
        [self.game.interface interfaceShouldTransitionFromBlackTurnToPaused:self];
    } else if ([nextState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromBlackTurnToWhiteTurn:self];
    }
}

@end