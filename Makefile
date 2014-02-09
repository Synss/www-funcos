SED=gsed
UNIVIS=univis-rrze/websource
CALENDAR=calendar-rrze
TEMPLATE_ROOT=template-rrze
TEMPLATE_WWW=$(TEMPLATE_ROOT)/websource
TEMPLATE_CGI=$(TEMPLATE_ROOT)/cgi-bin
TEMPLATE_BIN=$(TEMPLATE_ROOT)/bin
LOCAL_ROOT=website
LOCAL_WWW=$(LOCAL_ROOT)/websource
LOCAL_CGI=$(LOCAL_ROOT)/cgi-bin
LOCAL_BIN=$(LOCAL_ROOT)/bin


download_template:
	-rm -r $(TEMPLATE_ROOT) 2>/dev/null; mkdir $(TEMPLATE_ROOT)
	curl http://www.vorlagen.uni-erlangen.de/downloads/webauftritt-d7.tgz \
		| tar -s/www.defaultwebauftritt.uni-erlangen.de//g \
		-zxC $(TEMPLATE_ROOT)

download_rest2web:
	-rm -r rest2web 2>/dev/null
	curl -L http://sourceforge.net/projects/rest2web/files/rest2web/0.5.1/rest2web-0.5.1.tar.gz/download \
		| tar -s/-0.5.1//g -zx
	ln -s rest2web/r2w.py .

install_template:
	-rm -r $(LOCAL_ROOT) 2>/dev/null
	cp -R $(TEMPLATE_ROOT) $(LOCAL_ROOT)
	# change layout
	$(SED) -i \
	   -e '/two_columns/ s,^/\*\(.*\)\*/,\1,g' \
	   -e '/disable_search/ s,^/\*\(.*\)\*/,\1,g' \
	   $(LOCAL_WWW)/css/d7/layout.css
	$(SED) -i \
		-e '/befinden/d ' \
		$(LOCAL_WWW)/ssi/kopf.shtml
	# fix calendar
	$(SED) -i \
		-e '/standard_ansicht/ s/woche/liste/g' \
		$(LOCAL_WWW)/vkdaten/tools/kalender/kalender.php
	$(SED) -i \
		-e '/class="inhalt"/p; /class="menue"/,/class="inhalt"/d' \
		$(LOCAL_WWW)/vkdaten/tools/kalender/templates/listenansicht.html
	# fix navigation
	$(SED) -i \
		-e '/^[[:blank:]]*'"'"'UseNavigationCache'"'"'/ s/1/0/' \
		$(LOCAL_CGI)/navigation/Navigation.pm

init: download_template download_rest2web

build: install_template

