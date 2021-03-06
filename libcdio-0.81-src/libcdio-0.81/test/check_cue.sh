#!/bin/sh
#$Id: check_cue.sh.in,v 1.31 2007/12/28 02:11:01 rocky Exp $
# Tests to see that BIN/CUE and cdrdao TOC file iamge reading is correct
# (via cd-info).

if test "X" != "X" ; then
  vcd_opt='--no-vcd'
fi

if test "X$srcdir" = "X" ; then
  srcdir=`pwd`
fi

if test "X$top_srcdir" = "X" ; then
  top_srcdir=`pwd`/..
fi

if test "X$top_builddir" = "X" ; then
  top_builddir=`pwd`/..
fi

. ${top_builddir}/test/check_common_fn

if test ! -x $top_srcdir/src/cd-info ; then
  exit 77
fi

BASE=`basename $0 .sh`

fname=cdda
testnum=CD-DA
opts="--quiet --no-device-info --cue-file ${srcdir}/${fname}.cue --no-cddb"
test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
RC=$?
check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"
  

opts="--quiet --no-device-info --bin-file ${srcdir}/${fname}.bin --no-cddb"
test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
RC=$?
check_result $RC "cd-info BIN test $testnum" "${CD_INFO} $opts"

opts="--quiet --no-device-info --toc-file ${srcdir}/${fname}.toc --no-cddb"
test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
RC=$?
check_result $RC "cd-info TOC test $testnum" "${CD_INFO} $opts"

fname=isofs-m1
testnum='ISO 9660 mode1 CUE'
if test -f  ${srcdir}/${fname}.bin ; then
  if test -n "1"; then 
    opts="-q --no-device-info --no-disc-mode --cue-file ${srcdir}/${fname}.cue --iso9660"
    test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
    RC=$?
    check_result $RC "cd-info Rock-Ridge CUE test $testnum" "${CD_INFO} $opts"

    opts="-q --no-device-info --no-disc-mode --no-rock-ridge --cue-file ${srcdir}/${fname}.cue --iso9660"
    test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}-no-rr.right
    RC=$?
    check_result $RC "cd-info no Rock-Ridge CUE test $testnum" "${CD_INFO} $opts"
  fi

else 
  echo "Don't see CUE file ${srcdir}/${fname}.bin. Test $testnum skipped."
fi

if test -n "1"; then 
  testnum='ISO 9660 mode1 TOC'
  if test -f  ${srcdir}/${fname}.bin ; then
    opts="-q --no-device-info --no-disc-mode --toc-file ${srcdir}/${fname}.toc --iso9660"
    test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
    RC=$?
    check_result $RC "cd-info TOC test $testnum" "${CD_INFO} $opts"
  else 
    echo "Don't see TOC file ${srcdir}/${fname}.bin. Test $testnum skipped."
  fi
fi

fname=vcd_demo
if test -z "" ; then
  right=${srcdir}/${fname}.right
else
  right=${srcdir}/${fname}_vcdinfo.right
fi
testnum='Video CD'
if test -f ${srcdir}/${fname}.bin ; then
  opts="-q --no-device-info --no-disc-mode -c ${srcdir}/${fname}.cue --iso9660"
  test_cdinfo "$opts" ${fname}.dump $right
  RC=$?
  check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"

  if test -z "" ; then
    right=${srcdir}/${fname}.right
  else
    right=${srcdir}/${fname}_vcdinfo.right
  fi
  opts="-q --no-device-info --no-disc-mode -t ${srcdir}/${fname}.toc --iso9660"
  if test -f ${srcdir}/${fname}.toc ; then
    test_cdinfo "$opts" ${fname}.dump $right
    RC=$?
    check_result $RC "cd-info TOC test $testnum" "${CD_INFO} $opts"
  else 
    echo "Don't see TOC file ${srcdir}/${fname}.toc. Test $testnum skipped."
  fi
else 
  echo "Don't see CUE file ${srcdir}/${fname}.cue. Test $testnum skipped."
fi

fname=svcd_ogt_test_ntsc
testnum='Super Video CD'
if test -f ${srcdir}/${fname}.bin ; then
  opts="-q --no-device-info --no-disc-mode --cue-file ${srcdir}/${fname}.cue $vcd_opt --iso9660"
  test_cdinfo "$opts" ${fname}.dump ${srcdir}/${fname}.right
  RC=$?
  check_result $RC "cd-info CUE test $testnum" "${CD_INFO} $opts"
else 
  echo "Don't see CUE file ${srcdir}/${fname}.bin. Test $testnum skipped."
fi

exit $RC

#;;; Local Variables: ***
#;;; mode:shell-script ***
#;;; eval: (sh-set-shell "bash") ***
#;;; End: ***
