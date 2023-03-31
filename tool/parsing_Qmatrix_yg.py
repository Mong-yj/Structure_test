import os, sys, glob, re

BaseDir = './' + sys.argv[3] + '_structureH'
OutDir1 = './' + sys.argv[3] + '_Qmatrix_OUT'
OutDir2 = './' + sys.argv[3] + '_pong_params'

# mkdir outdir
AbsOutDir1 = os.path.abspath(OutDir1)
if not os.path.isdir(AbsOutDir1):
    os.mkdir(AbsOutDir1)
AbsOutDir2 = os.path.abspath(OutDir2)
if not os.path.isdir(AbsOutDir2):
    os.mkdir(AbsOutDir2)



filelist = []
# search structureHarvest output ind file
for file in glob.glob(BaseDir + '/' + "*.indfile"):
    file_base =os.path.basename(file)
    filelist.append(file_base)
filelist.sort()


# start index of K(small)
K_s = sys.argv[1]
# end index of K(big)
K_e = sys.argv[2]
K_s = int(K_s)

f_map_out = open(AbsOutDir2 + '/pong_filemap', 'wt')

# extract Q-matrix for replication without any tags
for each_file in filelist:
    rep_start = 1
    outbase = os.path.splitext(each_file)[0]
    f_in = open(BaseDir + '/'  + each_file, 'rt')
    for line in f_in:
        line = line.strip()
        # starting a run
        if line.startswith('1   1'):
            outfilename = AbsOutDir1 + '/' + outbase + '_' + str(rep_start) + '.Q'
            f_out = open(outfilename, 'wt')
            map_out_line = 'K'+ str(K_s) + 'r' + str(rep_start) + '\t' + str(K_s) + '\t' + outfilename + '\n'
            f_map_out.write(map_out_line)
        # end of q-matrix for one run
        elif not line:
            f_out.close()
            rep_start += 1
            continue
        q_list=re.split(' +', line)
        q_matrix = ' '.join(q_list[5:]) + '\n'
        f_out.write(q_matrix)
    K_s += 1
'''
aa = os.getcwd()
print(aa)
'''


