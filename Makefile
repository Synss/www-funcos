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
LOCAL_IMG=$(LOCAL_WWW)/img
LOCAL_DOC=$(LOCAL_WWW)/doc
SRC=src
SRC_TEMPLATE=$(SRC)/template.txt
IMG=img
DOC=documents
CGI=cgi
APACHE=apache
CONF=site-config


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

page_template: install_template
	# site template based on RRZE's index.shtml
	cp $(TEMPLATE_WWW)/index.shtml $(SRC_TEMPLATE)
	$(SED) -i \
		-e 's/lang="de"/lang="en"/g' \
	   	-e 's/<body id="start">/<body>/g' \
		-e 's,$$PLATZHALTER-NAME-WEBAUFTRITT,\n<a href="/"><img src="/img/funcos.png" alt="funCOS logo" /></a>\nFunctional Molecular Structures on Complex Oxide Surfaces (FOR 1878)\n,g' \
		-e '/TEXT AB HIER/,/AB HIER KEIN TEXT MEHR/c\<% body %>\n' \
		-e 's/Startseite/<% title %>/g' \
		-e 's/Letzte.*ung:/Last modified:/g' \
		-e 's/<!--#config timefmt.*"LAST_MODIFIED"-->/<% modtime %>/g' \
	   	$(SRC_TEMPLATE)

install_sources: page_template
	# install own files
	python r2w.py r2w.ini
	# fix declaration in root/index.shtml
	$(SED) -i 's/<body>/<body id="start">/g' $(LOCAL_WWW)/index.shtml

install_img: install_template
	cp -R $(IMG)/* $(LOCAL_IMG)

install_doc: install_template
	cp -R $(DOC)/* $(LOCAL_DOC)

install_cgi: install_template
	cp -R $(CGI)/* $(LOCAL_WWW)

install_private: install_template
	cp private/pgpasswd $(LOCAL_WWW)
	cat $(APACHE)/htaccess.txt >> $(LOCAL_WWW)/.htaccess

install_config: install_template
	$(SED) -n "/^<navigation/,/^<\/navigation/ p" $(CONF)/navigationsindex.txt > $(LOCAL_WWW)/vkdaten/navigationsindex.txt
	cp $(CONF)/kalender.conf $(LOCAL_WWW)/vkdaten

init: download_template download_rest2web

build: install_sources install_img install_private install_config install_cgi install_doc

