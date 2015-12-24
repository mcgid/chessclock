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

    if ([previousState isKindOfClass:[DMNewGameState class]]) {
        [self.gameView showPauseButton];
        [self.gameView showResetButton];
        [self.gameView hideTimesButton];
        [self.gameView enablePauseButton];
        [self.gameView disableResetButton];

        [self.gameView enableWhiteButton];
    }
    else if ([previousState isKindOfClass:[DMPausedState class]]) {
        [self.gameView enableWhiteButton];
        [self.gameView disableResetButton];
        [self.gameView deselectPauseButton];
    }
    else if ([previousState isKindOfClass:[DMBlackTurnState class]]) {
        [self.gameView enableWhiteButton];
        [self.gameView disableBlackButton];
    }
}

@end