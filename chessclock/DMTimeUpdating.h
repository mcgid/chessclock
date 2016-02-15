//
//  DMTimeUpdating.h
//  chessclock
//
//  Created by Dan on 2016-02-15.
//
//

#import "DMState.h"

@protocol DMTimeUpdating <NSObject>

- (void)startUpdatingTime:(DMState *)sender;
- (void)stopUpdatingTime:(DMState *)sender;

@end
