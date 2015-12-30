//
//  DMState.h
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

@import UIKit;
@import GameplayKit;

@class DMGame;

@interface DMState : GKState

@property (nonatomic, weak) DMGame *game;

// Designated initializer
- (instancetype)initWithGame:(DMGame *)game;

@end
