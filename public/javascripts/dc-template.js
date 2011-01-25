// This file was automatically generated from _review_entries.soy.
// Please don't edit this file by hand.

if (typeof dc == 'undefined') { var dc = {}; }
if (typeof dc.template == 'undefined') { dc.template = {}; }


dc.template.head = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="nav-bar-container"><div class="nav-bar"><table class="nav-table"><tbody><tr><td class="nav-table-left"><div id="back-to-feeds" class="m-button back-to-feeds"><span class="m-button-contents">&laquo;', soy.$$escapeHtml(opt_data.trans.menu), '</span></div></td> <!--<td class="nav-table-middle"><div id="nav-title">None Title</div></td>--><td class="nav-table-right"><!--\t<div id="header-menu" class="m-button "><span class="m-button-contents"/></div>  --><div id="header-refresh" class="m-button "><span class="m-button-contents"/></div></td></tr></tbody></table><div id="nav-bar-shadow"/></div><div class="goog-menu goog-menu-vertical" style="display: none;"/></div></div>');
  if (!opt_sb) return output.toString();
};


dc.template.reviews = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  var entryList7 = opt_data.list;
  var entryListLen7 = entryList7.length;
  for (var entryIndex7 = 0; entryIndex7 < entryListLen7; entryIndex7++) {
    var entryData7 = entryList7[entryIndex7];
    dc.template.review({entry: entryData7}, output);
  }
  if (!opt_sb) return output.toString();
};


dc.template.searchResults = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  var entryList12 = opt_data.list;
  var entryListLen12 = entryList12.length;
  for (var entryIndex12 = 0; entryIndex12 < entryListLen12; entryIndex12++) {
    var entryData12 = entryList12[entryIndex12];
    dc.template.searchItem({entry: entryData12}, output);
  }
  if (!opt_sb) return output.toString();
};


dc.template.review = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="entry"><div class="entry-icons"><div class="sta"></div></div><div class="entry-secondary"><div class="entry-title">', soy.$$escapeHtml(opt_data.entry.title), '</div><span class="entry-secondary-snippet">', soy.$$escapeHtml(opt_data.entry.author.name), '|<i>', soy.$$escapeHtml(opt_data.entry.subject.title), '</i></span><div class="entry-secondary-snippet">', soy.$$escapeHtml(opt_data.entry.summary), '</div></div><div class="content" style="display: none;"></div></div>');
  if (!opt_sb) return output.toString();
};


dc.template.searchItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="entry"><div class="entry-icons"><div class="sta"></div></div><div class="entry-secondary"><div class="entry-title">', soy.$$escapeHtml(opt_data.entry.title), '</div><span class="entry-secondary-snippet"></span><div class="entry-secondary-snippet">', soy.$$escapeHtml(opt_data.entry.author.name), '|', soy.$$escapeHtml(opt_data.entry.attribute.publisher), ' | ', soy.$$escapeHtml(opt_data.entry.attribute.pubdate), '</div></div><div class="content" style="display: none;"></div></div>');
  if (!opt_sb) return output.toString();
};


dc.template.content = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="summary"><img src="../images/book-default-medium.gif" class="cover-image" style="float:left;"/><div class="detail-content">loading....</div></div><div class="entry-action"><div class="subject_id hidden"><%=h item.subject.link[\'self\']%></div><span class="entry-comment link">', soy.$$escapeHtml(opt_data.trans.add_comment), '</span><span class="entry-star link star-unmarked">', soy.$$escapeHtml(opt_data.trans.i_like_it), '</span><span class="entry-goto-douban link">', soy.$$escapeHtml(opt_data.trans.goto_douban), '</span></div><div class="action-area" style="display: none;"><div class="comments-area"><div class="idd hidden">', soy.$$escapeHtml(opt_data.trans.id), '</div><!--raw id of the review--><textarea name="comments" class="content-comment"></textarea><span class="submit-content-div link">', soy.$$escapeHtml(opt_data.trans.send), '</span></div></div>');
  if (!opt_sb) return output.toString();
};
