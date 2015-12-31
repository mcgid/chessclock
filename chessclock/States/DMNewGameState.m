//
//  DMNewGameState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMNewGameState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    if ([previousState isKindOfClass:[DMLoadingState class]] ||
        [previousState isKindOfClass:[DMLostState class]]) {
        [self.game.view showTimesButton];

        [self.game.view enableWhiteButton];
        [self.game.view disableBlackButton];
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMTurnState class]]) {
        [self.game.view hideTimesButton];
    }
}

@end