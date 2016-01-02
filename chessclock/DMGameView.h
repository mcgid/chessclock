//
//  DMGameView.h
//  chessclock
//
//  Created by Dan on 2015-12-18.
//
//

#import "DMClock.h"

@protocol DMGameViewDelegate <NSObject>

- (void)whiteTimeLimitDidChange:(DMClockTime)time;
- (void)blackTimeLimitDidChange:(DMClockTime)time;

@end

@interface DMGameView : UIView

@property (nonatomic, weak) id delegate;

- (void)updateWithWhiteTime:(DMClockTime)time;
- (void)updateWithBlackTime:(DMClockTime)time;

- (void)makeWhiteButtonWinner;
- (void)makeBlackButtonWinner;

- (void)enableWhiteButton;
- (void)disableWhiteButton;

- (void)enableBlackButton;
- (void)disableBlackButton;

- (void)showSliders;
- (void)hideSliders;

- (void)enablePlayerButtonInteraction;
- (void)disablePlayerButtonInteraction;

- (void)showResetButton;
- (void)hideResetButton;
- (void)enableResetButton;
- (void)disableResetButton;

- (void)showTimesButton;
- (void)hideTimesButton;

- (void)showPauseButton;
- (void)hidePauseButton;
- (void)enablePauseButton;
- (void)disablePauseButton;

- (void)showStartGameLabel;
- (void)hideStartGameLabel;

- (void)resetStartGameLabelContent;
- (void)replaceStartGameLabelContent;

- (void)showConfirmResetArea;
- (void)hideConfirmResetArea;

- (void)resetPlayerButtonColors;

- (void)selectPauseButton;
- (void)deselectPauseButton;

- (void)selectTimesButton;
- (void)deselectTimesButton;

@end