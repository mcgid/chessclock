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

    [self.game.view showStartGameLabel];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMTurnState class]]) {
        [self.game.view hideTimesButton];
    } else if ([nextState isKindOfClass:[DMSettingsState class]]) {
        [self.game.view hideStartGameLabel];
    }
}

@end