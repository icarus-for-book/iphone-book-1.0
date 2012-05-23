//
//  NetworkInfo.m
//  DeviceInfoControl
//
//  Created by 진섭 안 on 11. 8. 11..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "NetworkInfo.h"
#import "Reachability.h"

#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <string.h>
#include <stdbool.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>


#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6/* Ethernet CSMACD */
#endif

char*  getMacAddress(char* macAddress, char* ifName) {
    
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    const struct sockaddr_dl * dlAddr;
    const unsigned char* base;
    int i;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName,  cursor->ifa_name)==0 ) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                strcpy(macAddress, ""); 
                for (i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }    
    return macAddress;
}

char*  getIpAddress(char* ipAddress, char* ifName) 
{
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( cursor->ifa_addr->sa_family == AF_INET
                && (cursor->ifa_flags & IFF_LOOPBACK) == 0 
                && strcmp(ifName,  cursor->ifa_name)==0 ) {
                sprintf(ipAddress, "%s",inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr));
                NSLog(@"%s\t%s\t%#x", cursor->ifa_name, ipAddress, cursor->ifa_flags);
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }    
    return ipAddress;
}


@implementation NetworkInfo

@synthesize macAddress = _macAddress;
@synthesize connected = _connected;
@synthesize wifiAddress = _wifiAddress;
@synthesize cellAddress = _cellAddress;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _reachablilityForInternet = [Reachability reachabilityForInternetConnection];
        _reachablilityForLocalWifi = [Reachability reachabilityForLocalWiFi];
        
        [self update];

    }
    
    return self;
}

- (void) dealloc
{
    [_macAddress release];
    [_wifiAddress release];
    [_cellAddress release];
    [_reachablilityForInternet release];   
    [_reachablilityForLocalWifi release];
    [super dealloc];
}

- (void) update
{
    _connected = [_reachablilityForInternet currentReachabilityStatus] !=  NotReachable;
    
    // get mac
    char* macAddressString= (char*)malloc(18);
    macAddressString[0]='\0';
    _macAddress= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")
                                                   encoding:NSUTF8StringEncoding];
    
    free(macAddressString);
    
    // get wifi ip
    
    char* ipAddressString= (char*)malloc(18);
    ipAddressString[0]='\0';
    _wifiAddress = [[NSString alloc] initWithCString:getIpAddress(ipAddressString,"en0")
                                          encoding:NSUTF8StringEncoding];
    
    free(ipAddressString);
    
    // get 3g ip
    
    ipAddressString= (char*)malloc(18);
    ipAddressString[0]='\0';
    _cellAddress = [[NSString alloc] initWithCString:getIpAddress(ipAddressString,"pdp_ip0")
                                            encoding:NSUTF8StringEncoding];
    
    free(ipAddressString);
    
}


@end
