#!/bin/sh

#------------------------------------------------------------------
#
#  horz_hist.sh
#
#------------------------------------------------------------------

set -ax
date
export list=$listvar

export xsize=x800
export ysize=y650
export hint=10    ##(mb) the plot pressure interval press+-hint
gdate=`$NDATE -168 $PDATE`

mkdir -p $LOGDIR

#
# image file destination
#
if [[ ! -d ${IMGNDIR} ]]; then
   mkdir -p ${IMGNDIR}
fi


### working directory

workdir=${STMP}/conv_monit/$SUFFIX

#### the list of data type, based on convinfo.txt file

ps_TYPE=" ps120_00 ps180_00 ps181_00 ps183_00 ps187_00 "
q_TYPE=" q120_00 q130_00 q132_00 q133_00 q134_00 q135_00 q180_00 q181_00 q182_00 q183_00 q187_00 "
t_TYPE=" t120_00 t130_00 t131_00 t132_00 t133_00 t134_00 t135_00 t180_00 t181_00 t182_00 t183_00 t187_00 "
uv_TYPE=" uv220_00 uv221_00 uv223_00 uv224_00 uv228_00 uv229_00 uv230_00 uv231_00 uv232_00 uv233_00 uv234_00 uv235_00 uv242_00 uv243_00 uv243_55 uv243_56 uv245_00 uv245_15 uv246_00 uv246_15 uv247_00 uv248_00 uv249_00 uv250_00 uv251_00 uv252_00 uv253_00 uv253_55 uv253_56 uv254_00 uv254_55 uv254_56 uv255_00 uv256_00 uv257_00 uv258_00 uv280_00 uv281_00 uv282_00 uv284_00 uv287_00"

rm -rf $workdir
mkdir -p $workdir
cd $workdir

mkdir -p $PDATE
cd $PDATE



mkdir -p $TANKDIR/horz_hist/ges
mkdir -p $TANKDIR/horz_hist/anl

rm -f $TANKDIR/horz_hist/ges/*${gdate}*
rm -f $TANKDIR/horz_hist/anl/*${gdate}*

for type in ps q t uv; do

   eval stype=\${${type}_TYPE}
   eval nreal=\${nreal_${type}}
   exec=read_${type}

   ## decoding the dignostic file

   for dtype in ${stype}; do
      echo "DEBUG:  dtype = $dtype"

      mtype=`echo ${dtype} | cut -f1 -d_`
      subtype=`echo ${dtype} | cut -f2 -d_`
      rm -f fileout

      for cycle in ges anl; do
         cp $DATDIR/diag_conv_${cycle}.${PDATE} conv_diag

         /bin/sh  $SCRIPTS/diag2grad_${type}_case.sh $SUFFIX $PDATE $FIXDIR $EXEDIR $cycle $nreal $TANKDIR/horz_hist/$cycle $mtype $subtype $hint $workdir/$PDATE 

      done    #### done with cycle

   done   ### done with dtype

done   ### done with type


#
# export variables 
#
#export listvar=PDATE,NDATE,DATDIR,TANKDIR,IMGNDIR,LLQ,WEBDIR,EXEDIR,FIXDIR,LOGDIR,SCRIPTS,GSCRIPTS,CTLDIR,STNMAP,GRADS,USER,STMP,SUB,SUFFIX,NPREDR,NCP,PLOT,PREFIX,ACCOUNT,MY_MACHINE,nreal_ps,nreal_q,nreal_t,nreal_uv,ps_TYPE,q_TYPE,t_TYPE,uv_TYPE,workdir,LOGDIR,hint,WS,WSUSER,xsize,ysize,listvar

#
# submit the plot_hist job
#
jobname="cmon_plothist_${SUFFIX}"
plot_hist="${SCRIPTS}/plot_hist.sh"
logfile="${LOGDIR}/plothist_${SUFFIX}.log"
rm -rf $logfile

if [[ $MY_MACHINE = "wcoss" ]]; then
   $SUB -q $JOB_QUEUE -P $PROJECT -o ${logfile} -R affinity[core] -M 100 -W 0:50 -J ${jobname} ${plot_hist}
fi


#
# submit the plot_horz job
#
jobname="cmon_plothorz_${SUFFIX}"
plot_horz="${SCRIPTS}/plot_horz.sh"
logfile="${LOGDIR}/plothorz_${SUFFIX}.log"
rm -rf $logfile

if [[ $MY_MACHINE = "wcoss" ]]; then
   $SUB -q $JOB_QUEUE -P $PROJECT -o ${logfile} -R affinity[core] -M 100 -W 0:50 -J ${jobname} ${plot_horz}
fi


#
# submit the plot_horz_uv job
#
jobname="cmon_plothorz_uv_${SUFFIX}"
plot_horz_uv="${SCRIPTS}/plot_horz_uv.sh"
logfile="${LOGDIR}/plothorz_uv_${SUFFIX}.log"
rm -rf $logfile
if [[ $MY_MACHINE = "wcoss" ]]; then
   $SUB -q $JOB_QUEUE -P $PROJECT -o ${logfile} -R affinity[core] -M 100 -W 0:50 -J ${jobname} ${plot_horz_uv}
fi


exit

