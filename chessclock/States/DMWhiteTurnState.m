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

@interface DMWhiteTurnState ()

@property (nonatomic) DMClockTime displayedTime;

@end

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

    [self.game startUpdating];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [self.game stopUpdating];

    if (![nextState isKindOfClass:[DMBlackTurnState class]]) {
        // Allow the screen to dim
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }

    // Stop the white clock
    [self.game.white stop];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    DMClockTime whiteTime = [self.game.white remainingTime];

    if (whiteTime.totalSeconds <= 0) {
        self.game.state = [DMWhiteLostState class];
    } else if (whiteTime.minutes != self.displayedTime.minutes ||
               whiteTime.seconds != self.displayedTime.seconds) {
        [self.game.view updateWithWhiteTime:whiteTime];
        self.displayedTime = whiteTime;
    }
}

@end