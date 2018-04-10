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

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
@property (nonatomic, strong) dispatch_queue_t sampleBufferQueue;

@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
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
    self.session = session;
    
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
    
    AVCaptureConnection *audioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
    _audioConnection = audioConnection;
    
    AVCaptureConnection *videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    _videoConnection = videoConnection;
    
    [session addOutput:audioOutput];
    [session addOutput:videoOutput];
    
    
}

- (IBAction)startBtnClicked:(id)sender{
    [self.view.layer addSublayer:self.previewLayer];
    [self.session addConnection:_audioConnection];
    [self.session addConnection:_videoConnection];
    [self.session startRunning];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"didOutputSampleBuffer ---- %@",sampleBuffer);
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

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if(!_previewLayer){
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.frame = self.view.bounds;
    }
    return _previewLayer;
}
@end
