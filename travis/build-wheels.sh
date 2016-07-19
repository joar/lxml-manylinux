#!/bin/bash
set -e -x

# Remove Python 2.6 symlinks
rm /opt/python/cp26*

# Compile wheels
for PYBIN in $(echo /opt/python/*/bin | grep -v cp26); do
    ${PYBIN}/pip install -r /io/dev-requirements.txt

    env STATIC_DEPS=true \
        LDFLAGS="$LDFLAGS -fPIC" \
        CFLAGS="$CFLAGS -fPIC" \
        ${PYBIN}/pip \
            wheel \
            /io/lxml/ \
            -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/*/bin/; do
    ${PYBIN}/pip install python-manylinux-demo --no-index -f /io/wheelhouse
    (cd $HOME; ${PYBIN}/nosetests pymanylinuxdemo)
done
