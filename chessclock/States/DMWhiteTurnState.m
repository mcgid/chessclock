//
//  DMWhiteTurnState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMWhiteTurnState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    // Prevent screen from dimming
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    // Start the white clock
    [self.game.white start];

    [self.game.view enableWhiteButton];

    if ([previousState isKindOfClass:[DMNewGameState class]]) {
        [self.game.view showPauseButton];
        [self.game.view showResetButton];
        [self.game.view hideTimesButton];
        [self.game.view enablePauseButton];
        [self.game.view disableResetButton];

    }
    else if ([previousState isKindOfClass:[DMPausedState class]]) {
        [self.game.view disableResetButton];
        [self.game.view deselectPauseButton];
    }
    else if ([previousState isKindOfClass:[DMBlackTurnState class]]) {
        [self.game.view disableBlackButton];
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if (![nextState isKindOfClass:[DMBlackTurnState class]]) {
        // Allow the screen to dim
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}

@end