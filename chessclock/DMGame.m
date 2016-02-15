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
    return [self initWithInterface:nil timeUpdatingDelegate:nil];
}


- (instancetype)initWithInterface:(id<DMInterfaceTransitioning>)interface timeUpdatingDelegate:(id<DMTimeUpdating>)timeUpdatingDelegate
{
    self = [super init];

    if (self) {
        _stateMachine = [[GKStateMachine alloc] initWithStates:[self statesWithGame:self timeUpdatingDelegate:timeUpdatingDelegate]];
        _interface = interface;
        _white = [[DMClock alloc] init];
        _black = [[DMClock alloc] init];
        _lastUpdateTimestamp = 0.0;
        _storedStates = [[NSMutableArray alloc] initWithCapacity:5];
    }

    return self;
}

- (NSArray *)statesWithGame:(DMGame *)game timeUpdatingDelegate:(id<DMTimeUpdating>)timeUpdatingDelegate
{
    NSArray *states = @[[[DMLoadingState alloc] init],
                        [[DMNewGameState alloc] init],
                        [[DMSettingsState alloc] init],
                        [[DMPausedState alloc] init],
                        [[DMConfirmResetState alloc] init],
                        [[DMWhiteTurnState alloc] init],
                        [[DMWhiteLostState alloc] init],
                        [[DMBlackTurnState alloc] init],
                        [[DMBlackLostState alloc] init]
                        ];

    for (DMState *state in states) {
        state.game = game;
        state.timeUpdatingDelegate = timeUpdatingDelegate;
    }

    return states;
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
