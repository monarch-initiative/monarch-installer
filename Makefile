all: prepare-owlsim

# Run this AFTER you have placed any necessary data files into
#   phenotype-ontologies/server/additional-associations.txt
prepare-owlsim:
	cd phenotype-ontologies/server/ && make all

# To rebuild the installer:

OWLTOOLS_JAR = owltools/OWLTools-Runner/bin/owltools-runner-all.jar

V=1.0.0-rc1
TGZ=monarch-installer-$(V).tgz

tgz: $(TGZ)
$(TGZ): downloads builds
	cd .. && tar --exclude .svn --exclude .git -zcvf  $@ monarch-installer && mv $@ monarch-installer

deploy:
	scp $(TGZ) cmg@downloads.monarchinitiative.org:/var/www/html/monarch/pub/monarch-installer/

builds: monarch-app/ringojs $(OWLTOOLS_JAR) 
downloads: monarch-app phenotype-ontologies owltools

monarch-app:
	git clone -b production https://github.com/monarch-initiative/monarch-app.git

phenotype-ontologies:
	svn checkout http://phenotype-ontologies.googlecode.com/svn/trunk/ phenotype-ontologies

owltools:
	svn checkout http://owltools.googlecode.com/svn/trunk/ owltools

$(OWLTOOLS_JAR): owltools
	cd owltools/OWLTools-Parent && mvn clean compile package

monarch-app/ringojs: monarch-app
	cd monarch-app && ./install.sh
