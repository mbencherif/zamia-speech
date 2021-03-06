#!/bin/bash

if [ $# != 2 ] ; then
    echo "usage: $0 <model> [kaldi|sphinx_cont|sphinx_ptm|sequitur|srilm]"
    exit 1
fi

MODEL=$1
WHAT=$2
DISTDIR=data/dist

datum=`date +%Y%m%d`

if [ $WHAT = "kaldi" ] ; then

    #
    # kaldi chain models 
    #

    AMNAME="kaldi-chain-${MODEL}-r$datum"

    echo "$AMNAME ..."

    mkdir -p "$DISTDIR/$AMNAME"

    function export_kaldi_chain {

        EXPNAME=$1
        GRAPHNAME=$2

        mkdir -p "$DISTDIR/$AMNAME/$EXPNAME"

        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$EXPNAME/final.mdl                  $DISTDIR/$AMNAME/$EXPNAME/
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$EXPNAME/cmvn_opts                  $DISTDIR/$AMNAME/$EXPNAME/ 2>/dev/null 
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$EXPNAME/tree                       $DISTDIR/$AMNAME/$EXPNAME/ 2>/dev/null 

        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$GRAPHNAME/HCLG.fst                 $DISTDIR/$AMNAME/$EXPNAME/
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$GRAPHNAME/words.txt                $DISTDIR/$AMNAME/$EXPNAME/
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$GRAPHNAME/num_pdfs                 $DISTDIR/$AMNAME/$EXPNAME/
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$GRAPHNAME/phones/*                 $DISTDIR/$AMNAME/$EXPNAME/
        cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/$GRAPHNAME/phones.txt               $DISTDIR/$AMNAME/$EXPNAME/

        cp data/dst/asr-models/kaldi/${MODEL}/data/local/dict/*                                   $DISTDIR/$AMNAME/$EXPNAME/

    }

    export_kaldi_chain tdnn_sp tdnn_sp/graph
    export_kaldi_chain tdnn_250 tdnn_250/graph

    mkdir -p "$DISTDIR/$AMNAME/extractor"

    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/extractor/final.mat                  "$DISTDIR/$AMNAME/extractor/"
    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/extractor/global_cmvn.stats          "$DISTDIR/$AMNAME/extractor/"
    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/extractor/final.dubm                 "$DISTDIR/$AMNAME/extractor/"
    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/extractor/final.ie                   "$DISTDIR/$AMNAME/extractor/"
    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/extractor/splice_opts                "$DISTDIR/$AMNAME/extractor/"
    cp data/dst/asr-models/kaldi/${MODEL}/exp/nnet3_chain/ivectors_test_hires/conf/splice.conf "$DISTDIR/$AMNAME/extractor/"

    cp data/dst/asr-models/kaldi/${MODEL}/RESULTS.txt $DISTDIR/$AMNAME/
    cp README.md "$DISTDIR/$AMNAME"
    cp LICENSE   "$DISTDIR/$AMNAME"
    cp AUTHORS   "$DISTDIR/$AMNAME"

    mkdir -p "$DISTDIR/$AMNAME/conf"
    cp data/src/speech/kaldi-mfcc.conf        $DISTDIR/$AMNAME/conf/mfcc.conf 
    cp data/src/speech/kaldi-mfcc-hires.conf  $DISTDIR/$AMNAME/conf/mfcc-hires.conf  
    cp data/src/speech/kaldi-online-cmvn.conf $DISTDIR/$AMNAME/conf/online_cmvn.conf

    pushd $DISTDIR
    tar cfv "$AMNAME.tar" $AMNAME
    xz -v -8 -T 12 "$AMNAME.tar"
    popd

    rm -r "$DISTDIR/$AMNAME"

fi

if [ $WHAT = "sphinx_cont" ] ; then

    #
    # cont sphinx model
    #

    AMNAME="cmusphinx-cont-${MODEL}-r$datum"
    echo "$AMNAME ..."

    mkdir -p "$DISTDIR/$AMNAME"
    mkdir -p "$DISTDIR/$AMNAME/model_parameters"

    cp -r data/dst/asr-models/cmusphinx_cont/${MODEL}/model_parameters/voxforge.cd_cont_6000 "$DISTDIR/$AMNAME/model_parameters"
    cp -r data/dst/asr-models/cmusphinx_cont/${MODEL}/etc "$DISTDIR/$AMNAME"
    cp    data/dst/asr-models/cmusphinx_cont/${MODEL}/voxforge.html "$DISTDIR/$AMNAME"
    cp README.md "$DISTDIR/$AMNAME"
    cp LICENSE   "$DISTDIR/$AMNAME"
    cp AUTHORS   "$DISTDIR/$AMNAME"

    pushd $DISTDIR
    tar cfv "$AMNAME.tar" $AMNAME
    xz -v -8 -T 12 "$AMNAME.tar"
    popd

    rm -r "$DISTDIR/$AMNAME"
fi

if [ $WHAT = "sphinx_ptm" ] ; then

    #
    # ptm sphinx model
    #

    AMNAME="cmusphinx-ptm-${MODEL}-r$datum"
    echo "$AMNAME ..."

    mkdir -p "$DISTDIR/$AMNAME"
    mkdir -p "$DISTDIR/$AMNAME/model_parameters"

    cp -r data/dst/asr-models/cmusphinx_ptm/${MODEL}/model_parameters/voxforge.cd_ptm_5000 "$DISTDIR/$AMNAME/model_parameters"
    cp -r data/dst/asr-models/cmusphinx_ptm/${MODEL}/etc "$DISTDIR/$AMNAME"
    cp    data/dst/asr-models/cmusphinx_ptm/${MODEL}/voxforge.html "$DISTDIR/$AMNAME"
    cp README.md "$DISTDIR/$AMNAME"
    cp LICENSE   "$DISTDIR/$AMNAME"
    cp AUTHORS   "$DISTDIR/$AMNAME"

    pushd $DISTDIR
    tar cfv "$AMNAME.tar" $AMNAME
    xz -v -8 -T 12 "$AMNAME.tar"
    popd

    rm -r "$DISTDIR/$AMNAME"
fi

if [ $WHAT = "srilm" ] ; then
    #
    # srilm
    #

    LMNAME="srilm-${MODEL}-r$datum.arpa"
    echo "$LMNAME ..."
    # data/dst/lm/generic_de_lang_model/
    cp data/dst/lm/${MODEL}/lm.arpa ${DISTDIR}/$LMNAME
    gzip ${DISTDIR}/$LMNAME
fi

if [ $WHAT = "sequitur" ] ; then
    #
    # sequitur
    #

    MODELNAME="sequitur-${MODEL}-r$datum"
    echo "$MODELNAME ..."
    cp data/dst/dict-models/${MODEL}/sequitur/model-6 $DISTDIR/$MODELNAME
    gzip $DISTDIR/$MODELNAME
fi

#
# copyright info
#

cp README.md "$DISTDIR"
cp LICENSE   "$DISTDIR"
cp AUTHORS   "$DISTDIR"

#
# upload
#

echo rsync -avPz --bwlimit=256 data/dist/ goofy:/var/www/html/voxforge/

#
# FIXME: remove deprecated code below
#

exit 0

# 
# cmuclmtk
#

# LMNAME="cmuclmtk-voxforge-${LANG}-r$datum.arpa"
# cp data/dst/speech/${LANG}/cmusphinx_cont/voxforge.arpa $DISTDIR/$LMNAME
# gzip $DISTDIR/$LMNAME

#
# kaldi nnet3 models 
#

AMNAME="kaldi-nnet3-voxforge-${LANG}-r$datum"

mkdir -p "$DISTDIR/$AMNAME"

function export_kaldi_nnet3 {

    EXPNAME=$1
    GRAPHNAME=$2

    mkdir -p "$DISTDIR/$AMNAME/$EXPNAME"

    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$EXPNAME/final.mdl                  $DISTDIR/$AMNAME/$EXPNAME/
    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$EXPNAME/cmvn_opts                  $DISTDIR/$AMNAME/$EXPNAME/ 2>/dev/null 

    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$GRAPHNAME/HCLG.fst                 $DISTDIR/$AMNAME/$EXPNAME/
    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$GRAPHNAME/words.txt                $DISTDIR/$AMNAME/$EXPNAME/
    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$GRAPHNAME/num_pdfs                 $DISTDIR/$AMNAME/$EXPNAME/
    cp data/dst/speech/${LANG}/kaldi/exp/nnet3/$GRAPHNAME/phones/align_lexicon.int $DISTDIR/$AMNAME/$EXPNAME/

}

export_kaldi_nnet3 nnet_tdnn_a  nnet_tdnn_a/graph
# export_kaldi_nnet3 lstm_ld5     lstm_ld5/graph

mkdir -p "$DISTDIR/$AMNAME/extractor"

cp data/dst/speech/${LANG}/kaldi/exp/nnet3/extractor/final.mat            "$DISTDIR/$AMNAME/extractor/"
cp data/dst/speech/${LANG}/kaldi/exp/nnet3/extractor/global_cmvn.stats    "$DISTDIR/$AMNAME/extractor/"
cp data/dst/speech/${LANG}/kaldi/exp/nnet3/extractor/final.dubm           "$DISTDIR/$AMNAME/extractor/"
cp data/dst/speech/${LANG}/kaldi/exp/nnet3/extractor/final.ie             "$DISTDIR/$AMNAME/extractor/"
cp data/dst/speech/${LANG}/kaldi/exp/nnet3/extractor/splice_opts          "$DISTDIR/$AMNAME/extractor/"
cp data/dst/speech/${LANG}/kaldi/exp/nnet3/ivectors_test/conf/splice.conf "$DISTDIR/$AMNAME/extractor/"

cp data/dst/speech/${LANG}/kaldi/RESULTS.txt $DISTDIR/$AMNAME/
cp README.md "$DISTDIR/$AMNAME"
cp LICENSE   "$DISTDIR/$AMNAME"
cp AUTHORS   "$DISTDIR/$AMNAME"

mkdir -p "$DISTDIR/$AMNAME/conf"
cp data/src/speech/kaldi-mfcc.conf        $DISTDIR/$AMNAME/conf/mfcc.conf 
cp data/src/speech/kaldi-mfcc-hires.conf  $DISTDIR/$AMNAME/conf/mfcc-hires.conf  
cp data/src/speech/kaldi-online-cmvn.conf $DISTDIR/$AMNAME/conf/online_cmvn.conf

pushd $DISTDIR
tar cfv "$AMNAME.tar" $AMNAME
xz -v -8 -T 12 "$AMNAME.tar"
popd

rm -r "$DISTDIR/$AMNAME"

