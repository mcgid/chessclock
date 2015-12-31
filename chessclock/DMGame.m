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
@property (nonatomic) CADisplayLink *displayLink;
@property (nonatomic) CFTimeInterval lastUpdateTimestamp;

@end


@implementation DMGame

#pragma mark Initialization

- (instancetype)init
{
    self = [super init];

    if (self) {
        _stateMachine = [[GKStateMachine alloc] initWithStates:[self initialStates]];
        _white = [[DMClock alloc] init];
        _black = [[DMClock alloc] init];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        _lastUpdateTimestamp = 0.0;
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

#pragma mark Accessors and Mutators

- (Class)state
{
    return [self.stateMachine.currentState class];
}

- (void)setState:(Class)state
{
    [self.stateMachine enterState:state];
}

#pragma mark Instance Methods

- (void)startUpdating
{
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopUpdating
{
    [self.displayLink invalidate];
}

- (void)update:(CADisplayLink *)sender
{
    NSTimeInterval deltaTime = (NSTimeInterval)(self.displayLink.timestamp - self.lastUpdateTimestamp);

    [self.stateMachine updateWithDeltaTime:deltaTime];

    self.lastUpdateTimestamp = self.displayLink.timestamp;
}

@end
