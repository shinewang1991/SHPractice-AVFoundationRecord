//
//  ViewController.m
//  SHPractice-AVFoundation
//
//  Created by Shine on 09/04/2018.
//  Copyright © 2018 shine. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
@property (nonatomic, strong) dispatch_queue_t sampleBufferQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //需要用到的类
    // AVCaptureSession
    // AVCaptureInput
    // AVCaptureOutput
    // AVCaptureConnection
    // AVCaptureAudioDataOutput
    // AVCaptureVideoDataOutput
    // AVCaptureVideoPreviewLayer 预览视图
    // AVAssetWriter //写入文件
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    //input
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:NULL];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.cameraDevice error:NULL];
    [session addInput:audioInput];
    [session addInput:videoInput];
    
    //output
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    NSNumber *firstAvailableFormatType = videoOutput.availableVideoCVPixelFormatTypes.firstObject;
//    videoOutput.videoSettings = @{kCVPixelBufferPixelFormatTypeKey:firstAvailableFormatType};
    videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:firstAvailableFormatType,kCVPixelBufferPixelFormatTypeKey, nil];
    [videoOutput setSampleBufferDelegate:self queue:self.sampleBufferQueue];
    
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [audioOutput setSampleBufferDelegate:self queue:self.sampleBufferQueue];

    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (AVCaptureDevice *)cameraDevice{
    if(!_cameraDevice){
    _cameraDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];   //后置摄像头
    }
    return _cameraDevice;
}

- (AVCaptureDevice *)audioDevice{
    if(!_audioDevice){
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio]; //麦克风
    }
    return _audioDevice;
}

- (dispatch_queue_t)sampleBufferQueue{
    if(!_sampleBufferQueue){
        _sampleBufferQueue = dispatch_queue_create("shine.avfoundation", DISPATCH_QUEUE_SERIAL); //串行队列
    }
    return _sampleBufferQueue;
}
@end
