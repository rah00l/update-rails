/*************************************************************************
    This code is from Dynamic Web Coding at dyn-web.com
    Copyright 2001-2008 by Sharon Paine 
    See Terms of Use at www.dyn-web.com/business/terms.php
    regarding conditions under which you may use this code.
    This notice must be retained in the code as is!
    
    Version date: August 2008
    supports sequential and random rotation and IE win transition filter
    requires dw_event.js 2008 version
*************************************************************************/

// arguments: image id, rotation speed, path to images (optional), 
// new (optional) arguments: for transitions, mouse events and random rotation 
function dw_Rotator(id, speed, path, bTrans, bMouse, bRand) {
    var imgObj = document.getElementById(id); 
    if (!imgObj) { // in case name, not id attached to image
        imgObj = document.images[id];
        if (!imgObj) return;
        imgObj.id = id;
    }
    this.id = id; this.speed = speed || 4500; // default speed of rotation
    this.path = path || "";  this.bRand = bRand;
    this.ctr = 0; this.timer = 0; this.imgs = []; 
    this._setupLink(imgObj, bMouse);
    this.bTrans = bTrans && typeof imgObj.filters != 'undefined';
    var index = dw_Rotator.col.length; dw_Rotator.col[index] = this;
    this.animString = "dw_Rotator.col[" + index + "]";
}

dw_Rotator.col = []; // hold instances
dw_Rotator.resumeDelay = 400; // onmouseout resume rotation after delay

// mouse events pause/resume
dw_Rotator.prototype._setupLink = function(imgObj, bMouse) { 
    if ( imgObj.parentNode && imgObj.parentNode.tagName.toLowerCase() == 'a' ) {
        var parentLink = this.parentLink = imgObj.parentNode;
        if (bMouse) {
            dw_Event.add(parentLink, 'mouseover', dw_Rotator.pause);
            dw_Event.add(parentLink, 'mouseout', dw_Rotator.resume);
        }
    }
}

// so instance can be retrieved by id (as well as by looping through col)
dw_Rotator.getInstanceById = function(id) {
    var len = dw_Rotator.col.length, obj;
    for (var i=0; i<len; i++) {
        obj = dw_Rotator.col[i];
        if (obj.id && obj.id == id ) {
            return obj;
        }
    }
    return null;
}

dw_Rotator.prototype.on_rotate = function() {}

dw_Rotator.prototype.addImages = function() { // preloads images
    var img;
    for (var i=0; arguments[i]; i++) {
        img = new Image();
        img.src = this.path + arguments[i];
        this.imgs[this.imgs.length] = img;
    }
}

dw_Rotator.prototype.rotate = function() {
    clearTimeout(this.timer); this.timer = null;
    var imgObj = document.getElementById(this.id);
    if ( this.bRand ) {
        this.setRandomCtr();
    } else {
        if (this.ctr < this.imgs.length-1) this.ctr++;
        else this.ctr = 0;
    }
    if ( this.bTrans ) {
        this.doImageTrans(imgObj);
    } else {
        imgObj.src = this.imgs[this.ctr].src;
    }
    this.swapAlt(imgObj); this.prepAction(); this.on_rotate();
    this.timer = setTimeout( this.animString + ".rotate()", this.speed);   
}

dw_Rotator.prototype.setRandomCtr = function() {
    var i = 0, ctr;
    do { 
        ctr = Math.floor( Math.random() * this.imgs.length );
        i++; 
    } while ( ctr == this.ctr && i < 6 )// repeat attempts to get new image, if necessary
    this.ctr = ctr;
}

dw_Rotator.prototype.doImageTrans = function(imgObj) {
    imgObj.style.filter = 'blendTrans(duration=1)';
    if (imgObj.filters.blendTrans) imgObj.filters.blendTrans.Apply();
    imgObj.src = this.imgs[this.ctr].src;
    imgObj.filters.blendTrans.Play(); 
}

dw_Rotator.prototype.swapAlt = function(imgObj) {
    if ( !imgObj.setAttribute ) return;
    if ( this.alt && this.alt[this.ctr] ) {
        imgObj.setAttribute('alt', this.alt[this.ctr]);
    }
    if ( this.title && this.title[this.ctr] ) {
        imgObj.setAttribute('title', this.title[this.ctr]);
    }
}

dw_Rotator.prototype.prepAction = function() {
    if ( this.actions && this.parentLink && this.actions[this.ctr] ) {
        if ( typeof this.actions[this.ctr] == 'string' ) {
            this.parentLink.href = this.actions[this.ctr];
        } else if ( typeof this.actions[this.ctr] == 'function' ) {
            // to execute function when linked image clicked 
            // passes id used to uniquely identify instance  
            // retrieve it using the dw_Rotator.getInstanceById function 
            // so any property of the instance could be obtained for use in the function 
            var id = this.id;
            this.parentLink.href = "javascript: void " + this.actions[this.ctr] + "('" + id + "')";
        } 
    }
}

dw_Rotator.prototype.showCaption = function() {
    if ( this.captions && this.captionId ) {
        var el = document.getElementById( this.captionId );
        if ( el && this.captions[this.ctr] ) {
            el.innerHTML = this.captions[this.ctr];
        }
    }
}

// Start rotation for all instances 
dw_Rotator.start = function() {
    var len = dw_Rotator.col.length, obj;
    for (var i=0; i<len; i++) {
        obj = dw_Rotator.col[i];
        if (obj && obj.id ) 
            obj.timer = setTimeout( obj.animString + ".rotate()", obj.speed);
    }
}

// Stop rotation for all instances 
dw_Rotator.stop = function() {
    var len = dw_Rotator.col.length, obj;
    for (var i=0; i<len; i++) {
        obj = dw_Rotator.col[i];
        if (obj ) { clearTimeout(obj.timer); obj.timer = null; }
    }
}

// for stopping/starting (onmouseover/out)
dw_Rotator.pause = function(e) {	
    e = dw_Event.DOMit(e);
    var id = e.target.id;
    var obj = dw_Rotator.getInstanceById(id);
    if ( obj ) { clearTimeout( obj.timer ); obj.timer = null; }
}

dw_Rotator.resume = function(e) {
    e = dw_Event.DOMit(e);
    var id = e.target.id;
    var obj = dw_Rotator.getInstanceById(id);
    if ( obj && obj.id ) {
        obj.timer = setTimeout( obj.animString + ".rotate()", dw_Rotator.resumeDelay );
    }
}

// calls constructor, addImages, adds actions, etc.
dw_Rotator.setup = function () {
    if (!document.getElementById) return;
    var i, j, rObj, r, imgAr, len;
    for (i=0; arguments[i]; i++) {
        rObj = arguments[i];
        r = new dw_Rotator(rObj.id, rObj.speed, rObj.path, rObj.bTrans, rObj.bMouse, rObj.bRand);
        try {
            imgAr = rObj.images; len = imgAr.length;
            for (j=0; j<len; j++) { r.addImages( imgAr[j] ); }
            if( rObj.num ) r.ctr = rObj.num; // for seq after random selection
            if ( rObj.actions && rObj.actions.length == len ) {
                r.addProp('actions', rObj.actions);
            }
            if ( rObj.alt && rObj.alt.length == len ) {
                r.addProp('alt', rObj.alt);
            }
            if ( rObj.title && rObj.title.length == len ) {
                r.addProp('title', rObj.title);
            }
            if ( rObj.captions ) {
                r.addProp('captions', rObj.captions);
                r.captionId = rObj.captionId;
                dw_Rotator.addRotateEvent(r, function (id) { 
                    return function() { dw_Rotator.getInstanceById(id).showCaption(); }
                }(rObj.id) ); // see Crockford js good parts pg 39
            }
        } catch (e) { 
            //alert(e.message); 
        }
    }
    dw_Rotator.start();
}

// add to on_rotate for specified instance (r)
// see usage above for captions
dw_Rotator.addRotateEvent = function( r, fp ) {
    var old_on_rotate = r.on_rotate;
    r.on_rotate = function() { old_on_rotate(); fp(); }
}

// for adding actions, alt, title
dw_Rotator.prototype.addProp = function(prop, ar) {
    if ( !this[prop] ) {
        this[prop] = [];
    }
    var len = ar.length; 
    for (var i=0; i < len; i++) {
        this[prop][ this[prop].length ] = ar[i]; 
    }
}

/////////////////////////////////////////////////////////////////////
// Reminder about licensing requirements
// See Terms of Use at www.dyn-web.com/business/terms.php
// OK to remove after purchasing a license or if using on a personal site.
function dw_checkAuth() {
    var loc = window.location.hostname.toLowerCase();
    var msg = 'A license is required for commercial use of this code.\n' + 
        'Please adhere to our Terms of Use if you use dyn-web code.';
    if ( !( loc == '' || loc == '127.0.0.1' || loc.indexOf('localhost') != -1 
         || loc.indexOf('192.168.') != -1 || loc.indexOf('dyn-web.com') != -1 ) ) {
        alert(msg);
    }
}
dw_Event.add( window, 'load', dw_checkAuth);
/////////////////////////////////////////////////////////////////////