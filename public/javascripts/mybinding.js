/***
  *a binding function should only access elements under root.
  * use event to contact with other portlet
  */

//this mehtod convert douban returned json to more readable json
//like remove '$t'...
convert2Review = function(json){
	var json = json || [];
	var ret = [];
	for (var i in json){
		var review = DOUBAN.parseReview(json[i]);
		ret.push(review);
	}	
	return ret;
};

reviews_binding = function(root, data){
	
	root.find("div.entry-secondary").each( function(index){
	  var entryDOM = data[index];
	  this.onclick = function() {
		window.scrollTo(0, this.offsetTop);//no need setTimeout
		
		var entry = $(this).parent()[0]; //here need a $, ugly! confused!
		var c = $(entry).children(".content");
		if(c[0].style.display === "none"){
			$(c[0]).html(dc.template.content({'trans' : trans} ));
			content_binding($(c[0]), entryDOM);// $(c[0]).bind(); is better.
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
		
		
		
	   /*check if we have cached the detailed content*/
	 if (c[0].style.display !== "none"){
	   if(entryDOM.detailContent === undefined){
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
			//eee, ugly!!!
			if (entryDOM.subject !== undefined)
				$('div#current-entry .content .summary .cover-image')[0].src = entryDOM.subject.link.image;
			else
				$('div#current-entry .content .summary .cover-image')[0].src = entryDOM.link.image;
		};
	 };
	

		
    };//end of onclick


    });

};

//did I need some namespace, like dc.test?
mysay_bind = function(page){
	page.find("#miniblog-area-submit").bind('click', function(){
		 page.find("#response_msg").html("<img src='../images/loading.gif'>");
		 $.ajax({
            type: 'get', url: '/t/miniblog', data: 'miniblog_content=' + $('#miniblog_content').val(),
			success: function(){
				page.find("#response_msg").html("successed.");
				page.find("#miniblog_content").val("");
			}, 
			error: function(){
				page.find("#response_msg").html("find error. Please try later.");
			}
		 });
	});
};

//bind 'mine' menu
my_menu_bind = function(rootNode, menuJson) {
	$(menuJson).each(function(index, item){
		var a = $("<div id='" + item.id +"' class='menu-button'><div class='sub-item'>" + item.label + "</div></div>");
		if ( item.id === "most-popular-book-review" || item.id === "most-polular-movie-review"){
			var type = "book";
			if(item.id === "most-polular-movie-review") type = "movie";
			a.bind('click', function(){
				$(document).trigger('LOAD_LIST');
				$.ajax({
		      type: 'post', url: '/t/get_popular_reviews', data: 'type=' + type,
					success: function(data) {
						current_menu_id = 'menu44444';
						var reviews = convert2Review(data.entry);
						var content = dc.template.reviews({'list' : reviews, 'trans' : trans});
						$(document).trigger('SHOW_LIST', [reviews, content]);
					},
					error: function(){
						$(document).trigger("AJAX_ERROR");
					}
				  });
		    });
		}
		if(item.id==='contact-miniblog'){
			a.bind('click', function(){
			  $(document).trigger('LOAD_LIST');
				$.ajax({
		            type: 'post', url: '/t/refresh_entries', data: 'id=' + this.id,
					success: function(data) {
						//$('#entries').html(data);
						rootNode.empty();
						miniblog_binding(rootNode, data);
					}
				 });
		    });
		}
		
		if(item.id==='my-collect'){
			a.bind('click', function(){
			  $(document).trigger('LOAD_LIST');
				$.ajax({
		            type: 'post', url: '/t/refresh_entries', data: 'id=' + this.id,
					success: function(data) {
						rootNode.empty();
						bookmark_binding(rootNode, data);
					}
				 });
		    });
		}
		rootNode.append(a);
	});
};

miniblog_binding = function(node, data){
	$(data).each(function(index, item){
		var a = $("<div class='entry'><div class='entry-secondary'><div class='entry-title'> " 
			+ item.author.name +"</div><span class='entry-secondary-snippet'>"
			+ item.title + "</span></div></div>");
		node.append(a);
	});
};

bookmark_binding = function(node, data){
	$(data).each(function(index, item){
		var a = $("<div class='entry'><div class='entry-secondary'><div class='entry-title'> " 
			+ item.subject.title +"</div><span class='entry-secondary-snippet'>ISBN: "
			+ item.subject.attribute.isbn13.match(/\d{1,4}/g).join("-") + "/" + item.subject.attribute.publisher + "</span></div></div>");
		node.append(a);
	});
};

//bind the "click entry add comment button" event
content_binding = function(root, entryDOM){
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
	
	//"goto douban" bind
	root.find('span.entry-goto-douban').each( function(){
		this.onclick = function(){
				window.open(entryDOM.link.alternate); return false;
		};
	});
};

search_bind = function(root){
	root.find('#search-area-submit').bind('click', function(){
		//$(document).trigger('LOAD_LIST');
		//$('#entries').html("<img src='../images/loading.gif'>");
		root.find("#search_resp").html("<img src='../images/loading.gif'>");
		$.ajax({type: 'post', url: '/t/search', 
			data: 'search_criteria=' + root.find('#search_criteria').val() + '&subject_cat=' + root.find('#subject_cat').val(),
			success: function(data) {
				current_menu_id = 'search';  //global variable
				var content = dc.template.searchResults({'list' :data, 'trans' : trans} );
				$(document).trigger('SHOW_LIST', [data, content]);
			}
		 });
	});
};


