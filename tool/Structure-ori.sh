
if [[ $# != 4 ]]
then
	echo "usage : sh Structure.sh Group Input_plink Cluster_Max#(>=3) PopInfoUse(Y or N)"
	echo "ARGV# = 4"
	exit
elif [[ $4 = "Y" && ! -f PopInfo ]]
then
	echo -e "There is no PopInfo file"
	echo -e "Format : ID\tGroupInfo(int 1..K)\tPopFlag(int 0 or 1)"
	exit
else
	echo -e "###########################################"
	echo -e "###Structure Analysis will be processing###"
	echo -e "###########################################"
	sleep 3
fi




PATH="/home/adminrig/miniconda2/bin:$PATH"
STRUCTURE_PATH="/home/adminrig/workspace.pyg/script/Structure"


######## ARGV ########

ID=$1
Input_plink=$2
Cluster_num=$3
PopInfo=$4



######################


plink2 --bfile $Input_plink --recode structure --out $ID
Marker_count=`wc -l $Input_plink.bim | awk '{print $1}'`
Sample_count=`wc -l $Input_plink.fam | awk '{print $1}'`


if [ $PopInfo = "Y" ]
then
	cp $STRUCTURE_PATH/PopInfo_Params/*params .
	perl $STRUCTURE_PATH/Make.strct_in.PopInfo.Format.pl $ID

	source activate pyg
	python $STRUCTURE_PATH/multi_structure_ke_yg.py $Cluster_num $Marker_count $Sample_count $ID Y
	python $STRUCTURE_PATH/Harvest/structureHarvester-master/structureHarvester.py --dir $ID\_structureOUT/ --out $ID\_structureH
	conda deactivate

	mkdir -p $ID\_Qmatrix_OUT
	grep ^K $ID\_structureH/summary.txt | cut -f3 | sort -u | while read line
	do
		grep "^K$line" $ID\_structureH/summary.txt | sed -n '1p'
	done | cut -f1 > $ID\_Qmatrix_OUT/BestSet_list


	mkdir $ID\_pong_params
	while read line
	do
		Outfile=`echo $line | sed 's/f/Q/g'`
		perl $STRUCTURE_PATH/Make.Qmatrix.PopInfo.Format.pl $ID $line $Sample_count > $ID\_Qmatrix_OUT/$Outfile
		
		K=`echo $Outfile | awk -F "_" '{print $1}' | sed 's/K//g'`
		R=`echo $Outfile | awk -F "_" '{print $2}'`
		echo -e "K${K}r$R\t$K\t$PWD/${ID}_Qmatrix_OUT/$Outfile" >> $ID\_pong_params/pong_filemap

	done < $ID\_Qmatrix_OUT/BestSet_list

else
	cp $STRUCTURE_PATH/Basic_Params/*params .
	source activate pyg
	python $STRUCTURE_PATH/multi_structure_ke_yg.py $Cluster_num $Marker_count $Sample_count $ID N
	python $STRUCTURE_PATH/Harvest/structureHarvester-master/structureHarvester.py --dir $ID\_structureOUT/ --out $ID\_structureH  --clumpp
	conda deactivate
	python $STRUCTURE_PATH/parsing_Qmatrix_yg.py 1 $Cluster_num $ID
fi


