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
    self = [super init];

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

}

- (void)willExitWithNextState:(GKState *)nextState
{
    [super willExitWithNextState:nextState];

    // Stop the white clock
    [self.game.white stop];

    if ([nextState isKindOfClass:[DMWhiteLostState class]]) {
        [self.game.interface interfaceShouldTransitionFromWhiteTurnToWhiteLost:self];
    } else if ([nextState isKindOfClass:[DMPausedState class]]) {
        [self.game.interface interfaceShouldTransitionFromWhiteTurnToPaused:self];
    } else if ([nextState isKindOfClass:[DMBlackTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromWhiteTurnToBlackTurn:self];
    }
}


@end