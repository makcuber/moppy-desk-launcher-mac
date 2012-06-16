//
//  AppDelegate.h
//  MoppyDesk
//
//  Created by James Richardson on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface AppDelegate : NSObject <NSApplicationDelegate>{

    
    NSString *sourceFilePath;
    NSString *destinationFilePath;

    
}

-(void)startCopy;
-(void)checkForLibraries;
-(void)checkForProc;
-(void)run;

@end

