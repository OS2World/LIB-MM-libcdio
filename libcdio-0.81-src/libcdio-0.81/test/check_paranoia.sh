#!/bin/sh
# $Id: check_paranoia.sh.in,v 1.18 2008/10/17 01:51:47 rocky Exp $
# Compare our cd-paranoia with known good results.

if test "X$srcdir" = "X" ; then
  srcdir=`pwd`
fi

if test "X$top_builddir" = "X" ; then
  top_builddir=`pwd`/..
fi

if test "X$top_srcdir" = "X" ; then
  top_srcdir=`pwd`/..
fi

if test "f:/usr/bin/cmp.exe" != no -a ""X = X ; then
  cd_paranoia=$top_builddir/src/cd-paranoia/cd-paranoia.exe 
  $cd_paranoia -d $srcdir/cdda.cue -v -r -- "1-"
  if test $? -ne 0 ; then
    exit 6
  fi
  dd bs=16 if=cdda.raw of=cdda-1.raw
  dd bs=16 if=cdda.bin of=cdda-2.raw
  if f:/usr/bin/cmp.exe cdda-1.raw cdda-2.raw ; then
    echo "** Raw cdda.bin extraction okay"
  else
    echo "** Raw cdda.bin extraction differ"
    exit 3
  fi
  mv cdda.raw cdda-good.raw
  $cd_paranoia -d $srcdir/cdda.cue -x 64 -v -r -- "1-"
  mv cdda.raw cdda-underrun.raw
  $cd_paranoia -d $srcdir/cdda.cue -r -- "1-"
  if test $? -ne 0 ; then
    exit 6
  fi
  if f:/usr/bin/cmp.exe cdda-underrun.raw cdda-good.raw ; then
    echo "** Under-run correction okay"
  else
    echo "** Under-run correction problem"
    exit 3
  fi
  # Start out with small jitter
  $cd_paranoia -l ./cd-paranoia.log -d $srcdir/cdda.cue -x 5 -v -r -- "1-"
  if test $? -ne 0 ; then
    exit 6
  fi
  mv cdda.raw cdda-jitter.raw
  if f:/usr/bin/cmp.exe cdda-jitter.raw cdda-good.raw ; then
    echo "** Small jitter correction okay"
  else
    echo "** Small jitter correction problem"
    exit 3
  fi
  tail -3 ./cd-paranoia.log | sed -e's/\[.*\]/\[\]/' > ./cd-paranoia-filtered.log
  if f:/usr/bin/cmp.exe $srcdir/cd-paranoia-log.right ./cd-paranoia-filtered.log ; then
    echo "** --log option okay"
    rm ./cd-paranoia.log ./cd-paranoia-filtered.log
  else
    echo "** --log option problem"
    exit 4
  fi
  # A more massive set of failures: underrun + small jitter
  $cd_paranoia -d $srcdir/cdda.cue -x 69 -v -r -- "1-"
  if test $? -ne 0 ; then
    exit 6
  fi
  mv cdda.raw cdda-jitter.raw
  if f:/usr/bin/cmp.exe cdda-jitter.raw cdda-good.raw ; then
    echo "** under-run + jitter correction okay"
  else
    echo "** under-run + jitter correction problem"
    exit 3
  fi
  ### FIXME: medium jitter is known to fail. Investigate.
  ### FIXME: large jitter is known to fail. Investigate.
  exit 0
else 
  if test "f:/usr/bin/cmp.exe" != no ; then
    echo "Don't see 'cmp' program. Test skipped."
  else  
    echo "Don't see libcdio 'cd-paranoia' program. Test skipped."
  fi
  exit 77
fi
fi
#;;; Local Variables: ***
#;;; mode:shell-script ***
#;;; eval: (sh-set-shell "bash") ***
#;;; End: ***

