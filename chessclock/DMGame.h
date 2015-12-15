//
//  DMGame.h
//  chessclock
//
//  Created by Dan McGinnis on 12-11-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DMGameState) {
    DMNotStarted,
    DMWhiteTurn,
    DMBlackTurn,
    DMWhitePaused,
    DMBlackPaused,
    DMWhiteWon,
    DMBlackWon,
    DMWhiteLostOnTime,
    DMBlackLostOnTime,
    DMChangeTimes
};

@interface DMGame : NSObject

@property DMGameState state;

@end
