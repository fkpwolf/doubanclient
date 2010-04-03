/***
  *a binding function should only access elements under root.
  * use event to contact with other portlet
  */
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
			$(c[0]).html(""); //not need unbind?
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
	   if( entryDOM.detailContent === undefined){
		  var pars = 'id=' + entryDOM.id + "&type=" + current_menu_id;
		  if (current_menu_id=="search") {
			var id = $('div#current-entry .content .summary .detail-content')
			$.ajax({url: '/t/expand', data: pars,
				success: function(data){
					entryDOM.detailContent = data; //this closure modify data of outer class. cool!
					id.html(data);
					$('div#current-entry .content .summary .cover-image')[0].src = entryDOM.link.image;
				}
			});
		  } else{
				$.ajax({ type: 'get',url: '/t/expand',data: pars,
				         success: function(data) {
							entryDOM.detailContent = data.html
							$('div#current-entry .content .summary .detail-content').html(entryDOM.detailContent);	
							$('div#current-entry .content .summary .cover-image')[0].src = entryDOM.subject.link.image;	
						 }  
				});
		  };
		} else {
			$('div#current-entry .content .summary .detail-content').html(entryDOM.detailContent);
		};
		
		
    };//end of onclick


    });

};

dc.test = function(){
				console.log("look, I have namespace");
};

//did I need some namespace, like dc.test?
mysay_bind = function(page){
	page.find("#miniblog-area-submit").bind('click', function(){
		 $.ajax({
            type: 'get', url: '/t/miniblog', data: 'miniblog_content=' + $('#miniblog_content').val()
		 });
	});
};

//bind 'mine' menu
my_menu_bind = function(root) {
	root.find('#most-popular-book-review, #most-polular-movie-review').bind('click', function(){
		$.ajax({
            type: 'post', url: '/t/refresh_entries', data: 'id=' + this.id,
			success: function(data) {
				current_menu_id = 'menu44444';
				//$('#entries').html(dc.template.reviews({'list' :data, 'trans' : trans} ));
				var content = dc.template.reviews({'list' :data, 'trans' : trans});
				$(document).trigger('SHOW_LIST', [data, content]);
			}
		  });
    });
	root.find('#contact-miniblog').bind('click', function(){
	    $('entries').html('');
		$.ajax({
            type: 'post', url: '/t/refresh_entries', data: 'id=' + this.id,
			success: function(data) {
				$('#entries').html(data);
			}
		 });
    });
};

//bind the "click entry add comment button" event
content_binding = function(root){
	root.find('span.entry-comment').each( function(){
    this.onclick = function() {
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
};

search_bind = function(root){
	root.find('#search-area-submit').bind('click', function(){
		$.ajax({type: 'post', url: '/t/search', 
			data: 'search_criteria=' + root.find('#search_criteria').val() + '&subject_cat=' + root.find('#subject_cat').val(),
			success: function(data) {
				current_menu_id = 'search';  //global variable
				var content = dc.template.searchResults({'list' :data, 'trans' : trans} );
				$(document).trigger('SHOW_LIST', [data, content]);
			}
		 });
	});
}
