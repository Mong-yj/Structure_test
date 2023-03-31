import os, sys

BaseDir = './'
if sys.argv[5] == "Y":
 	input = BaseDir + sys.argv[4] + '_PopInfo.recode.strct_in'
else:
	input = BaseDir + sys.argv[4] + '.recode.strct_in'

#STRUCTURE = '~/tools/STRUCTURE/console/structure'
#mainparam = BaseDir + 'mainparams'
#extraparams = BaseDir + 'extraparams'

k_pop = sys.argv[1]
marker = sys.argv[2]
ind = sys.argv[3]
group=sys.argv[4]

k_pop = int(k_pop)
marker = int(marker)
ind = int(ind)
per = 10

def exe(cmd):
    os.system(cmd)



#k_pop = 10
for each_k in range(2,k_pop+1):
    for each_try in range(1,per+1):
        exe('mkdir ' + BaseDir + group + '_structureOUT')
        args = [
                'structure',
                '-K', str(each_k), 
                '-L', str(marker),
                '-N', str(ind), 
                '-i', input,
                '-D', str(int(each_try)*12345),
                '-o', BaseDir + group + '_structureOUT/' + 'K' + str(each_k) + '_' + str(each_try)
                ]
        print('args', args)
        cmd = ' '.join(args)
        exe(cmd)
