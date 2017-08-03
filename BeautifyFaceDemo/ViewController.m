//
//  ViewController.m
//  BeautifyFaceDemo
//
//  Created by guikz on 16/4/27.
//  Copyright © 2016年 guikz. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *beautifyButton;
@property (nonatomic, strong) UISlider *betaSlider;
@property (nonatomic, strong) UILabel *betaLabel;
@property (nonatomic, strong) UISlider *intensitySlider;
@property (nonatomic, strong) UILabel *intensityLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterView.center = self.view.center;
    
    [self.view addSubview:self.filterView];
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beautifyButton.backgroundColor = [UIColor whiteColor];
    [self.beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautifyButton];
    [self.beautifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
    }];

    [self.view addSubview:self.betaSlider];
    [self.view addSubview:self.betaLabel];
    [self.view addSubview:self.intensitySlider];
    [self.view addSubview:self.intensityLabel];

    [_betaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.leading.equalTo(self.view).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [_betaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_betaSlider);
        make.leading.equalTo(_betaSlider.mas_trailing).offset(20);
    }];
    [_intensitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_betaSlider.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(20);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    [_intensityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_intensitySlider);
        make.leading.equalTo(_intensitySlider.mas_trailing).offset(20);
    }];

}

- (void)beautify {
    if (self.beautifyButton.selected) {
        self.beautifyButton.selected = NO;
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.filterView];
    }
    else {
        self.beautifyButton.selected = YES;
        [self.videoCamera removeAllTargets];
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] initWithBeta:self.betaSlider.value intensity:self.intensitySlider.value];
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
    }
}

- (void)sliderTouchEnd:(UISlider *)slider {
    if (self.beautifyButton.selected) {
        [self.videoCamera removeAllTargets];
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] initWithBeta:self.betaSlider.value intensity:self.intensitySlider.value];
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
    }
}

- (void)sliderValueChanged:(UISlider *)slider {
    if (_betaSlider == slider) {
        _betaLabel.text = [NSString stringWithFormat:@"beta:%f", _betaSlider.value];
    } else if (_intensitySlider == slider) {
        _intensityLabel.text = [NSString stringWithFormat:@"intensity:%f", _intensitySlider.value];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UISlider *)betaSlider {
    if (!_betaSlider) {
        _betaSlider = [UISlider new];
        _betaSlider.minimumValue = 1.000001;
        _betaSlider.maximumValue = 10;
        [_betaSlider addTarget:self
                        action:@selector(sliderTouchEnd:)
              forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_betaSlider addTarget:self
                        action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _betaSlider;
}

- (UILabel *)betaLabel {
    if (!_betaLabel) {
        _betaLabel = [UILabel new];
        _betaLabel.textColor = [UIColor greenColor];
        _betaLabel.text = @"beta:";
    }
    return _betaLabel;
}

- (UISlider *)intensitySlider {
    if (!_intensitySlider) {
        _intensitySlider = [UISlider new];
        _intensitySlider.minimumValue = 0;
        _intensitySlider.maximumValue = 1;
        [_intensitySlider addTarget:self
                        action:@selector(sliderTouchEnd:)
              forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_intensitySlider addTarget:self
                        action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _intensitySlider;
}

- (UILabel *)intensityLabel {
    if (!_intensityLabel) {
        _intensityLabel = [UILabel new];
        _intensityLabel.textColor = [UIColor greenColor];
        _intensityLabel.text = @"intensity:";
    }
    return _intensityLabel;
}

@end
