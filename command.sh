# 1. data prep
julia ../bin/mkdfa.jl sample
julia ../bin/prompts2wlist.jl prompts.txt wlist
HDMan -A -D -T 1 -m -w wlist -n monophones1 -i -l dlog dict ../lexicon/VoxForgeDict.txt
# buat monophones0 copy monophones1 trus apus sp
julia ../bin/prompts2mlf.jl prompts.txt words.mlf
HLEd -A -D -T 1 -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf
HLEd -A -D -T 1 -l '*' -d dict -i phones1.mlf mkphones1.led words.mlf
HCopy -A -D -T 1 -C wav_config -S codetrain.scp
# 2. monophones
HCompV -A -D -T 1 -C config -f 0.01 -m -S train.scp -M hmm0 proto
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 monophones0
HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm5/macros -H  hmm5/hmmdefs -M hmm6 monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 monophones1
HVite -A -D -T 1 -l '*' -o SWT -b SENT-END -C config -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I words.mlf -S train.scp dict monophones1> HVite_log
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8 monophones1
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9 monophones1
# 3. triphones
HLEd -A -D -T 1 -n triphones1 -l '*' -i wintri.mlf mktri.led aligned.mlf
julia ../bin/mktrihed.jl monophones1 triphones1 mktri.hed
HHEd -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -M hmm10 mktri.hed monophones1 
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm10/macros -H hmm10/hmmdefs -M hmm11 triphones1
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -s stats -S train.scp -H hmm11/macros -H hmm11/hmmdefs -M hmm12 triphones1
HDMan -A -D -T 1 -b sp -n fulllist0 -g maketriphones.ded -l flog dict-tri ../lexicon/VoxForgeDict.txt
julia ../bin/fixfulllist.jl fulllist0 monophones0 fulllist
cat tree1.hed > tree.hed
julia ../bin/mkclscript.jl monophones0 tree.hed
HHEd -A -D -T 1 -H hmm12/macros -H hmm12/hmmdefs -M hmm13 tree.hed triphones1
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm13/macros -H hmm13/hmmdefs -M hmm14 tiedlist
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm14/macros -H hmm14/hmmdefs -M hmm15 tiedlist
