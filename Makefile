PACKAGE := $(shell basename *.spec .spec)
ARCH = noarch
RPMBUILD = rpmbuild --define "_topdir %(pwd)/build" \
	--define "_sourcedir  %(pwd)/sdist" \
	--define "_builddir %{_topdir}/rpm-build" \
	--define "_srcrpmdir %{_rpmdir}" \
	--define "_rpmdir %{_topdir}/rpms"

all: rpms

clean:
	rm -rf ${PACKAGE}
	rm -rf build/ sdist/ *~

install: 
	python setup.py --root=${prefix} -f

install_rpms: rpms 
	rpm -Uvh build/rpms/noarch/${PACKAGE}*.noarch.rpm

reinstall: uninstall install

uninstall: clean
	rm -rf ${prefix}/etc/${PACKAGE}
	rm -f ${prefix}/usr/bin/${PACKAGE}

uninstall_rpms: clean
	rpm -e ${PACKAGE}

sdist: clean
	mkdir -p sdist/i
	ln -s . ${PACKAGE}
	tar -czPhf sdist/${PACKAGE}.tgz \
	  --exclude ".git" --exclude ".gitignore" \
	  --exclude "sdist" --exclude "build" \
	  --exclude ${PACKAGE}/${PACKAGE} \
	  ${PACKAGE}

prep_rpmbuild: sdist
	mkdir -p build/rpm-build
	mkdir -p build/rpms
	cp sdist/${PACKAGE}.tgz build/rpm-build/

rpms: prep_rpmbuild
	${RPMBUILD} -ba ${PACKAGE}.spec

srpm: prep_rpmbuild
	${RPMBUILD} -bs ${PACKAGE}.spec
