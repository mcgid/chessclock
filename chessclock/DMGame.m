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
@property (nonatomic) NSMutableArray *storedStates;

@end


@implementation DMGame

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithView:nil];
}

- (instancetype)initWithView:(DMGameView *)view
{
    self = [super init];

    if (self) {
        _stateMachine = [[GKStateMachine alloc] initWithStates:[self initialStates]];
        _white = [[DMClock alloc] init];
        _black = [[DMClock alloc] init];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
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
    [self.storedStates addObject:self.stateMachine.currentState];

    [self.stateMachine enterState:state];
}

- (void)popState
{
    Class nextState = self.storedStates.lastObject;

    [self.storedStates removeLastObject];

    [self.stateMachine enterState:nextState];
}

#pragma mark Interface updating

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
