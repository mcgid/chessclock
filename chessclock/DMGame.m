//
//  DMGame.m
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@import GameplayKit;
@import QuartzCore;

#import "DMGame.h"

#import "DMStates.h"
#import "DMClock.h"

@interface DMGame ()

@property (nonatomic) GKStateMachine *stateMachine;
@property (nonatomic) CFTimeInterval lastUpdateTimestamp;
@property (nonatomic) NSMutableArray *storedStates;

@end


@implementation DMGame

#pragma mark Lifecycle
- (instancetype)init
{
    return [self initWithInterface:nil];
}


- (instancetype)initWithInterface:(id<DMInterfaceTransitioning>)interface
{
    self = [super init];

    if (self) {
        _stateMachine = [[GKStateMachine alloc] initWithStates:[self initialStates]];
        _interface = interface;
        _white = [[DMClock alloc] init];
        _black = [[DMClock alloc] init];
        _lastUpdateTimestamp = 0.0;
        _storedStates = [[NSMutableArray alloc] initWithCapacity:5];
    }

    return self;
}

- (NSArray *)initialStates
{
    DMLoadingState * loadingState = [[DMLoadingState alloc] initWithGame:self];
    DMNewGameState * newGameState = [[DMNewGameState alloc] initWithGame:self];
    DMSettingsState * settingsState = [[DMSettingsState alloc] initWithGame:self];
    DMPausedState * pausedState = [[DMPausedState alloc] initWithGame:self];
    DMConfirmResetState *confirmResetState = [[DMConfirmResetState alloc] initWithGame:self];
    DMWhiteTurnState * whiteTurnState = [[DMWhiteTurnState alloc] initWithGame:self];
    DMWhiteLostState * whiteLostState = [[DMWhiteLostState alloc] initWithGame:self];
    DMBlackTurnState * blackTurnState = [[DMBlackTurnState alloc] initWithGame:self];
    DMBlackLostState * blackLostState = [[DMBlackLostState alloc] initWithGame:self];

    return @[loadingState,
             newGameState,
             settingsState,
             pausedState,
             confirmResetState,
             whiteTurnState,
             whiteLostState,
             blackTurnState,
             blackLostState
             ];

}


#pragma mark State machine

- (Class)state
{
    return [self.stateMachine.currentState class];
}

- (void)enterState:(Class)state
{
    [self.stateMachine enterState:state];
}

- (void)pushState:(Class)state
{
    [self.storedStates addObject:[self.stateMachine.currentState class]];

    [self enterState:state];
}

- (void)popState
{
    Class storedState = self.storedStates.lastObject;

    [self.storedStates removeLastObject];

    [self enterState:storedState];
}

#pragma mark Time limit changing

- (void)setWhiteTimeLimit:(NSTimeInterval)timeLimit
{
    self.white.timeLimit = timeLimit;
}

- (void)setBlackTimeLimit:(NSTimeInterval)timeLimit
{
    self.black.timeLimit = timeLimit;
}

@end
