//
//  ViewController.m
//  Metronome
//
//  Created by Anant Kannaik on 18/05/18.
//  Copyright © 2018 Anant Kannaik. All rights reserved.
//

#import "ViewController.h"
#import "MetronomeNew.h"

@interface ViewController () <MetronomeDelegate>

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *tempoLabel;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIView *pendulumView;

@end

@implementation ViewController {
    double tempo;
    MetronomeNew *metronome;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tempo = 80;
    NSURL *highUrl = [[NSBundle mainBundle] URLForResource:@"High" withExtension:@"wav"];
    metronome = [[MetronomeNew alloc] init:highUrl];
    metronome.delegate = self;
    
    self.stepper.stepValue = 1;
    self.stepper.minimumValue = 40;
    self.stepper.maximumValue = 200;
    self.stepper.value = tempo;
    self.tempoLabel.text = [NSString stringWithFormat:@"%d BPM", (int)tempo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPlayback:(UIButton *)sender {
    [metronome setTempo:tempo];
    [metronome start];
    [self startMetronomeAnimation];
}

- (IBAction)stopPlayback:(UIButton *)sender {
    [metronome stop];
    [self stopMetronomeAnimation];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    tempo = self.stepper.value;
    [metronome setTempo:tempo];
    self.tempoLabel.text = [NSString stringWithFormat:@"%d BPM", (int)tempo];
}

#pragma MetronomeDelegate methods
- (void)metronomeTicking:(MetronomeNew *)metronome bar:(SInt32)bar beat:(SInt32)beat {
    
}

- (void)metronomeTicking {
    
}

#pragma Metronome methods
- (void)startMetronomeAnimation {
    [UIView animateKeyframesWithDuration:60.0/tempo delay:0.0 options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse | UIViewAnimationOptionTransitionNone animations:^{
        self.sliderView.frame = [self getEdgeBound];
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            self.sliderView.alpha = 0.2;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.sliderView.alpha = 1.0;
        }];
    } completion:nil];
}

- (void)stopMetronomeAnimation {
    [self.sliderView.layer removeAllAnimations];
}

- (CGRect)getEdgeBound {
    if (self.sliderView.frame.origin.x == 0.0) {
        CGRect rightBound = self.sliderView.frame;
        rightBound.origin.x = self.barView.frame.size.width - self.sliderView.frame.size.width;
        return rightBound;
    } else {
        CGRect leftBound = self.sliderView.frame;
        leftBound.origin.x = 0.0;
        return leftBound;
    }
}

@end
