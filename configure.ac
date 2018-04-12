# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([wrtools-core], m4_esyscmd_s([git describe --tags --always]), [webb@webbroberts.com])
AC_COPYRIGHT

if test "x$prefix" = "xNONE"
then AC_MSG_ERROR([prefix is unset])
fi

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_MKDIR_P
AC_PROG_SED

dnl WR_check_prog( $command-name )
dnl   e.g., WR_check_prog(bash) will set @bash@
AC_DEFUN([WR_check_prog],[AC_PATH_PROG($1,$1)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

dnl WR_check_prog_options( $command-short-name, $command-name-options ... )
dnl   e.g., WR_check_prog_options(cat, gcat cat) will set @cat@
AC_DEFUN([WR_check_prog_options],[AC_PATH_PROGS($1,$2)
  test "x$[]$1" = "x" && AC_MSG_ERROR([$1 not found])])dnl

# only put critical programs required to build 'all' here.

WR_check_prog(bash)
WR_check_prog_options(find,gfind find)

AC_CONFIG_FILES([Makefile], [chmod 444 Makefile])
AC_CONFIG_FILES([stow.mk], [chmod 444 stow.mk])
AC_SUBST([config_files],$ac_config_files)
AC_OUTPUT
