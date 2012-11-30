PACKAGE := $(shell basename *.spec .spec)
ARCH = noarch
RPMBUILD = rpmbuild --define "_topdir %(pwd)/build" \
  --define "_sourcedir  %{_topdir}/sdist" \
  --define "_builddir %{_topdir}/rpm-build" \
  --define "_srcrpmdir %{_rpmdir}" \
  --define "_rpmdir %{_topdir}/rpms"

all: rpms

clean:
  rm -rf build/ *~

install: 
  mkdir -p ${prefix}/etc/${PACKAGE}/{available,enabled}.d
  install -m 750 scripts/${PACKAGE} ${prefix}/usr/local/bin/
  install -m 644 config/${PACKAGE}.conf ${prefix}/etc/

install_rpms: rpms 
  rpm -Uvh build/rpms/noarch/${PACKAGE}*.noarch.rpm

reinstall: uninstall install

uninstall: clean
  rm -rf ${prefix}/etc/${PACKAGE}*
  rm -f ${prefix}/usr/local/bin/${PACKAGE}

uninstall_rpms: clean
  rpm -e ${PACKAGE}

sdist:
  mkdir -p build/sdist/
  tar -czf sdist/${PACKAGE}.tgz \
    --exclude ".git" --exclude "*.log" \
    --exclude "Makefile" --exclude "README*" \
    --exclude "*.spec" --exclude "build" \
    ./

prep_rpmbuild: build sdist
  mkdir -p build/rpm-build
  mkdir -p build/rpms
  cp ${PACKAGE}.tgz build/rpm-build/

rpms: prep_rpmbuild
  ${RPMBUILD} -ba ${PACKAGE}.spec

srpm: prep_rpmbuild
  ${RPMBUILD} -bs ${PACKAGE}.spec
