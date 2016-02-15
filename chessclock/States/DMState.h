//
//  DMState.h
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

@import UIKit;
@import GameplayKit;

#import "DMGame.h"
#import "DMTimeUpdating.h"

@interface DMState : GKState

@property (nonatomic, weak) DMGame *game;
@property (nonatomic, weak) id<DMTimeUpdating> timeUpdatingDelegate;

@end
