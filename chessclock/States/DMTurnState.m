//
//  DMTurnState.m
//  chessclock
//
//  Created by Dan on 2015-12-31.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMTurnState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    // Prevent screen from dimming
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self.timeUpdatingDelegate startUpdatingTime:self];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [self.timeUpdatingDelegate stopUpdatingTime:self];

    if (![nextState isKindOfClass:[DMTurnState class]]) {
        // Allow the screen to dim
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}


@end
