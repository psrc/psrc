begin;
  delete from pages;
  delete from page_parts;
  delete from snippets;
  delete from layouts;
--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: layouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jordanisip
--

SELECT pg_catalog.setval('layouts_id_seq', 14, true);


--
-- Name: page_parts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jordanisip
--

SELECT pg_catalog.setval('page_parts_id_seq', 31, true);


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jordanisip
--

SELECT pg_catalog.setval('pages_id_seq', 12, true);


--
-- Name: snippets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jordanisip
--

SELECT pg_catalog.setval('snippets_id_seq', 11, true);


--
-- Data for Name: layouts; Type: TABLE DATA; Schema: public; Owner: jordanisip
--

COPY layouts (id, name, content, created_at, updated_at, created_by_id, updated_by_id, content_type, lock_version) FROM stdin;
3	XML Feed	<r:content />\n	2008-08-21 19:32:28.661535	2008-08-21 19:32:28.661535	1	\N	text/xml	0
13	Three Columns (1/3, 1/3, 1/3)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='page-content'>\r\n              <div class='yui-gb'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n                <div class="yui-u"><r:content part="col3" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n\r\n	2008-10-02 00:22:13.943201	2008-10-02 02:35:12.639902	1	1		2
14	Three-Columns w/ Nav (180px Navigation, 1/3, 1/3, 1/3)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div class="yui-t2" id='custom-doc'>\r\n      <div id='bd'>\r\n        <r:snippet name="page_navigation" />\r\n        <div id='yui-main'>\r\n          <div class='yui-b' id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='page-content'>\r\n              <div class='yui-gb'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n                <div class="yui-u"><r:content part="col3" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-02 00:22:23.428745	2008-10-02 02:41:15.992274	1	1		1
7	Front	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='page-content'>\r\n          <div class='yui-gc '>\r\n            <div class='yui-u first'>\r\n              <r:content/>\r\n            </div>\r\n            <div class='yui-u'>\r\n              <r:content part="col2" />\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-01 23:13:06.8126	2008-10-02 01:24:29.76726	1	1		7
9	Two Columns (1/2, 1/2)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='page-content'>\r\n              <div class='yui-g'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-02 00:21:30.760874	2008-10-02 02:43:10.873107	1	1		1
8	One Column w/ Nav (180px Navigation)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div class=' yui-t2' id='custom-doc'>\r\n      <div id='bd'>\r\n        <r:snippet name="page_navigation" />\r\n        <div id='yui-main'>\r\n          <div class='yui-b' id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='main-content'>\r\n              <r:content />\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>	2008-10-02 00:19:55.36803	2008-10-02 02:38:13.918702	1	1		2
10	Two Columns (2/3, 1/3)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='page-content'>\r\n              <div class='yui-gc'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-02 00:21:41.682472	2008-10-02 02:44:04.365214	1	1		1
11	Two Columns (3/4, 1/4)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='page-content'>\r\n              <div class='yui-ge'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-02 00:21:52.811945	2008-10-02 02:44:28.630207	1	1		1
12	Two-Columns w/ Nav (180px Navigation, 1/2, 1/2)	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc' class='yui-t2'>\r\n      <div id='bd'>\r\n        <r:snippet name="page_navigation" />\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper' class='yui-b'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='main-content'>\r\n              <div class='yui-gc'>\r\n                <div class="yui-u first"><r:content /></div>\r\n                <div class="yui-u"><r:content part="col2" /></div>\r\n              </div>\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-10-02 00:22:04.734484	2008-10-02 02:46:55.564995	1	1		1
5	One Column	<?xml version='1.0' encoding='utf-8' ?>\r\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html lang='en' xmlns='http://www.w3.org/1999/xhtml'>\r\n  <head>\r\n    <r:snippet name="head" />\r\n  </head>\r\n\r\n  <body>\r\n    <r:snippet name="header" />\r\n\r\n    <div id='custom-doc'>\r\n      <div id='bd'>\r\n        <div id='yui-main'>\r\n          <div id='main-content-wrapper'>\r\n            <h2 id='page-header'>\r\n              <r:title />\r\n            </h2>\r\n            <div id='main-content'>\r\n              <r:content />\r\n            </div>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n    <r:snippet name="footer" />\r\n    <r:snippet name="analytics" />\r\n  </body>\r\n</html>\r\n	2008-08-24 23:18:54.517224	2008-10-02 02:57:57.647055	1	1		6
\.


--
-- Data for Name: page_parts; Type: TABLE DATA; Schema: public; Owner: jordanisip
--

COPY page_parts (id, name, filter_id, content, page_id) FROM stdin;
2	body	Textile	The file you were looking for could not be found.\n\nAttempted URL: @<r:attempted_url />@\n\nIt is possible that you typed the URL incorrectly or that you clicked on a bad link.\n\n"<< Back to Home Page":/\n	2
3	body	\N	<?xml version="1.0" encoding="UTF-8"?>\n<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">\n  <channel>\n    <title>Article RSS Feed</title>\n    <link>http://your-web-site.com<r:url /></link>\n    <language>en-us</language>\n    <ttl>40</ttl>\n    <description>The main blog feed for my Web site.</description>\n    <r:find url="/articles/">\n    <r:children:each limit="10">\n        <item>\n          <title><r:title /></title>\n          <description><r:escape_html><r:content /></r:escape_html></description>\n          <pubDate><r:rfc1123_date /></pubDate>\n          <guid>http://your-web-site.com<r:url /></guid>\n          <link>http://your-web-site.com<r:url /></link>\n        </item>\n    </r:children:each>\n    </r:find>\n  </channel>\n</rss>\n	3
7	body	\N	body {\n  font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;\n  font-size: 80%;\n}\n	7
16	body		<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. In aliquam gravida arcu! Suspendisse sed ante. Phasellus odio pede, lacinia id; dignissim non, rutrum eu, massa. Nunc sodales, diam a tempus egestas, urna diam auctor erat, ut consectetuer eros libero sed arcu. Aliquam nullam.</p>	9
21	summary		Former head of the Environmental Protection Agency speaks to the PSRC General Assembly.\r\n<blockquote>\r\nThe future of Puget Sound will be largely a function of how wisely we can fashion land use practices that will protect the spaces from the shorelines.\r\n</blockquote>	5
14	body		This is an error page	8
15	extended			8
4	body		<r:parent><r:title /></r:parent>\r\n\r\n<ul>\r\n<r:children:each order="desc">\r\n  <li><r:link /></li>\r\n</r:children:each>\r\n</ul>\r\n	4
6	body	Markdown	<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. In aliquam gravida arcu! Suspendisse sed ante. Phasellus odio pede, lacinia id; dignissim non, rutrum eu, massa. Nunc sodales, diam a tempus egestas, urna diam auctor erat, ut consectetuer eros libero sed arcu. Aliquam nullam.</p>	6
20	summary		Congestion Management Strategies can be used to reduce congestion and/or mitigate some of its negative consequences. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros.\r\n	6
5	body	Textile	<p>Former head of the Environmental Protection Agency speaks to the PSRC General Assembly.</p>\r\n<blockquote>\r\nThe future of Puget Sound will be largely a function of how wisely we can fashion land use practices that will protect the spaces from the shorelines.\r\n</blockquote>\r\n\r\n<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. </p>	5
23	body		<p>In 2002, The Puget Sound Regional Council (PSRC) received a grant from the Federal Highway Administration to conduct a pilot project to see how travelers change their travel behavior (number, mode, route, and time of vehicle trips) in response to time-of-day variable charges for road use (variable or congestion-based tolling)</p>\r\n\r\n<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. In aliquam gravida arcu! Suspendisse sed ante. Phasellus odio pede, lacinia id; dignissim non, rutrum eu, massa. Nunc sodales, diam a tempus egestas, urna diam auctor erat, ut consectetuer eros libero sed arcu. Aliquam nullam.</p>	10
24	summary		In 2002, The Puget Sound Regional Council (PSRC) received a grant from the Federal Highway Administration to conduct a pilot project to see how travelers change their travel behavior (number, mode, route, and time of vehicle trips) in response to time-of-day variable charges for road use (variable or congestion-based tolling)	10
22	summary		New Growth Strategy for the Region, Ruckelshaus and 5 Regional Achievements Honored. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. 	9
29	col2		<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. In aliquam gravida arcu! Suspendisse sed ante. Phasellus odio pede, lacinia id; dignissim non, rutrum eu, massa. Nunc sodales, diam a tempus egestas, urna diam auctor erat, ut consectetuer eros libero sed arcu. Aliquam nullam.</p>	5
25	body			11
26	col2		This is the about page	11
30	col3		<p>Ut risus metus, viverra eu, pharetra quis, blandit non, tortor. Etiam tincidunt nunc vel libero. In venenatis tortor. Suspendisse vitae ligula eu tellus commodo ornare. Aenean rhoncus auctor purus. Nunc laoreet metus? Integer interdum. Aenean sit amet lorem pretium eros semper ultrices. Suspendisse eros justo, facilisis sodales, suscipit scelerisque, ornare in, metus. Aenean augue. Suspendisse potenti. Suspendisse quam ipsum, facilisis a, blandit non, aliquet eget, urna. Maecenas mi. Cras feugiat posuere nulla. Aenean arcu mi, pretium ut, luctus a, lobortis vel, eros. In aliquam gravida arcu! Suspendisse sed ante. Phasellus odio pede, lacinia id; dignissim non, rutrum eu, massa. Nunc sodales, diam a tempus egestas, urna diam auctor erat, ut consectetuer eros libero sed arcu. Aliquam nullam.</p>	5
27	body		<dl>\r\n  <dt>General Assembly</dt>\r\n  <dd>Votes on major regional decisions, improves the budget, and elects new officers</dd>\r\n</dl>	12
28	extended			12
13	col2		<r:snippet name="subsection" title="What is PSRC?">\r\n  <p>The Puget Sound Regional Council (PSRC) is where elected leaders come together to get the region ready for the future.</p>\r\n  <r:snippet name="video" />\r\n  <div class="view-all"><a href="#">Learn More</a></div>\r\n</r:snippet>\r\n\r\n<r:snippet name="subsection" title="Upcoming Events">\r\n  <dl class="meetups">\r\n    <dt><a href="#">2008 Prosperity Partnership Fall Luncheon</a></dt>\r\n    <dd class="info">November 6 - The Westin Seattle</dd>\r\n  </dl>\r\n</r:snippet>\r\n\r\n<r:snippet name="subsection" title="Meeting Schedule">\r\n  <strong>November 2008 Meetings</strong>\r\n  <dl class="meetups">\r\n    <dt><a href="#">Economic Development District Board of Directors</a></dt>\r\n    <dd>Nov 12, 12:00pm - 1:30pm</dd>\r\n\r\n    <dt><a href="#">Transportation Policy Board</a></dt>\r\n    <dd>Nov 13, 9:30am - 11:30am</dd>\r\n\r\n    <dt><a href="#">Growth Management Policy Board</a></dt>\r\n    <dd>Nov 13, 10:00am - 12:00pm</dd>\r\n\r\n    <dt><a href="#">Regional Technical Forum</a></dt>\r\n    <dd>Nov 19, 1:30pm - 3:30pm</dd>\r\n\r\n    <dt><a href="#">Regional Staff Committee</a></dt>\r\n    <dd>Nov 19, 11:30am - 12:00pm</dd>\r\n  </dl>\r\n  <div class="view-all"><a href="#">View All Scheduled Meetings</a></div>\r\n</r:snippet>	1
31	banner		<img src="/images/banner2.jpg" alt="banner" />\r\n<div id="caption-container">\r\n  <div id="caption">\r\n    <h4>Ferries in Motion</h4>\r\n    <p>A ferry leaving from Seattle, WA to Kitsap, WA.</p>\r\n  </div>\r\n</div>	1
1	body		<r:snippet name="section" title="Featured News">\r\n  <r:find url="/news/">\r\n    <r:children:each limit="3" order="asc">\r\n      <p class="date"><r:date format="%b %d, %Y" /></p>\r\n      <h5><r:link /></h5>\r\n      <div class="info"><r:content part="summary"/> <r:link>Continue Reading&#8230;</r:link></div>\r\n    </r:children:each>\r\n  </r:find>\r\n</r:snippet>\r\n\r\n<div class="yui-g reset-grid clear">\r\n  <div class="yui-u first">\r\n    <r:snippet name="subsection" title="Quick Facts">\r\n      <ul class="links">\r\n        <li><a href="#">Population by Region</a></li>\r\n        <li><a href="#">Demographic Facts</a></li>\r\n        <li><a href="#">Traffic Facts</a></li>\r\n        <li><a href="#">PSRC Facts</a></li>\r\n      </ul>\r\n    </r:snippet>\r\n  </div>\r\n  <div class="yui-u">\r\n    <r:snippet name="subsection" title="Recent Publications">\r\n      <ul class="links">\r\n        <li><a href="#">Traffic Choices Study has been Released</a></li>\r\n        <li><a href="#">Final Scoping Report on Destination 2030</a></li>\r\n        <li><a href="#">Transportation Plan Update Approved</a></li>\r\n      </ul>\r\n      <div class="view-all"><a href="#">View All Publications</a></div>\r\n    </r:snippet>\r\n  </div>\r\n</div>\r\n\r\n<r:snippet name="subsection" title="Get Involved">\r\n  <div class="rickmap">\r\n    <a href="/images/jurisdiction.jpg" rel="facebox"><img src="/images/rickmap.png" alt="Jurisdiction Map" /></a>\r\n    <a href="/images/jurisdiction.jpg" rel="facebox">View Jurisdiction Map</a>\r\n  </div>\r\n  <ul class="links">\r\n    <li><a href="#">Online Registrations</a></li>\r\n    <li><a href="#">Request to Schedule a PSRC Speaker</a></li>\r\n    <li><a href="#">Public Participation Plan</a></li>\r\n    <li><a href="#">Title VI</a></li>\r\n  </ul>\r\n  <div class="view-all"><a href="#">Find out more ways to get involved</a></div>\r\n</r:snippet>\r\n	1
\.


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: jordanisip
--

COPY pages (id, title, slug, breadcrumb, class_name, status_id, parent_id, layout_id, created_at, updated_at, published_at, created_by_id, updated_by_id, virtual, lock_version, description, keywords) FROM stdin;
2	File Not Found	file-not-found	File Not Found	FileNotFoundPage	100	1	\N	2008-08-21 19:32:28.468039	2008-08-21 19:32:28.468039	2008-08-21 12:32:28.438851	1	\N	t	0	\N	\N
3	RSS Feed	rss	RSS Feed	\N	100	1	3	2008-08-21 19:32:28.501095	2008-08-21 19:32:28.501095	2008-08-21 12:32:28.48614	1	\N	f	0	\N	\N
7	Styles	styles.css	Styles	\N	100	1	2	2008-08-21 19:32:28.644286	2008-08-21 19:32:28.644286	2008-08-21 12:32:28.629009	1	\N	f	0	\N	\N
10	Traffic Choices Study	traffic-choices-study	Traffic Choices Study	Page	100	4	\N	2008-10-02 04:14:53.329866	2008-10-02 04:23:31.824121	2008-10-01 21:15:08.660254	1	1	f	3		
9	VISION 2040 Adopted	vision-2040-adopted	VISION 2040 Adopted	Page	100	4	\N	2008-10-02 02:32:52.420297	2008-10-02 04:24:01.759118	2008-10-01 19:33:24.556935	1	1	f	10		
8	500	500	500	InternalServerErrorPage	1	1	\N	2008-09-18 22:45:14.560491	2008-09-18 22:45:14.560491	\N	1	\N	t	0		
1	Puget Sound Regional Council	/	Puget Sound Regional Council	Page	100	\N	7	2008-08-21 19:32:28.417546	2008-10-08 04:31:03.601846	2008-08-21 12:32:28.402747	1	1	f	115		
6	Congestion Management Strategies	congestion-management-strategies	Congestion Management Strategies	Page	100	4	\N	2008-08-21 19:32:28.610657	2008-10-02 04:43:06.217774	2008-08-21 12:32:28.597008	1	1	f	8		
11	About	about	About	Page	100	1	12	2008-10-02 18:21:55.964784	2008-10-02 18:22:10.585535	2008-10-02 11:22:10.571756	1	1	f	1		
12	Boards and Committees	boards-and-committees	Boards and Committees	Page	1	11	\N	2008-10-02 18:24:50.334502	2008-10-02 18:38:34.283905	\N	1	1	f	1		
5	Bill Rukelshaus at General Assembly	bill-rukelshaus-at-general-assembly	Bill Rukelshaus at General Assembly	Page	100	4	12	2008-08-21 19:32:28.579473	2008-10-02 21:40:39.56684	2008-08-21 12:32:28.565324	1	1	f	17		
4	News	news	News	ArchivePage	100	1	5	2008-08-21 19:32:28.54744	2008-10-02 04:11:33.46063	2008-08-21 12:32:28.518382	1	1	f	3		
\.


--
-- Data for Name: snippets; Type: TABLE DATA; Schema: public; Owner: jordanisip
--

COPY snippets (id, name, filter_id, content, created_at, updated_at, created_by_id, updated_by_id, lock_version) FROM stdin;
3	analytics		<script type="text/javascript">\r\n    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");\r\n    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));\r\n</script>\r\n<script type="text/javascript">\r\n    var pageTracker = _gat._getTracker("UA-887439-12");\r\n    pageTracker._trackPageview();\r\n</script>	2008-10-01 22:58:00.247644	2008-10-01 22:58:09.893991	1	1	1
7	page_navigation		<div class='yui-b' id='sidebar'>\r\n  <ul id='page-navigation'>\r\n    <li class='first'><a href="#">Ut risus</a></li>\r\n    <li class='active'><a href="#">pharetra quis</a></li>\r\n    <li><a href="#">viverra eu</a></li>\r\n    <li><a href="#">blandit non</a></li>\r\n    <li><a href="#">viverra eu</a></li>\r\n    <li><a href="#">blandit non</a></li>\r\n    <li><a href="#">viverra eu</a></li>\r\n    <li><a href="#">blandit non</a></li>\r\n  </ul>\r\n</div>	2008-10-02 00:19:08.98422	2008-10-02 00:19:08.98422	1	\N	0
9	subsection		<div class='section'>\r\n  <div class='section-header'>\r\n    <h4><r:var name='title' /></h4>\r\n  </div>\r\n  <div class='section-content'>\r\n    <r:yield />\r\n  </div>\r\n</div>	2008-10-02 17:27:31.024078	2008-10-02 17:41:22.669276	1	1	1
2	footer		<div id='ft'>\r\n  <ul class='clear'>\r\n    <li><a href="/admin/templates">About PSRC</a></li>\r\n    <li><a href="/admin/templates">Contact Us</a></li>\r\n    <li><a href="/admin/templates">Careers</a></li>\r\n    <li><a href="/admin/templates">Request for Proposals</a></li>\r\n\r\n    <li><a href="/admin/templates">Publications</a></li>\r\n    <li><a href="/admin/templates">Privacy Policy</a></li>\r\n    <li><a href="/admin/templates">Feedback</a></li>\r\n    <li><a href="/admin/templates">Sitemap</a></li>\r\n  </ul>\r\n  <p>1011 Western Ave, Suite 500 Seattle, WA 98104<p>\r\n</div>	2008-08-21 19:32:28.364376	2008-10-02 21:25:50.724339	1	1	2
8	section		<div class='section'>\r\n  <div class='section-header'>\r\n    <h3><r:var name='title' /></h3>\r\n  </div>\r\n  <div class='section-content'>\r\n    <r:yield />\r\n  </div>\r\n</div>	2008-10-02 17:27:11.405043	2008-10-02 17:27:11.405043	1	\N	0
1	header		<div id='branding'>\r\n  <div id='search-container'>\r\n    <div id='search-form'>\r\n      <form action="http://www.google.com/cse" id="cse-search-box">\r\n        <div>\r\n          <input type="hidden" name="cx" value="003577279968907746985:xzojjvfcero" />\r\n          <input type="hidden" name="ie" value="UTF-8" />\r\n          <input type="text" name="q" size="31" />\r\n          <input type="submit" name="sa" id="search-button" value="Search" />\r\n        </div>\r\n      </form>\r\n      <script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=cse-search-box&lang=en"></script>\r\n    </div>\r\n  </div>\r\n  <a href="/"><img alt="Puget Sound Regional Council" src="/images/psrc-logo.gif?1219622309" /></a>\r\n</div>\r\n\r\n<div id='header'>\r\n  <ul class='clear' id='nav'>\r\n    <li class="first">\r\n      <a href="/about/" class="sub-nav">About</a>\r\n      <ul>\r\n        <li><a href="#">Purpose</a></li>\r\n        <li><a href="/news/">News<a></li>\r\n        <li><a href="#">Boards and Committees</a></li>\r\n        <li><a href="#">Member Directory</a></li>\r\n        <li><a href="#">Request for Proposals</a></li>\r\n        <li><a href="#">Careers</a></li>\r\n        <li><a href="#">Public Involvement</a></li>\r\n        <li><a href="#">Contact Us</a></li>\r\n        <li><a href="#">Title VI</a></li>\r\n        <li><a href="#">Information Center</a></li>\r\n      </ul>\r\n    </li>\r\n    <li>\r\n      <a href="#" class="sub-nav">Growth Management</a>\r\n      <ul>\r\n        <li><a href="/growth-management/vision-2020/">Vision 2020</a></li>\r\n        <li><a href="/growth-management/vision-2020/">Regional Centers</a></li>\r\n        <li><a href="/growth-management/vision-2020/">Toolkits &amp; Resources</a></li>\r\n      </ul>\r\n    </li>\r\n    <li>\r\n     <a href="#" class="sub-nav">Transportation</a>\r\n      <ul>\r\n        <li><a href="/transportation/destination-2030/">Destination 2030</a></li>\r\n        <li><a href="/transportation/air-transportation/">Air Transportation</a></li>\r\n        <li><a href="/transportation/traffic-choices/">Traffic Choices</a></li>\r\n        <li><a href="/transportation/">Congestion Management System</a></li>\r\n        <li><a href="/transportation/">Intellligent Transit System</a></li>\r\n        <li><a href="/transportation/">BNSF Corridor Study</a></li>\r\n        <li><a href="/transportation/bike-ped-program/">Bike/Pedestrian Program</a></li>\r\n        <li><a href="/transportation/freight-mobility-fast/">Freight Mobility / FAST</a></li>\r\n        <li><a href="/transportation/">Special Needs Plan</a></li>\r\n      </ul>\r\n    </li>\r\n    <li>\r\n      <a href="#" class="sub-nav">Economic Development</a>\r\n      <ul>\r\n        <li><a href="#">Prosperity Partnership</a></li>\r\n      </ul>\r\n    </li>\r\n    <li>\r\n      <a href="#" class="sub-nav">Funding</a>\r\n      <ul>\r\n        <li><a href="/psrc-funding/TIP/">TIP</a></li>\r\n        <li><a href="/psrc-funding/enhancements.php">Enhancements</a></li>\r\n        <li><a href="/psrc-funding/special-needs.php">Special Needs</a></li>\r\n        <li><a href="/psrc-funding/rural-centers-corridors.php">Rural Centers / Corridors</a></li>\r\n      </ul>\r\n    </li>\r\n    <li>\r\n      <a href="#" class="sub-nav">Data</a>\r\n      <ul>\r\n          <li><a href="#">Census</a></li>\r\n          <li><a href="#">Demographics</a></li>\r\n          <li><a href="#">Economy</a></li>\r\n          <li><a href="#">Forecasts</a></li>\r\n          <li><a href="#">Geography</a></li>\r\n          <li><a href="#">Transportation</a></li>\r\n          <li><a href="#">Travel Demand Modeling</a></li>\r\n          <li><a href="#">Surveys</a></li>\r\n          <li><a href="#">Urban Sims</a></li>\r\n          <li><a href="#">Data Directory</a></li>\r\n          <li><a href="#">Air Quality</a></li>\r\n      </ul>\r\n    </li>\r\n  </ul>\r\n</div>\r\n<r:if_parent>\r\n<div id='breadcrumbs'>\r\n  <r:breadcrumbs separator=" &raquo; " />\r\n</div>\r\n</r:if_parent>\r\n<div id='banner'>\r\n   <div id='banner-content'><r:content part="banner" inherit="true" /></div>\r\n</div>	2008-08-21 19:32:28.355064	2008-10-07 00:24:21.278662	1	1	28
10	video		<object width="248" height="166">\t<param name="allowfullscreen" value="true" />\t<param name="allowscriptaccess" value="always" />\t<param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=880621&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=1&amp;color=00ADEF&amp;fullscreen=1" />\t<embed src="http://vimeo.com/moogaloop.swf?clip_id=880621&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=1&amp;color=00ADEF&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="245" height="163"></embed></object>	2008-10-02 19:26:16.35237	2008-10-06 22:47:37.679976	1	1	5
5	head		<meta content='text/html; charset=utf-8' http-equiv='Content-Type' />\r\n<meta content='en' http-equiv='Content-Language' />\r\n<meta content='Puget Sound Regional Council, PSRC, Prosperity Partnership, Puget Sound Region, Transportation, Growth Management, Economic Development' name='keywords' />\r\n<meta content='Puget Sound Regional Council' name='description' />\r\n<meta content='FixieConsulting.com' name='author' />\r\n<meta content='all, follow' name='robots' />\r\n\r\n<meta content='index, follow, snippet, archive' name='googlebot' />\r\n<link href='/favicon.ico' rel='shortcut icon' />\r\n<link href='/favicon.ico' rel='icon' />\r\n<script src="/javascripts/jquery.js" type="text/javascript"></script>\r\n<script src="/javascripts/jquery-ui.js type="text/javascript"></script>\r\n<script src="/javascripts/hoverIntent.js" type="text/javascript"></script>\r\n<script src="/javascripts/facebox.js" type="text/javascript"></script>\r\n<script src="/javascripts/application.js" type="text/javascript"></script>\r\n<link href="/stylesheets/yui.css" media="screen" rel="stylesheet" type="text/css" />\r\n<link href="/stylesheets/base.css" media="screen" rel="stylesheet" type="text/css" />\r\n<link href="/stylesheets/templates.css" media="screen" rel="stylesheet" type="text/css" />\r\n<link href="/stylesheets/forms.css" media="screen" rel="stylesheet" type="text/css" />\r\n<link href="/stylesheets/util.css" media="screen" rel="stylesheet" type="text/css" />\r\n<link href="/stylesheets/facebox.css" media="screen" rel="stylesheet" type="text/css" />\r\n    \r\n<!--[if lte IE 7]> \r\n  <link href="/stylesheets/ie.css?1220059612" media="screen" rel="stylesheet" type="text/css" />\r\n<![endif]-->\r\n<!--[if lt IE 7]> \r\n  <script src='/admin/javascripts/pngfix.js' type='text/javascript'></script>\r\n  <link href="/stylesheets/ie6.css" media="screen" rel="stylesheet" type="text/css" />\r\n<![endif]-->\r\n<title>\r\n  <r:title />\r\n</title>	2008-10-01 23:09:44.922932	2008-10-06 17:57:14.977131	1	1	6
11	banner		<img src="/images/<r:var name='file' />" alt="banner" />\r\n<div id="caption-container">\r\n  <div id="caption">\r\n    <h4><r:var name='title' /></h4>\r\n    <p><r:yield /></p>\r\n  </div>\r\n</div>	2008-10-07 00:51:13.035671	2008-10-07 01:14:52.444153	1	1	10
\.


--
-- PostgreSQL database dump complete
--

commit;
