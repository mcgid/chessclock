//
//  DMGame.h
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class DMClock, DMState, DMGameView;

@interface DMGame : NSObject

@property (nonatomic, readonly) DMClock *white;
@property (nonatomic, readonly) DMClock *black;

@property (nonatomic, weak) DMGameView *view;

- (void)startUpdating;
- (void)stopUpdating;

- (Class)state;
- (void)enterState:(Class)state;
- (void)pushState:(Class)state;
- (void)popState;

@end
