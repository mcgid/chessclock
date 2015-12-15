//
//  DMViewController.m
//  chessclock
//
//  Created by Dan McGinnis on 12-02-25.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "GameViewController.h"
#import "DMClock.h"
#import "DMGame.h"

#import "UIColor+CTRExtensions.h"

@interface GameViewController ()


@property (weak, nonatomic) IBOutlet UIView *whiteBackground;
@property (weak, nonatomic) IBOutlet UIView *greyBackground;
@property (weak, nonatomic) IBOutlet UIView *blackBackground;
@property (weak, nonatomic) IBOutlet UILabel *startGameLabel;
@property(nonatomic, weak) IBOutlet UIButton *whiteButton;
@property(nonatomic, weak) IBOutlet UIButton *blackButton;
@property(nonatomic, weak) IBOutlet UIButton *pauseButton;
@property(nonatomic, weak) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *timesButton;
@property(weak, nonatomic) IBOutlet UISlider *whiteSlider;
@property(weak, nonatomic) IBOutlet UISlider *blackSlider;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *whiteSliderTopConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *blackSliderBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pauseButtonTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *cancelResetButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmResetButton;
@property (weak, nonatomic) IBOutlet UILabel *confirmResetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greyBackgroundHeightConstraint;
@property (nonatomic) BOOL whitePlayerHasEndedFirstTurn;
@property (weak, nonatomic) IBOutlet UIButton *winnerButton;
@property (weak, nonatomic) IBOutlet UIButton *loserButton;

@property(nonatomic, strong) DMClock * white;
@property(nonatomic, strong) DMClock * black;
@property(nonatomic) NSTimer *timer;
@property(nonatomic, strong) DMGame *game;
@property (nonatomic, strong) NSArray *sliderTimes;

- (void)startGame;
- (IBAction)whiteSliderValueChanged:(id)sender;
- (IBAction)blackSliderValueChanged:(id)sender;
- (IBAction)whiteSliderFinishedEditing:(id)sender;
- (IBAction)blackSliderFinishedEditing:(id)sender;

- (void) updateInterface;

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                       animatable:(BOOL)animatable
                       completion:(void (^)(BOOL))completion;

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                        animatable:(BOOL)animatable;
- (IBAction)toggleTimes:(id)sender;

@end

@implementation GameViewController

#pragma mark View lifecycle

/**
 * Initialize properties not related to the view
 *
 * Why awakeFromNib and not initWithCoder or another init*?
 *
 * initWithCoder is the designated initializer for UIViewController, so it's the
 * flavour of init* to use. Apparently, though, it may not be safe to use
 * accessors in initWithCoder (see http://stackoverflow.com/a/15508256).
 * 
 * This stuff could also be done in viewDidLoad, but that feels gross.
 */
- (void)awakeFromNib
{
    [super awakeFromNib];

    self.white = [[DMClock alloc] init];
    self.black = [[DMClock alloc] init];

    self.game = [[DMGame alloc] init];

    self.game.state = DMNotStarted;

    self.sliderTimes = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15,
                         @20, @25, @30, @35, @40, @45, @50, @55, @60,
                         @70, @80, @90, @100, @110, @120];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the colour of the background views
    [self.whiteBackground setBackgroundColor:[UIColor whiteColor]];
    [self.greyBackground setBackgroundColor:[UIColor ctr_lightGreyColor]];
    [self.blackButton setBackgroundColor:[UIColor blackColor]];

    // Rotate the white controls 180°
    self.startGameLabel.transform = CGAffineTransformMakeRotation(-M_PI);
    self.whiteButton.transform = CGAffineTransformMakeRotation(-M_PI);
    self.whiteSlider.transform = CGAffineTransformMakeRotation(-M_PI);

    // Set button colours
    [self.whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];

    [self.blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];

    [self.pauseButton setTitleColor:[UIColor ctr_blueColor] forState:UIControlStateNormal];
    [self.pauseButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted];
    [self.pauseButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted|UIControlStateSelected];
    [self.pauseButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateDisabled];

    [self.resetButton setTitleColor:[UIColor ctr_blueColor] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted];
    [self.resetButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted|UIControlStateSelected];
    [self.resetButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateDisabled];

    [self.timesButton setTitleColor:[UIColor ctr_blueColor] forState:UIControlStateNormal];
    [self.timesButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted];
    [self.timesButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted|UIControlStateSelected];
    [self.timesButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateDisabled];

    [self.cancelResetButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted];
    [self.confirmResetButton setTitleColor:[UIColor ctr_greyColor] forState:UIControlStateHighlighted];

    self.startGameLabel.textColor = [UIColor ctr_greyColor];

    // Set button titles
    [self.pauseButton setTitle:@"pause" forState:UIControlStateNormal];
    [self.pauseButton setTitle:@"pause" forState:UIControlStateHighlighted];
    [self.pauseButton setTitle:@"resume" forState:UIControlStateSelected];
    [self.pauseButton setTitle:@"resume" forState:UIControlStateHighlighted|UIControlStateSelected];

    [self.timesButton setTitle:@"times" forState:UIControlStateNormal];
    [self.timesButton setTitle:@"times" forState:UIControlStateHighlighted];
    [self.timesButton setTitle:@"done" forState:UIControlStateSelected];
    [self.timesButton setTitle:@"done" forState:UIControlStateHighlighted|UIControlStateSelected];

    // Configure the slider images
    UIEdgeInsets slider_insets = UIEdgeInsetsMake(0, 0, 0, 0);

    // These names are kind of counterintuitive... black track goes on white slider
    UIImage *sliderTrackBlack = [[UIImage imageNamed:@"slider-track-black"] resizableImageWithCapInsets:slider_insets];
    UIImage *sliderTrackWhite = [[UIImage imageNamed:@"slider-track-white"] resizableImageWithCapInsets:slider_insets];

    [self.whiteSlider setMinimumTrackImage:sliderTrackBlack forState:UIControlStateNormal];
    [self.whiteSlider setMaximumTrackImage:sliderTrackBlack forState:UIControlStateNormal];
    [self.whiteSlider setThumbImage:[UIImage imageNamed:@"slider-thumb-black"] forState:UIControlStateNormal];

    [self.blackSlider setMinimumTrackImage:sliderTrackWhite forState:UIControlStateNormal];
    [self.blackSlider setMaximumTrackImage:sliderTrackWhite forState:UIControlStateNormal];
    [self.blackSlider setThumbImage:[UIImage imageNamed:@"slider-thumb-white"] forState:UIControlStateNormal];

    // Hide the sliders initially
    self.whiteSliderTopConstraint.constant = -1 * self.whiteSlider.intrinsicContentSize.height;
    self.blackSliderBottomConstraint.constant = -1 * self.blackSlider.intrinsicContentSize.height;
    self.whiteSlider.alpha = 0.0f;
    self.blackSlider.alpha = 0.0f;

    // Hide some buttons too
//    self.resetButtonLeadingConstraint.constant = -20;
    self.resetButton.alpha = 0.0f;

//    self.pauseButtonTrailingConstraint.constant = 20;
    self.pauseButton.alpha = 0.0f;

    self.confirmResetLabel.alpha = 0.0f;
    self.cancelResetButton.alpha = 0.0f;
    self.confirmResetButton.alpha = 0.0f;

    self.whitePlayerHasEndedFirstTurn = NO;

    [self enableWhiteButton];
    [self disableBlackButton];

    [self updateInterface];

    self.whiteButton.alpha = 0.0f;
    self.blackButton.alpha = 0.0f;
    self.startGameLabel.alpha = 0.0f;
    self.timesButton.alpha = 0.0f;

    [self updateInterfaceWithChanges:^{
        self.whiteButton.alpha = 1.0f;
        self.blackButton.alpha = 0.4f;
        self.startGameLabel.alpha = 1.0f;
        self.timesButton.alpha = 1.0f;

        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidUnload
{
    // Xcode auto-added
    [self setWhiteSlider:nil];
    [self setBlackSlider:nil];
    [self setWhiteSliderTopConstraint:nil];
    [self setBlackSliderBottomConstraint:nil];

    [self setWhiteBackground:nil];
    [self setGreyBackground:nil];
    [self setBlackBackground:nil];
    [self setResetButtonLeadingConstraint:nil];
    [self setPauseButtonTrailingConstraint:nil];
    [self setTimesButton:nil];
    [self setStartGameLabel:nil];
    [self setCancelResetButton:nil];
    [self setConfirmResetButton:nil];
    [self setConfirmResetLabel:nil];
    [self setGreyBackgroundHeightConstraint:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SettingsSegue"]) {
        DMSettingsViewController *tc = segue.destinationViewController;

        tc.delegate = self;
        //        tc.whiteCurrentTime = floorf([white remainingTime].totalSeconds / 60);
        //        tc.blackCurrentTime = floorf([black remainingTime].totalSeconds / 60);
    }
}

#pragma mark -
#pragma mark View changes

- (void)updateInterfaceWithChanges:(void (^)(void))changes
{
    [self updateInterfaceWithChanges:changes animatable:YES];
}

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                        animatable:(BOOL)animatable
{
    [self updateInterfaceWithChanges:changes animatable:animatable completion:nil];
}

- (void)updateInterfaceWithChanges:(void (^)(void))changes
                       animatable:(BOOL)animatable
                       completion:(void (^)(BOOL))completion
{
    // Draw changes we aren't animating at all
    [self.view layoutIfNeeded];

    NSTimeInterval duration = 0.25;

    if (animatable) {
        [UIView animateWithDuration:duration animations:changes completion:completion];
    } else {
        [UIView transitionWithView:self.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:changes
                        completion:completion];
    }
}

// TODO this should be renamed 'update time labels' or something like that
- (void) updateInterface
{
    DMClockTime whiteTime = [self.white remainingTime];
    DMClockTime blackTime = [self.black remainingTime];

    if (whiteTime.totalSeconds <= 0) {
        [self stopTimer];
        [self endGameWithWinnerButton:self.blackButton loserButton:self.whiteButton];
        self.game.state = DMWhiteLostOnTime;
    }
    else if (blackTime.totalSeconds <= 0) {
        [self stopTimer];
        [self endGameWithWinnerButton:self.whiteButton loserButton:self.blackButton];
        self.game.state = DMBlackLostOnTime;
    } else {
        [self setButtonTitlesToTimes];
    }
}

- (void)setTitleOfButton:(UIButton *)button toTime:(DMClockTime)time
{
    NSString *displayTime = [NSString stringWithFormat:@"%d:%02d", time.minutes, time.seconds];

    [button setTitle:displayTime forState:UIControlStateNormal];
}

- (void)setButtonTitlesToTimes
{
    [self setTitleOfButton:self.whiteButton toTime:[self.white remainingTime]];
    [self setTitleOfButton:self.blackButton toTime:[self.black remainingTime]];
}

- (void)setButtonTitlesToWinLose
{
    [self.winnerButton setTitle:@"win" forState:UIControlStateNormal];
    [self.loserButton setTitle:@"lose" forState:UIControlStateNormal];

    [self.winnerButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.winnerButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [self.loserButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.loserButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
}

#pragma mark -
#pragma mark View change macros

- (void)enableWhiteButton
{
    self.whiteButton.enabled = YES;
    self.whiteButton.alpha = 1.0f;
}

- (void)disableWhiteButton
{
    self.whiteButton.enabled = NO;
    self.whiteButton.alpha = 0.2f;
}

- (void)enableBlackButton
{
    self.blackButton.enabled = YES;
    self.blackButton.alpha = 1.0f;
}

- (void)disableBlackButton
{
    self.blackButton.enabled = NO;
    self.blackButton.alpha = 0.4f;
}

- (void)showSliders
{
    self.whiteSlider.alpha = 1.0f;
    self.blackSlider.alpha = 1.0f;
    self.whiteSliderTopConstraint.constant = 20;
    self.blackSliderBottomConstraint.constant = 20;
}

- (void)hideSliders
{
    self.whiteSlider.alpha = 0.0f;
    self.blackSlider.alpha = 0.0f;
    self.whiteSliderTopConstraint.constant = -1 * self.whiteSlider.intrinsicContentSize.height;
    self.blackSliderBottomConstraint.constant = -1 * self.blackSlider.intrinsicContentSize.height;
}

- (void)enablePlayerButtonInteraction
{
    self.whiteButton.userInteractionEnabled = YES;
    self.blackButton.userInteractionEnabled = YES;
}

- (void)disablePlayerButtonInteraction
{
    self.whiteButton.userInteractionEnabled = NO;
    self.blackButton.userInteractionEnabled = NO;
}

-(void)showResetButton
{
//    self.resetButtonLeadingConstraint.constant = 0;
    self.resetButton.alpha = 1.0f;
}

- (void)hideResetButton
{
//    self.resetButtonLeadingConstraint.constant = -20;
    self.resetButton.alpha = 0.0f;
}

-(void)showTimesButton
{
    self.timesButton.alpha = 1.0f;
}

- (void)hideTimesButton
{
    self.timesButton.alpha = 0.0f;
}

- (void)showPauseButton
{
//    self.pauseButtonTrailingConstraint.constant = 0;
    self.pauseButton.alpha = 1.0f;
}

- (void)hidePauseButton
{
//    self.pauseButtonTrailingConstraint.constant = 20;
    self.pauseButton.alpha = 0.0f;
}

- (void)showStartGameLabel
{
    self.startGameLabel.alpha = 1.0f;
}

- (void)hideStartGameLabel
{
    self.startGameLabel.alpha = 0.0f;
}

- (void)resetStartGameLabelContent
{
    self.startGameLabel.text = @"tap here to start the game";
    [self.startGameLabel invalidateIntrinsicContentSize];
    [self.startGameLabel layoutIfNeeded];
}

- (void)replaceStartGameLabelContent
{
    self.startGameLabel.text = @"tap on your clock to end your turn";
    [self.startGameLabel invalidateIntrinsicContentSize];
    [self.startGameLabel layoutIfNeeded];
}

- (void)showConfirmResetArea
{
    self.greyBackgroundHeightConstraint.constant = 164;
    self.confirmResetLabel.alpha = 1.0f;
    self.cancelResetButton.alpha = 1.0f;
    self.confirmResetButton.alpha = 1.0f;
}

- (void)hideConfirmResetArea
{
    self.greyBackgroundHeightConstraint.constant = 72;
    self.confirmResetLabel.alpha = 0.0f;
    self.cancelResetButton.alpha = 0.0f;
    self.confirmResetButton.alpha = 0.0f;
}

- (void)resetPlayerButtonColors
{
    [self.whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.whiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.blackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)selectPauseButton
{
    self.pauseButton.selected = YES;

    [self.pauseButton invalidateIntrinsicContentSize];
}

- (void)deselectPauseButton
{
    self.pauseButton.selected = NO;

    [self.pauseButton invalidateIntrinsicContentSize];
}

- (void)selectTimesButton
{
    self.timesButton.selected = YES;

    [self.timesButton invalidateIntrinsicContentSize];
}

- (void)deselectTimesButton
{
    self.timesButton.selected = NO;

    [self.timesButton invalidateIntrinsicContentSize];
}

#pragma mark -
#pragma mark Game logic

- (void) startTimer
{
    // Replace this with CADisplayLink in the future
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateInterface)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void) stopTimer
{
    [self.timer invalidate];
}

- (void)startGame
{
    // Prevent screen from dimming
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    [self updateInterfaceWithChanges:^{
        self.pauseButton.enabled = YES;
        self.resetButton.enabled = NO;

        [self showResetButton];
        [self hideTimesButton];
        [self showPauseButton];

        [self.view layoutIfNeeded];
    }];

    self.game.state = DMWhiteTurn;
    [self.white start];
    [self startTimer];
}

- (void)pauseGame
{
    [self stopTimer];

    [UIApplication sharedApplication].idleTimerDisabled = NO;

    if (self.game.state == DMWhiteTurn) {
        self.game.state = DMWhitePaused;
        [self.white pause];

        self.resetButton.enabled = YES;
        [self selectPauseButton];

        [self updateInterfaceWithChanges:^{
            [self disableWhiteButton];

            if (self.whitePlayerHasEndedFirstTurn == NO) {
                [self hideStartGameLabel];
            }

            [self.view layoutIfNeeded];
        }];
    }
    else if (self.game.state == DMBlackTurn) {
        self.game.state = DMBlackPaused;
        [self.black pause];

        self.resetButton.enabled = YES;
        [self selectPauseButton];

        [self updateInterfaceWithChanges:^{
            [self disableBlackButton];

            [self.view layoutIfNeeded];
        }];
    }
}

- (void)resumeGame
{
    self.resetButton.enabled = NO;
    [self deselectPauseButton];

    [UIApplication sharedApplication].idleTimerDisabled = YES;

    if (self.game.state == DMWhitePaused) {
        self.game.state = DMWhiteTurn;

        [self updateInterfaceWithChanges:^{
            [self enableWhiteButton];
            if (self.whitePlayerHasEndedFirstTurn == NO) {
                [self showStartGameLabel];
            }

            [self.view layoutIfNeeded];
        }];

        [self.white resume];
    }
    else if (self.game.state == DMBlackPaused) {
        self.game.state = DMBlackTurn;

        [self updateInterfaceWithChanges:^{
            [self enableBlackButton];

            [self.view layoutIfNeeded];
        }];

        [self.black resume];
    }

    [self startTimer];
}

- (void)endGameWithWinnerButton:(UIButton *)winner loserButton:(UIButton *)loser
{
    [self stopTimer];

    [self.white pause];
    [self.black pause];

    [self enableBlackButton];
    [self enableWhiteButton];
//    [self disablePlayerButtonInteraction];
    [self hideStartGameLabel];

    self.winnerButton = winner;
    self.loserButton = loser;

    [self setButtonTitlesToWinLose];

    [self updateInterfaceWithChanges:^{
        self.pauseButton.enabled = NO;
        self.resetButton.enabled = YES;
        [self hidePauseButton];
    }];

    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark -
#pragma mark IBActions

- (IBAction)toggleTimes:(id)sender {
    if (self.game.state == DMNotStarted) {
        self.game.state = DMChangeTimes;
        [self selectTimesButton];
        [self.timesButton layoutIfNeeded];
        [self updateInterfaceWithChanges:^{
            [self showSliders];
            [self disablePlayerButtonInteraction];
            [self enableBlackButton];
            [self hideStartGameLabel];

            [self.view layoutIfNeeded];
        }];
    } else {
        self.game.state = DMNotStarted;
        [self deselectTimesButton];
        [self.timesButton layoutIfNeeded];
        [self updateInterfaceWithChanges:^{
            [self enablePlayerButtonInteraction];
            [self hideSliders];
            [self disableBlackButton];
            [self showStartGameLabel];

            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)togglePaused:(id)sender {
    if (self.game.state == DMWhiteTurn || self.game.state == DMBlackTurn) {
        [self pauseGame];
    }
    else {
        [self resumeGame];
    }
}

- (IBAction)toggleReset:(id)sender
{
    [self updateInterfaceWithChanges:^{
        [self showConfirmResetArea];
        self.resetButton.alpha = 0.0f;
        self.pauseButton.alpha = 0.0f;

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)confirmReset:(id)sender
{
    [self.white reset];
    [self.black reset];

    // Reset the game state
    self.game.state = DMNotStarted;

    self.whitePlayerHasEndedFirstTurn = NO;

    self.winnerButton = nil;
    self.loserButton = nil;

    [self updateInterface];

    self.pauseButton.enabled = NO;
    self.pauseButton.selected = NO;
    self.resetButton.enabled = NO;

    [self enablePlayerButtonInteraction];

    [self.pauseButton invalidateIntrinsicContentSize];

    [self resetStartGameLabelContent];

    [self updateInterfaceWithChanges:^{
        [self hideConfirmResetArea];
        [self enableWhiteButton];
        [self disableBlackButton];
        [self showStartGameLabel];
        [self showTimesButton];
        [self hideResetButton];
        [self hidePauseButton];
        [self resetPlayerButtonColors];

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)cancelReset:(id)sender
{
    [self updateInterfaceWithChanges:^{
        self.resetButton.alpha = 1.0f;
        self.pauseButton.alpha = 1.0f;

        [self hideConfirmResetArea];

        [self.view layoutIfNeeded];
    }];
}

- (IBAction)whiteButtonPressed:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToTimes];
    }
    else {
        [self disableWhiteButton];
        [self.view layoutIfNeeded];
    }
}

- (IBAction)whiteButtonPressCancelled:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self updateInterfaceWithChanges:^{
            [self enableWhiteButton];
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)endWhiteTurn:(id)sender {
    if (self.game.state == DMNotStarted) {

        [self updateInterfaceWithChanges:^{
            [self hideStartGameLabel];
            [self enableWhiteButton];

            [self.view layoutIfNeeded];
        } animatable:YES completion:^(BOOL finished){
            [self replaceStartGameLabelContent];

            [self updateInterfaceWithChanges:^{
                [self showStartGameLabel];

                [self.view layoutIfNeeded];
            }];

        }];

        [self startGame];
    }
    else if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self.white stop];

        self.game.state = DMBlackTurn;

        self.whitePlayerHasEndedFirstTurn = YES;

        [self updateInterfaceWithChanges:^{
            [self enableBlackButton];
            [self hideStartGameLabel];

            [self.view layoutIfNeeded];
        }];

        [self.black start];
    }
}

- (IBAction)blackButtonPressed:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToTimes];
    }
    else {
        [self disableBlackButton];
        [self.view layoutIfNeeded];
    }
}

- (IBAction)blackButtonPressCancelled:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self updateInterfaceWithChanges:^{
            [self enableBlackButton];
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)endBlackTurn:(id)sender {
    if (self.game.state == DMWhiteLostOnTime || self.game.state == DMBlackLostOnTime) {
        [self setButtonTitlesToWinLose];
    }
    else {
        [self.black stop];

        self.game.state = DMWhiteTurn;

        [self updateInterfaceWithChanges:^{
            [self enableWhiteButton];

            [self.view layoutIfNeeded];
        }];

        [self.white start];
    }
}

- (IBAction)whiteSliderValueChanged:(id)sender {
    int value = (int)floorf(self.whiteSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    [self.whiteButton setTitle:[NSString stringWithFormat:@"%d:00", time.intValue] forState:UIControlStateNormal];
}

- (IBAction)blackSliderValueChanged:(id)sender {
    int value = (int)floorf(self.blackSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    [self.blackButton setTitle:[NSString stringWithFormat:@"%d:00", time.intValue] forState:UIControlStateNormal];
}

- (IBAction)whiteSliderFinishedEditing:(id)sender {
    int value = (int)floorf(self.whiteSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    self.white.timeLimit = time.intValue * 60;

    [self.white reset];

    [self updateInterface];
}

- (IBAction)blackSliderFinishedEditing:(id)sender {
    int value = (int)floorf(self.blackSlider.value);

    NSNumber *time = self.sliderTimes[value - 1];

    self.black.timeLimit = time.intValue * 60;

    [self.black reset];

    [self updateInterface];
}

#pragma mark -
#pragma mark Delegate methods

- (void)timeSelectionViewController:(DMSettingsViewController *)controller
                 didSetWhiteSeconds:(NSTimeInterval)whiteSeconds
                       blackSeconds:(NSTimeInterval)blackSeconds
{
    self.white.timeLimit = whiteSeconds;
    self.black.timeLimit = blackSeconds;

    [self.white reset];
    [self.black reset];

    [self dismissViewControllerAnimated:YES completion:nil];

    [self updateInterface];
}

@end
