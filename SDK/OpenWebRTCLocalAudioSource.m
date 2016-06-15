//
//  OpenWebRTCLocalAudioSource.m
//
//  Copyright (c) 2016, Ericsson AB.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or other
//  materials provided with the distribution.

//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
//  OF SUCH DAMAGE.
//

@import Foundation;

#include "glib-object.h"
#include "OpenWebRTCLocalAudioSource.h"
#include "owr_local_media_source.h"
#include "owr_media_source.h"

#include <gst/gst.h>


//this is stupid and dangerous, but I'm left no choice.

struct _OwrMediaSourcePrivate {
    gchar *name;
    OwrMediaType media_type;
    
    OwrSourceType type;
    OwrCodecType codec_type;
    
    /* The bin or pipeline that contains the data producers */
    GstElement *source_bin;
    /* Tee element from which we can tap the source for multiple consumers */
    GstElement *source_tee;
};



@interface OpenWebRTCLocalAudioSource ()
{
    OwrLocalMediaSource *_mediaSource;
}
@end

@implementation OpenWebRTCLocalAudioSource

#pragma mark - Public methods

- (instancetype)initWithLocalMediaSource:(OwrLocalMediaSource *)mediaSource {
    if (self = [super init]) {
        _mediaSource = mediaSource;
        g_object_ref(mediaSource);
    }
    
    return self;
}

- (void)getValue:(void *)value {
    *((void **)value) = _mediaSource;
}

- (const char *)objCType {
    return @encode(OwrLocalMediaSource *);
}

- (void)dealloc {
    g_object_unref(_mediaSource);
    _mediaSource = nil;
}

- (double)volume {
    //double volume;
    //g_object_get(_mediaSource, "volume", &volume, NULL);
    //gst_element_get_state(_mediaSource->parent_instance.priv->source_bin)
    
    return 1.0;
}

- (void)setVolume:(double)localSourceVolume {
    //g_object_set(_mediaSource, "volume", localSourceVolume, NULL);
    
    if (localSourceVolume == 0) {
        gst_element_set_state(_mediaSource->parent_instance.priv->source_bin, GST_STATE_PAUSED);
    }
    else {
        gst_element_set_state(_mediaSource->parent_instance.priv->source_bin, GST_STATE_PLAYING);
    }

}

@end
