//
//  DMTimeUpdating.h
//  chessclock
//
//  Created by Dan on 2016-02-15.
//
//

@class DMState;

@protocol DMTimeUpdating <NSObject>

- (void)startUpdatingTime:(DMState *)sender;
- (void)stopUpdatingTime:(DMState *)sender;

- (void)timeDidChange:(DMState *)sender;

@end
