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

@property (nonatomic) Class state;

@property (nonatomic, weak) DMGameView *view;

- (void)startUpdating;
- (void)stopUpdating;

- (void)pushState:(Class)state;
- (void)popState;

@end
