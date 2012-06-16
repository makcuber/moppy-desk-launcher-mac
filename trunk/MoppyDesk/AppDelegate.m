//
//  AppDelegate.m
//  MoppyDesk
//
//  Created by James Richardson on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "STPrivilegedTask.h"

#include <sys/sysctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include <unistd.h>

@implementation AppDelegate


- (void)dealloc
{
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}

- (void)awakeFromNib;
{
    NSLog(@"Launching MoppyDesk ... ");
    
    [self checkForLibraries];
    
    [self checkForProc];
    
    [self run];

}

-(void)checkForProc{
   
    //TO DO - check if moppy java is already running
    
    
    /*struct kinfo_proc *procs = NULL, *newprocs;
    int i, mib[4], st, nprocs, nkilled = 0;
    size_t miblen, size = 0;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_ALL;
    mib[3] = 0;
    miblen = 3;
    
    st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    do {
        size += size / 10;
        newprocs = realloc(procs, size);
        if (newprocs == 0) {
            if (procs)
                free(procs);
            return -1;
        }
        procs = newprocs;
        st = sysctl(mib, miblen, procs, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == -1 || size % sizeof(struct kinfo_proc) != 0)
        return -1;
    nprocs = size / sizeof(struct kinfo_proc);
    for (i = 0; i < nprocs; i++) {
        // access proc structure through procs[i]., e.g. for the process name
        //if (strncmp(processName, procs[i].kp_proc.p_comm, MAXCOMLEN) == 0) {
            // ...
        //}
        
        NSLog(@"proc %s %i %c",procs[i].kp_proc.p_comm,procs[i].kp_proc.p_pid,procs[i].kp_proc.p_nice);
    }
    // free procs when done
    if (procs)
        free(procs);*/

}

-(void)run{
    
    NSArray *args;
 
    NSString *path_moppydesk = [[NSBundle mainBundle] pathForResource:@"MoppyDesk" ofType:@"jar"];

    //required files exist
    //launch the jar as root
    NSString *jar = [NSString stringWithFormat:@"-jar"];
    
    args = [NSArray arrayWithObjects:jar, path_moppydesk, nil];
    
    STPrivilegedTask *java_task = [[STPrivilegedTask alloc] initWithLaunchPath:@"/usr/bin/java" arguments:args];
    
    [java_task launch];
    
    NSLog(@"MoppyDesk - Quitting...");
    
    [NSApp terminate:nil];
    
}

-(void)checkForLibraries{
        
    NSFileManager *mgm = [[NSFileManager alloc] init];
    
    NSArray *args_lock;
    
    NSString *path_librxtxSerial = [[NSBundle mainBundle] pathForResource:@"librxtxSerial" ofType:@"jnilib"];
    
    NSString *path_RXTXcomm = [[NSBundle mainBundle] pathForResource:@"RXTXcomm" ofType:@"jar"];
    
    NSString *path_exists_librxtxSerial = @"/Library/Java/Extensions/librxtxSerial.jnilib";
    
    NSString *path_exists_RXTXcomm = @"/Library/Java/Extensions/RXTXcomm.jar";
    
    NSString *path_exists_lock = @"/var/lock";
    
    NSString *path_NOTexists = @"/Library/Java/Extensions";
    
    //check for librxtxSerial
    //if not exists, copy it
    if(![mgm fileExistsAtPath:path_exists_librxtxSerial]){

        [NSApp activateIgnoringOtherApps:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Java Library Missing", @"Error message")];
        [alert setInformativeText:NSLocalizedString(@"The Java library librxtxSerial.jnilib is missing. Do you want to install it?",@"Java missing library information")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yes button title")];
        [alert addButtonWithTitle:NSLocalizedString(@"No", @"No button title")];
        
        NSInteger clickedButton = [alert runModal];
        [alert release];
        
        if (clickedButton == NSAlertFirstButtonReturn) {
            
            sourceFilePath  = path_librxtxSerial;
            destinationFilePath = path_NOTexists;
            
            NSLog(@"Installing librxtxSerial.jnilib ... ");

            [self startCopy];
 
        }
        
        if (clickedButton == NSAlertSecondButtonReturn) {
            
            NSLog(@"EXIT - librxtxSerial.jnilib missing!");
            [NSApp terminate:nil];
        }
    }
    
    //check for RXTXcomm.jar
    //if not exists, copy it
    if(![mgm fileExistsAtPath:path_exists_RXTXcomm]){
        
        [NSApp activateIgnoringOtherApps:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Java Library Missing", @"Error message")];
        [alert setInformativeText:NSLocalizedString(@"The Java library RXTXcomm.jar is missing. Do you want to install it?",@"Java missing library information")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yes button title")];
        [alert addButtonWithTitle:NSLocalizedString(@"No", @"No button title")];
        
        NSInteger clickedButton = [alert runModal];
        [alert release];
        
        if (clickedButton == NSAlertFirstButtonReturn) {
            
            sourceFilePath  = path_RXTXcomm;
            destinationFilePath = path_NOTexists;
            
            NSLog(@"Installing RXTXcomm.jar ... ");
            
            [self startCopy];
            
        }
        
        if (clickedButton == NSAlertSecondButtonReturn) {
            
            NSLog(@"EXIT - librxtxSerial.jnilib missing!");
            [NSApp terminate:nil];
        }
    }
    
    //check for lock file
    //if not exists, create it
    if(![mgm fileExistsAtPath:path_exists_lock]){
        
        [NSApp activateIgnoringOtherApps:YES];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSInformationalAlertStyle];
        [alert setMessageText:NSLocalizedString(@"Java Library Missing", @"Error message")];
        [alert setInformativeText:NSLocalizedString(@"The lock folder /var/lock is missing. Do you want to create it?",@"Lock folder missing information")];
        [alert addButtonWithTitle:NSLocalizedString(@"Yes", @"Yes button title")];
        [alert addButtonWithTitle:NSLocalizedString(@"No", @"No button title")];
        
        NSInteger clickedButton = [alert runModal];
        [alert release];
        
        
        if (clickedButton == NSAlertFirstButtonReturn) {
            
            NSLog(@"Creating /var/lock/ ... ");
            
            args_lock = [NSArray arrayWithObjects:path_exists_lock,nil];
            STPrivilegedTask *lock_task = [[STPrivilegedTask alloc] initWithLaunchPath:@"/bin/mkdir" arguments:args_lock];
            [lock_task launch];
            
        }
        
        if (clickedButton == NSAlertSecondButtonReturn) {
            
            NSLog(@"EXIT - /var/lock/ missing!");
            [NSApp terminate:nil];
        }
        
    }
        
   

}



- (void)startCopy
{
    // Use the NSFileManager to obtain the size of our source file in bytes.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *sourceAttributes = [fileManager fileAttributesAtPath:sourceFilePath traverseLink:YES];
    NSNumber *sourceFileSize;
    
    if (sourceFileSize = [sourceAttributes objectForKey:NSFileSize] )
    {
        // Set the max value to our source file size
        //NSLog(@"SOURCE SIZE: %@",sourceFileSize);

    }
    else
    {
        // Couldn't get the file size so we need to bail.
        NSLog(@"Unable to obtain size of file being copied.");
        return;
    }

    
    
    
    // Get the current run loop and schedule our callback
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    FSFileOperationRef fileOp = FSFileOperationCreate(kCFAllocatorDefault);
    
    OSStatus status = FSFileOperationScheduleWithRunLoop(fileOp, runLoop, kCFRunLoopDefaultMode);
    if( status )
    {
        NSLog(@"Failed to schedule operation with run loop: %@", status);
        return;
    }
    
    // Create a filesystem ref structure for the source and destination and
    // populate them with their respective paths from our NSTextFields.
    FSRef source;
    FSRef destination;
    
    FSPathMakeRef( (const UInt8 *)[sourceFilePath fileSystemRepresentation], &source, NULL );
    
    Boolean isDir = true;
    FSPathMakeRef( (const UInt8 *)[destinationFilePath   fileSystemRepresentation], &destination, &isDir );    
    
    // Start the async copy.
    NSLog(@"copying");
    status = FSCopyObjectAsync (fileOp,
                                &source,
                                &destination, // Full path to destination dir
                                NULL, // Use the same filename as source
                                kFSFileOperationDefaultOptions,
                                NULL,
                                1.0,
                                NULL);
    
    CFRelease(fileOp);
    
    if( status )
    {
        NSLog(@"Failed to begin asynchronous object copy: %@", status);
    }
}


@end




