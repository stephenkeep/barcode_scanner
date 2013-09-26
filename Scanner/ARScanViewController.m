//
//  ARViewController.m
//  Scanner
//
//  Created by Stephen Keep on 25/09/2013.
//  Copyright (c) 2013 Red Ant Ltd. All rights reserved.
//

#import "ARScanViewController.h"
#import "ZXingObjC.h"

@interface ARScanViewController ()

@property (nonatomic) GPUImageStillCamera *stillCamera;
@property (nonatomic) GPUImageView *imageView;
@property (nonatomic) GPUImageGammaFilter *filter;
@property (weak, nonatomic) NSTimer *timer;
@property BOOL found;

@end

@implementation ARScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"hello");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initCamera];
}

- (void)initCamera {
    
    if (!self.stillCamera) {
        self.stillCamera = [[GPUImageStillCamera alloc] init];
        self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
        self.filter = [[GPUImageGammaFilter alloc] init];
        [self.stillCamera addTarget:self.filter];
        
        self.imageView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.imageView];
        [self.view sendSubviewToBack:self.imageView];
        
        [self.filter addTarget:self.imageView];
        
    }
    
    [self startCamera];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(newProcessedImage) userInfo:nil repeats:YES];
}

-(void)startCamera {
    [self.stillCamera startCameraCapture];
}

-(void)newProcessedImage {
    
    ARScanViewController *__weak weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        @autoreleasepool {
            
            UIImage *image = [weakSelf.filter imageFromCurrentlyProcessedOutput];
            
            CGImageRef imageToDecode = image.CGImage;
            
            if (imageToDecode) {
                ZXLuminanceSource* source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
                ZXBinaryBitmap* bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
                
                source = nil;
                
                NSError* error = nil;
                
                ZXDecodeHints* hints = [ZXDecodeHints hints];
                ZXMultiFormatReader* reader = [ZXMultiFormatReader reader];
                
                ZXResult* result = [reader decode:bitmap
                                            hints:hints
                                            error:&error];
                if (result && !weakSelf.found) {
                    weakSelf.found = YES;
                    
                    // The barcode format, such as a QR code or UPC-A
                    //ZXBarcodeFormat format = result.barcodeFormat;
                    
                    NSString* contents = result.text;
                    NSURL *url = [NSURL URLWithString:contents];
                    
                    BOOL validURL = [[UIApplication sharedApplication] canOpenURL:url];
                    
                    if (validURL) {
                        [weakSelf openInSafari:url];
                    }
                    
                    [weakSelf.stillCamera stopCameraCapture];
                    [weakSelf.timer invalidate];
                    weakSelf.timer = nil;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        [weakSelf dismissViewControllerAnimated:YES completion:^(void) {
  
                            if (!validURL) {
                                
                                UIPasteboard *pb = [UIPasteboard generalPasteboard];
                                [pb setString:contents];
                                
                                UIAlertView *av = [[UIAlertView alloc ]initWithTitle:@"Success!" message:[NSString stringWithFormat:@"Would you like to copy this barcode: %@",contents] delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
                                [av show];
                                
                            }
                           
                        }];
                        
                    });
                
                    
                }

            }
            
         }
    });

}

- (void)openInSafari:(NSURL *) url {
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)closeView {
    
    [self.stillCamera stopCameraCapture];
    [self.timer invalidate];
    self.timer = nil;
    
    [self dismissViewControllerAnimated:YES completion:^(void) {
        

    }];
}

@end
