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

@property (nonatomic) BOOL isFirstTurn;

@end

@implementation DMWhiteTurnState

- (instancetype)initWithGame:(DMGame *)game
{
    self = [super initWithGame:game];

    if (self) {
        _isFirstTurn = YES;
    }

    return self;
}

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [super didEnterWithPreviousState:previousState];

    // Start the white clock
    [self.game.white start];

    [self.game.view enableWhiteButton];

    if ([previousState isKindOfClass:[DMBlackTurnState class]]) {
        [self.game.view disableBlackButton];
    }
}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];

    // Stop the white clock
    [self.game.white stop];

    [self.game.view disableWhiteButton];

    if (self.isFirstTurn) {
        [self.game.view hideStartGameLabel];

        self.isFirstTurn = NO;
    }
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    DMClockTime whiteTime = [self.game.white remainingTime];

    if (whiteTime.totalSeconds <= 0) {
        [self.game enterState:[DMWhiteLostState class]];
    } else if (whiteTime.minutes != self.displayedTime.minutes ||
               whiteTime.seconds != self.displayedTime.seconds) {
        [self.game.view updateWithWhiteTime:whiteTime];
        self.displayedTime = whiteTime;
    }
}

@end