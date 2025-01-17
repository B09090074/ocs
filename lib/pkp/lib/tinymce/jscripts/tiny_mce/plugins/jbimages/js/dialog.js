tinyMCEPopup.requireLangPack();

var jbImagesDialog = {
	
	resized : false,
	iframeOpened : false,
	timeoutStore : false,
	
	init : function() {
		document.getElementById("upload_target").src += '/' + tinyMCEPopup.getLang('jbimages_dlg.lang_id', 'english');
	},
	
	inProgress : function() {
		document.getElementById("upload_infobar").style.display = 'none';
		document.getElementById("upload_additional_info").innerHTML = '';
		document.getElementById("upload_form_container").style.display = 'none';
		document.getElementById("upload_in_progress").style.display = 'block';
		this.timeoutStore = window.setTimeout(function(){
			document.getElementById("upload_additional_info").innerHTML = tinyMCEPopup.getLang('jbimages_dlg.longer_than_usual', 0) + '<br />' + tinyMCEPopup.getLang('jbimages_dlg.maybe_an_error', 0) + '<br /><a href="#" onClick="jbImagesDialog.showIframe()">' + tinyMCEPopup.getLang('jbimages_dlg.view_output', 0) + '</a>';
		}, 20000);
	},
	
	showIframe : function() {
		if (this.iframeOpened == false)
		{
			document.getElementById("upload_target").className = 'upload_target_visible';
			tinyMCEPopup.editor.windowManager.resizeBy(0, 150, tinyMCEPopup.id);
			this.iframeOpened = true;
		}
	},
	
	uploadFinish : function(result) {
		if (result.resultCode == 'failed')
		{
			window.clearTimeout(this.timeoutStore);
			document.getElementById("upload_in_progress").style.display = 'none';
			document.getElementById("upload_infobar").style.display = 'block';
			document.getElementById("upload_infobar").innerHTML = result.result;
			document.getElementById("upload_form_container").style.display = 'block';
			
			if (this.resized == false)
			{
				tinyMCEPopup.editor.windowManager.resizeBy(0, 50, tinyMCEPopup.id);
				this.resized = true;
			}
		}
		else
		{
			document.getElementById("upload_in_progress").style.display = 'none';
			document.getElementById("upload_infobar").style.display = 'block';
			document.getElementById("upload_infobar").innerHTML = tinyMCEPopup.getLang('jbimages_dlg.upload_complete', 0);
                        
//                        tinyMCEPopup.editor.execCommand('mceInsertContent', false, '<img src="' + result.filename +'" alt="" />');
                        
                        var _filename = result.filename;
                        
                        var _needle = "/images/";
                        var _pos = _filename.indexOf(_needle) + _needle.length;
                        _filename = _filename.substr(0, _pos) + "download.php?f=" + _filename.substring(_pos, _filename.length);
                        
                        var _f_name = _filename.substring(_filename.lastIndexOf("/")+1, _filename.length);
                        var _ext = _filename.substring(_filename.lastIndexOf(".")+1, _filename.length);
                        _ext = _ext.toLowerCase();
                        var _img_ext = ["gif", "jpg", "jpeg", "png"];
                        //alert([_f_name, _ext, typeof($)]);
                        if (_img_ext.indexOf(_ext) > -1) { 
                            tinyMCEPopup.editor.execCommand('mceInsertContent', false, '<img src="' + _filename +'" alt="" />');
                        }
                        else {
                            tinyMCEPopup.editor.execCommand('mceInsertContent', false, '<a href="' + _filename +'" target="_blank">'+_f_name+'</a>');
                        }
			tinyMCEPopup.close();
			//this.showIframe(); //Disable close and enable this for DEBUG
		}
	}

};

tinyMCEPopup.onInit.add(jbImagesDialog.init, jbImagesDialog);
