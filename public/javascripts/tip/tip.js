
// Style Sheet
document.write('' +
	'<STYLE TYPE="text/css">' +
	'<!--' +
	'body{font-family:verdana;font-size:10px;line-height:1.3}' +
	'td{font-family:verdana;font-size:10px;vertical-align:top;line-height:1.4}' + 
	'.tippagehead{font-family:verdana;font-size:16px;color:#95901f;font-weight:none;text-decoration:none}' +
	'.tipsubhead{font-family:verdana;font-size:11px;color:#333366;font-weight:bold}' +
	'.tiplist{font-family:verdana;font-size:11px;color:#000099;font-weight:none;text-decoration:none}' +
	'.tipfont8{font-family:verdana;font-size:8px}' +
	'.tipfont9{font-family:verdana;font-size:9px}' +
	'.tipfont10{font-family:verdana;font-size:10px}' +
	'.tipfont11{font-family:verdana;font-size:11px}' +
	'.tipfont12{font-family:verdana;font-size:12px}' +
	'.tipfont13{font-family:verdana;font-size:13px}' +
	
	'a.tipfont:link{font-family:verdana;font-size:9px;text-decoration:none;}' +
	'a.tipfont:visited{font-family:verdana;font-size:9px;text-decoration:none;}' +
	'a.tipfont:hover{font-family:verdana;font-size:9px;text-decoration:none;color:#60607b;}' +
	
	'a.tipnav{font-family:verdana;font-size:9px;letter-spacing:.02em;font-weight:bold;color:#95901f;text-decoration:none}' +
	'a.tipnav:visited{font-family:verdana;font-size:9px;letter-spacing:.02em;font-weight:bold;color:#95901f;text-decoration:none}' +
	'a.tipnav:hover{font-family:verdana;font-size:9px;font-weight:bold;color:#999999;text-decoration:none;background-color:#ffffff}' +
	'a.tipnav:visited:hover{font-family:verdana;font-size:9px;letter-spacing:.02em;font-weight:bold;color:#999999;text-decoration:none;background-color:#ffffff}' +

	'a.tipbot{font-family:verdana;font-size:9px;font-weight:none;color:#95901f;text-decoration:none}' +
	'a.tipbot:visited{font-family:verdana;font-size:9px;font-weight:none;color:#95901f;text-decoration:none}' +
	'a.tipbot:hover{font-family:verdana;font-size:9x;font-weight:none;color:#999999;text-decoration:none;background-color:#ffffff}' +
	'a.tipbot:visited:hover{font-family:verdana;font-size:9x;font-weight:none;color:#999999;text-decoration:none;background-color:#ffffff}' +

	'a.tippagehead:link{font-size:16px;color:#95901f;font-weight:none;text-decoration:none}' +
	'a.tippagehead:visited{font-size:16px;font-weight:none;color:#95901f;text-decoration:none}' +
	'a.tippagehead:hover{font-weight:none;color:#999999;text-decoration:none}' +
	'a.tippagehead:visited:hover{font-weight:none;color:#999999;text-decoration:none}' +

	'a.tiplist{font-family:verdana;font-size:11px;text-decoration:underline;color:#333366;}' +
	'a.tiplist:visited{font-family:verdana;font-size:11px;text-decoration:underline;color:#60607b;}' +
	'a.tiplist:hover{font-family:verdana;font-size:11px;text-decoration:underline;color:#60607b;}' +
		
    '//-->' +
	'</STYLE>')

// Navigation Function
	function tipnav(){
		if(sect == ' '){
		document.write(tipnav)
	}
	
} 

// Header Array
var tipnav = '' +
	'<table border="0" cellspacing="0" cellpadding="0">' +
	'<tr>' +
	'<td colspan="20">' +
	'<a href="'+ path + 'projects/tip/index.htm"><img src="'+ path + 'projects/tip/images/tipban.gif" alt="" width="600" height="67" border="0"></a>' +
	'</td></tr>' +
	'<tr>' +
	'<td align=RIGHT valign=top bgcolor="#ffffff">' +
	'&nbsp;&nbsp;&nbsp;&nbsp;<a href="'+ path + 'projects/tip/currenttip/index.htm" class="tipnav">CURRENT TIP</a>' +
	'<font color="#95901f"> | </font> ' +
	'<a href="'+ path + 'projects/tip/applications/index.htm" class="tipnav">APPLICATIONS</a>' +
	'<font color="#95901f"> | </font> ' +
	'<a href="'+ path + 'projects/tip/tracking/index.htm" class="tipnav">PROJECT TRACKING</a>' +
	'<font color="#95901f"> | </font>' +
	'<a href="'+ path + 'projects/tip/selection/index.htm" class="tipnav">PROJECT SELECTION FOR PSRC FUNDS</a>' +
	'</td></tr>' +
	'</table>'


// Footer Array
var tipfooter = '' +
	'<table border="0" cellspacing="0" cellpadding="0">' +
	'<tr>' +
	'<td align="center" colspan="20"><br><br>' +
	'<a href="'+ path + 'projects/tip/index.htm" class="tipbot">TIP HOME</a>' +
	'<font color="#d4d393"> | </font> ' +
	'<a href="'+ path + 'projects/tip/help/index.htm" class="tipbot">TIP SEARCH/CONTACT US</a>' +
	'<font color="#d4d393"> | </font> ' +
//	'<a href="'+ path + 'projects/tip/help/index.htm" class="tipbot">CONTACT US</a>' +
//	'<font color="#d4d393"> | </font> ' +
	'<a href="'+ path + 'projects/tip/help/sitemap.htm" class="tipbot">TIP SITE MAP</a>' +
	'</td>'
	'</tr>'
	'</table>'
			

