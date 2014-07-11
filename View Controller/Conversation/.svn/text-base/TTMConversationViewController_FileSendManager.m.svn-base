//
//  TTMConversationViewController_FileSendManager.m
//  TextTimeMachine
//
//  Created by Dinesh Mehta on 4/26/14.
//  Copyright (c) 2014 Dinesh Mehta. All rights reserved.
//

#import "TTMConversationViewController.h"


#ifndef VIEW_CONTROLLER_MAIN_BODY
@implementation TTMConversationViewController
#endif
@synthesize photo = _photo;
-(UIImage *)generateThumbImage : (NSURL *)url
{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [TTMConversationViewController generatePhotoThumbnail:[UIImage imageWithCGImage:imageRef]];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}
-(void)sendVideoMediaType:(NSURL *)urlvideo returnBlock:(FileReturnName)block{
    UIBackgroundTaskIdentifier taskId = [[UIApplication sharedApplication]
                                         beginBackgroundTaskWithExpirationHandler:NULL];

    self.fileReturnBlock = block;
    NSError *error = nil;
    NSDictionary * properties = [[NSFileManager defaultManager] attributesOfItemAtPath:urlvideo.path error:&error];
    NSNumber * size = [properties objectForKey: NSFileSize];
    NSLog(@"size: %@", size);
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:urlvideo];
    CMTime duration = playerItem.duration;
    float seconds = CMTimeGetSeconds(duration);
    NSLog(@"duration: %.2f", seconds);
    UIImage *thumbNail = [self generateThumbImage:urlvideo];
    /*urlvideo contains the URL of that video file that has to be uploaded. Then convert the url into NSString type because setFile method requires NSString as a parameter
     */
    NSString *urlString=[urlvideo path];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@?type=%@",baseURLForIMageProcess, @"3"]];
    
    request = [ASIFormDataRequest requestWithURL:url];
    NSLog(@"Image data is created");
    //[request setPostValue:videoName forKey:@"urlvideo"];
    [request setFile:urlString forKey:@"attachment"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    NSString *fileName = [NSString stringWithFormat:@"thumnail%@.png",@"image"];
    NSData *imageData = UIImagePNGRepresentation(thumbNail);
    [request setImageRef:thumbNail];
    [request addData:imageData
        withFileName:fileName
      andContentType:@"image/jpeg" forKey:@"attachment"];
    [request setFailedFileName:[urlvideo lastPathComponent]];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setUploadProgressDelegate:self];
    [request setTimeOutSeconds:50000];
    [request startAsynchronous];
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseStatusCode %@",[request responseString]);
    [[UIApplication sharedApplication] endBackgroundTask:taskId];

}
- (UIImage *)generatePhotoThumbnail:(UIImage *)image withSide:(CGFloat)ratio
{
    UIImage *thumbnail;
    // Create a thumbnail version of the image for the event object.
    CGSize size = image.size;
    CGSize croppedSize;
    
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension.
    // So clip the extra portion from x or y coordinate
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    
    return thumbnail;
}
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image {
    CGSize destinationSize = CGSizeMake(300,200);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)sendImageMediaType:(UIImage *)image imageName:(NSString *)image_name returnBlock:(FileReturnName)block{
    
    self.fileReturnBlock = block;
    UIBackgroundTaskIdentifier taskId = [[UIApplication sharedApplication]
                                         beginBackgroundTaskWithExpirationHandler:NULL];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?type=%@",baseURLForIMageProcess, @"2"]];
    ASIFormDataRequest *requestCreated = [ASIFormDataRequest requestWithURL:url];
    
    [requestCreated setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",image_name];
    NSString *thumbNail = [NSString stringWithFormat:@"Thumbnail%@.jpg",image_name];
    
    [requestCreated addPostValue:fileName forKey:@"attachment"];
    [requestCreated addPostValue:fileName forKey:@"attachment"];
    // Upload an image
    NSData *imageData = UIImagePNGRepresentation(image);
   NSData *thumbNailImageData = UIImagePNGRepresentation([TTMConversationViewController generatePhotoThumbnail:image]);
  // NSData *thumbNailImageData = [[NSData alloc] initWithData:UIImagePNGRepresentation([self scaleAndRotateImage:image])];//UIImageJPEGRepresentation([self generatePhotoThumbnail:image] ,0.0);
    if (thumbNailImageData)NSLog(@"Image Data available");
    [requestCreated setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"attachment"];
    [requestCreated setFailedFileName:fileName];
    [requestCreated setImageRef:image];
    [requestCreated addData:thumbNailImageData
               withFileName:thumbNail
             andContentType:@"image/jpeg" forKey:@"attachment"];
    [requestCreated setDelegate:self];
    [requestCreated setDidFinishSelector:@selector(uploadRequestFinished:)];
    [requestCreated setDidFailSelector:@selector(uploadRequestFailed:)];
    [requestCreated setTimeOutSeconds:50000];
    [requestCreated startAsynchronous];
    [[UIApplication sharedApplication] endBackgroundTask:taskId];

}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request1{
    NSString *responseString = [request1 responseString];
    NSLog(@"Upload response %@", responseString);
    
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSASCIIStringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    TTMMediaModel *mediaURLs = [[TTMMediaModel alloc] init];
    [mediaURLs setThumbnail:[JSON objectForKey:@"thumbnailFilePath"]];
    [mediaURLs setOriginal_url:[JSON objectForKey:@"uploadedFileServerPath"]];
    [mediaURLs setThumbNailImage:request1.imageRef];
    self.fileReturnBlock(mediaURLs, nil);
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)request1{
    self.fileReturnBlock(nil, [request1 error]);
    
    NSLog(@" Error - Statistics file upload failed: \"%@\" %@",[[request1 error] localizedDescription], request1.failedFileName);
    TTMMediaModel *mediaURLs = [[TTMMediaModel alloc] init];
    [mediaURLs setThumbnail:request1.failedFileName];
    [mediaURLs setOriginal_url:request1.failedFileName];
    [mediaURLs setThumbNailImage:request1.imageRef];

    self.fileReturnBlock(mediaURLs, [request1 error]);
}

- (void)requestStarted:(ASIHTTPRequest *)theRequest {
    NSLog(@"response started new::%@",[theRequest responseString]);
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    NSLog(@"response finished new ::%@",[theRequest responseString]);
    NSDictionary *JSON =
    [NSJSONSerialization JSONObjectWithData: [[theRequest responseString] dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    TTMMediaModel *mediaURLs = [[TTMMediaModel alloc] init];
    [mediaURLs setThumbnail:[JSON objectForKey:@"thumbnailFilePath"]];
    [mediaURLs setOriginal_url:[JSON objectForKey:@"uploadedFileServerPath"]];
    [mediaURLs setThumbNailImage:theRequest.imageRef];

    self.fileReturnBlock(mediaURLs, nil);
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Video upload to server successfully!"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alert show];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest {
    NSLog(@"response Failed new ::%@, Error:%@",[theRequest responseString],[theRequest error]);
    NSLog(@" Error - Statistics file upload failed: \"%@\" %@",[[theRequest error] localizedDescription], theRequest.failedFileName);
    TTMMediaModel *mediaURLs = [[TTMMediaModel alloc] init];
    [mediaURLs setThumbnail:theRequest.failedFileName];
    [mediaURLs setOriginal_url:theRequest.failedFileName];
    self.fileReturnBlock(mediaURLs, [theRequest error]);
//    if([theRequest error]){
//    NSDictionary *JSON =
//    [NSJSONSerialization JSONObjectWithData: [[theRequest responseString] dataUsingEncoding:NSUTF8StringEncoding]
//                                    options: NSJSONReadingMutableContainers
//                                      error: nil];
//    
//    TTMMediaModel *mediaURLs = [[TTMMediaModel alloc] init];
//    [mediaURLs setThumbnail:[JSON objectForKey:@"thumbnailFilePath"]];
//    [mediaURLs setOriginal_url:[JSON objectForKey:@"uploadedFileServerPath"]];
//        
//    self.fileReturnBlock(mediaURLs, nil);
//    self.fileReturnBlock(nil, [theRequest error]);
//    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Video Upload to server failed, please try again"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //    [alert show];
}
#ifndef VIEW_CONTROLLER_MAIN_BODY
@end
#endif
