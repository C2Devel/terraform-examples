AC_INIT([terraform-examples], [0.1])

dependencies="
------------------------------------------------------------------------
  Please install next dependencies before using terraform-examples:

      make: ........................ > 3.x.x
      git: ......................... > 2.x.x
      sed: ......................... > 4.x.x
      terraform: ................... > 0.12.x
      findutils: ................... > 4.x.x
      coreutils: ................... > 8.x.x

------------------------------------------------------------------------
"

AC_PROG_SED
AC_PROG_AWK

AC_CHECK_PROG(GIT,git,git)
if test x$GIT = "x" ; then
  AC_MSG_ERROR("${dependencies}git is required to run examples.")
fi

AC_MSG_CHECKING([git revision])
GIT_VERSION=$(git describe --tags --match 'v*' 2>/dev/null | sed 's/^v//')
if test -z "$GIT_VERSION"; then
  AC_MSG_RESULT([no])
else
  AC_MSG_RESULT([$GIT_VERSION])
  VERSION="$GIT_VERSION"
fi

AC_CHECK_PROG(YES,yes,yes)
if test x$YES = "x" ; then
  AC_MSG_ERROR("${dependencies}yes is required to run examples.")
fi
yes_version=$(yes --version | head -n 1 | awk '{print $4}')

AC_CHECK_PROG(MAKE,make,make)
if test x$MAKE = "x" ; then
  AC_MSG_ERROR("${dependencies}Make is required to run examples.")
fi
make_version=$(make --version | head -n 1 | cut -d' ' -f 3)
make_maj_version=$(echo $make_version | awk -F. '$1 > 2 {print $1}')
if test x$make_maj_version = "x" ; then
  AC_MSG_ERROR("${dependencies}Only 3.x.x versions of make are upported.")
fi

AC_CHECK_PROG(TERRAFORM,terraform,terraform)
if test x$TERRAFORM = "x" ; then
  AC_MSG_ERROR("${dependencies}terraform is required to run examples.")
fi
terraform_version=$(terraform -version | head -n 1 | awk '{print $2}')
terraform_maj_version=$(echo $terraform_version | awk -F. '$2 > 11 {print $2}')
if test x$terraform_maj_version = "x" ; then
  AC_MSG_ERROR("${dependencies}Only 0.12.x terraform versions are supported.")
fi

AC_CHECK_PROG(FIND,find,find)
if test x$FIND = "x" ; then
  AC_MSG_ERROR("{dependencies}find is required to run examples.")
fi
find_version=$(find --version | head -n 1 | awk '{print $4}')
xargs_version=$(xargs --version | head -n 1 | awk '{print $4}')


AC_MSG_RESULT([
------------------------------------------------------------------------
  $PACKAGE_NAME $PACKAGE_VERSION:  Automatic configuration OK.

    General configuration:

      Make version: .................. ${make_version}
      Terraform version: ............. ${terraform_version}
      Find version: .................. ${find_version}
      Xargs version: ................. ${xargs_version}
      Yes version: ................... ${yes_version}

------------------------------------------------------------------------
])

AC_CONFIG_TESTDIR([tests])
AC_CONFIG_FILES([tests/Makefile tests/atlocal])

echo "Type \"make init\" to init terraform provider";
echo "Type \"make\" to run all examples";

AC_OUTPUT
