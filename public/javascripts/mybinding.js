reviews_binding = function(root, data){
	
	root.find("div.entry-secondary").each( function(index){
	  var entryDOM = data[index];
	
	  this.onclick = function() {
		var entry = $(this).parent()[0]; //here need a $, ugly! confused!
		var c = $(entry).children(".content");
		if(c[0].style.display === "none"){
			$(c[0]).html(dc.template.content({'trans' : trans} ));
			content_binding($(c[0]));// $(c[0]).bind(); is better.
        } else{
			$(c[0]).html(""); //need unbind?
		};

        $(c[0]).toggle();
        
        if(entry.id != "current-entry"){
          if($('#current-entry') != null){
            //can't use toogle here...  ugly than control by css...
            $('#current-entry').children('.content').html("");
            $('#current-entry').attr("id", "");
          }
          entry.id="current-entry";
        };
				//this.scrollTo(); !!! FIXME
		
	   /*check if we have cached the detailed content*/
	   if( !$(c[0]).hasClass("stollen")){
		  var pars = 'id=' + entryDOM.id + "&type=" + current_menu_id; /*ugly! innerHTML!*/
		  if (current_menu_id=="search") {
			var id = $$('div#current-entry .content .summary .detail-content')[0]
		   	var myAjax = new Ajax.Updater(id,
						'/t/expand',{ evalScripts:true, parameters: pars, onComplete: showResponse}
				);
		  } else{
				$.ajax({ type: 'get',url: '/t/expand',data: pars,success: function(data) { showResponse222(data)}  });
		  };
		};
		
    };//end of onclick

	function showResponse222(originalRequest){
			$('div#current-entry .content .summary .detail-content')[0].innerHTML = originalRequest.html;
			$('div#current-entry .content').addClass("stollen");
			var link = $('div#current-entry .link')[0].innerHTML;
			$('div#current-entry .content .summary .cover-image')[0].src = link;
			//FIXME can get from familymber?
			//$('.div#current-entry')[0].scrollTo();//there are 2 scrollTo, oh, no other way.FIXME
			//It looks that after ajax response came back, the position changed, so only one scrollTo didn't work
			//and BUG: the last entry didn't scroll to top. FIXME
	};
	
	function showResponse(originalRequest){
		  //$$('div#current-entry .content .summary .detail-content')[0].innerHTML = originalRequest.responseText;
		  $('div#current-entry .content')[0].addClassName("stollen");
		  var link = $('div#current-entry .link')[0].innerHTML;
		  $('div#current-entry .content .summary .cover-image')[0].src = link;
		  //FIXME can get from familymber?
		  $('div#current-entry')[0].scrollTo();//there are 2 scrollTo, oh, no other way.
	  }

    });



};

content_binding = function(root){
    //bind the "click entry add comment button" event
	root.find('span.entry-comment').each( function(){
    this.onclick = function() {
			  console.log("click entry comment");
			  $(this).parent().parent().children(".action-area").toggle();
				/*change color to be a active tab*/
				if ($(this).hasClass("entry-comment-active")){
		  		$(this).removeClass("entry-comment-active");/*is there like 'remove it'*/
				}else{
		  		$(this).addClass("entry-comment-active");
				}
      };
    });

    //bind the "I want it" event
    root.find('span.entry-star').each( function(familyMember){
		familyMember.onclick = function(){
			var ance = Element.ancestors(familyMember)[0];
			var subject_id = ance.getElementsByClassName('subject_id')[0].innerHTML;
			familyMember.addClassName('star-marked');
			familyMember.removeClassName('star-unmarked');//FIXME, only succeed then change icon
		//	<%= remote_function(:update => "ssss",
		//						:with=>"'subject_id=' + subject_id",
		//	                    :url => { :action => :bookmark_subject},
		//	                    :complete => "" )
		//	%>;
		};
		function mark_subject(originalRequest){
			//fuck. now I can't know the collection id, it is not returned from douban
			alert("marked");
			familyMemer.hasClassName('star-marked')
		}
	});
}