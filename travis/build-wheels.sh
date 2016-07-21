#!/bin/bash
set -e -x

REQUIREMENTS=/io/dev-requirements.txt

build_wheel() {
    env STATIC_DEPS=true \
        LDFLAGS="$LDFLAGS -fPIC" \
        CFLAGS="$CFLAGS -fPIC" \
        ${PYBIN}/pip \
            wheel \
            /io/lxml/ \
            -w wheelhouse/
}

run_tests() {
    return  # Disabled

    # Install packages and test
    for PYBIN in /opt/python/*/bin/; do
        ${PYBIN}/pip install lxml --no-index -f /io/wheelhouse
        (cd $HOME; ${PYBIN}/nosetests pymanylinuxdemo)
    done
}

# Remove Python 2.6 symlinks
rm /opt/python/cp26*

# Compile wheels for all python versions
for PYBIN in /opt/python/*/bin; do
    # Install requirements if file exists
    test ! -e $REQUIREMENTS \
        || ${PYBIN}/pip install -r $REQUIREMENTS

    build_wheel
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w /io/wheelhouse/
done

run_tests
