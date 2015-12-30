//
//  DMWhiteTurnState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

@implementation DMWhiteTurnState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;

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

@end