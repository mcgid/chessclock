//
//  DMGame.h
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMInterfaceTransitioning.h"
#import "DMTimeUpdating.h"

@class DMClock, DMState, DMGameView;

@interface DMGame : NSObject

@property (nonatomic, readonly) DMClock *white;
@property (nonatomic, readonly) DMClock *black;

@property (nonatomic, weak) id<DMInterfaceTransitioning> interface;

- (instancetype)initWithInterface:(id<DMInterfaceTransitioning>)interface timeUpdatingDelegate:(id<DMTimeUpdating>)timeUpdatingDelegate NS_DESIGNATED_INITIALIZER;

- (Class)state;
- (void)enterState:(Class)state;
- (void)pushState:(Class)state;
- (void)popState;

- (void)setWhiteTimeLimit:(NSTimeInterval)timeLimit;
- (void)setBlackTimeLimit:(NSTimeInterval)timeLimit;

@end
