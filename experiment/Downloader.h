//
//  Downloader.h
//  experiment
//
//  Created by Alexander Igantev on 11/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject

- (void)downloadWithURL:(NSURL *)URL
             completion:(void (^)(NSData *data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
