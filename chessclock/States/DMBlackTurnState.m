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

    [self.game.view enableBlackButton];

    if ([previousState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.game.view disableWhiteButton];
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];

    // Stop the white clock
    [self.game.black stop];

    [self.game.view disableBlackButton];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    DMClockTime blackTime = [self.game.black remainingTime];

    if (blackTime.totalSeconds <= 0) {
        [self.game enterState:[DMWhiteLostState class]];
    } else if (blackTime.minutes != self.displayedTime.minutes ||
               blackTime.seconds != self.displayedTime.seconds) {
        [self.game.view updateWithWhiteTime:blackTime];
        self.displayedTime = blackTime;
    }
}


@end