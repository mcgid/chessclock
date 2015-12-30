//
//  DMGame.m
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@import GameplayKit;

#import "DMGame.h"

#import "DMStates.h"

@interface DMGame ()

@property (nonatomic) GKStateMachine *stateMachine;

@end


@implementation DMGame

- (instancetype)init
{
    self = [super init];

    if (self) {
        _stateMachine = [[GKStateMachine alloc] initWithStates:[self initialStates]];
    }

    return self;
}

- (NSArray *)initialStates
{
    DMLoadingState * loadingState = [[DMLoadingState alloc] initWithGame:self];
    DMNewGameState * newGameState = [[DMNewGameState alloc] initWithGame:self];
    DMSettingsState * settingsState = [[DMSettingsState alloc] initWithGame:self];
    DMWhiteTurnState * whiteTurnState = [[DMWhiteTurnState alloc] initWithGame:self];
    DMWhiteLostState * whiteLostState = [[DMWhiteLostState alloc] initWithGame:self];
    DMBlackTurnState * blackTurnState = [[DMBlackTurnState alloc] initWithGame:self];
    DMBlackLostState * blackLostState = [[DMBlackLostState alloc] initWithGame:self];

    return @[loadingState,
             newGameState,
             settingsState,
             whiteTurnState,
             whiteLostState,
             blackTurnState,
             blackLostState
             ];

}

- (Class)state
{
    return [self.stateMachine.currentState class];
}

- (void)setState:(Class)state
{
    [self.stateMachine enterState:state];
}


@end
