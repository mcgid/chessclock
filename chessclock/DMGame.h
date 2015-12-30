//
//  DMGame.h
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMStates.h"
#import "DMGameView.h"

@interface DMGame : NSObject

@property (nonatomic, readonly) DMClock *white;
@property (nonatomic, readonly) DMClock *black;

@property (nonatomic) DMState *state;

@property (nonatomic, weak) DMGameView *view;

@end
