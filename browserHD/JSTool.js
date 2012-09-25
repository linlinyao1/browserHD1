function MyAppGetHTMLElementsAtPoint(x,y) {
    var tags = "";
    var e;
    var offset = 0;
    while ((tags.search(",(A|IMG),") < 0) && (offset < 20)) {
        tags = ",";
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.tagName) {
                tags += e.tagName + ',';
            }
            e = e.parentNode;
        }
        if (tags.search(",(A|IMG),") < 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.tagName) {
                    tags += e.tagName + ',';
                }
                e = e.parentNode;
            }
        }
        
        offset++;
    }
    return tags;
}

function MyAppGetLinkSRCAtPoint(x,y) {
    var tags = "";
    var e = "";
    var offset = 0;
    while ((tags.length == 0) && (offset < 20)) {
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.src) {
                tags += e.src;
                break;
            }
            e = e.parentNode;
        }
        if (tags.length == 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.src) {
                    tags += e.src;
                    break;
                }
                e = e.parentNode;
            }
        }
        offset++;
    }
    return tags;
}

function MyAppGetLinkHREFAtPoint(x,y) {
    var tags = "";
    var e = "";
    var offset = 0;
    while ((tags.length == 0) && (offset < 20)) {
        e = document.elementFromPoint(x,y+offset);
        while (e) {
            if (e.href) {
                tags += e.href;
                break;
            }
            e = e.parentNode;
        }
        if (tags.length == 0) {
            e = document.elementFromPoint(x,y-offset);
            while (e) {
                if (e.href) {
                    tags += e.href;
                    break;
                }
                e = e.parentNode;
            }
        }
        offset++;
    }
    return tags;
}

function MyIPhoneApp_ModifyLinkTargets() {
    var allLinks = document.getElementsByTagName('a');
    if (allLinks) {
        var i;
        for (i=0; i<allLinks.length; i++) {
            var link = allLinks[i];
            var target = link.getAttribute('target');
            if (target && target == '_blank') {
                link.setAttribute('target','_self');
                link.href = 'newtab:'+escape(link.href);
            }
        }
    }
}

function MyIPhoneApp_isBlankInBaseElement() {
    var baseElements = document.getElementsByTagName('base');
    if(baseElements.length > 0){
        if(baseElements[0].getAttribute('target') == '_blank'){
            return 'yes';
        }
    }
    return 'no';
}

function MyIPhoneApp_CalcLoadingProgress(){
    var images = document.getElementsByTagName("img");
    var completeImages = 0;
    
    
    for(var index = 0; index < images.length; ++index){
        if(images[index].complete){
            completeImages++;
        }
        
    }
    
    if(images.length == 0){
        return 0;
    }
    else{
        return completeImages *100 / images.length;
    }
    
    
}
