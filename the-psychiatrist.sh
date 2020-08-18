#!/bin/bash
#Program to log mood, and calculate them on weekly average

#Get color
source $HOME/snippets/color




#To check line count of log
DAYS=$( wc -l mood-log | awk ' {print $1}' )


PIPE(){
echo " | "
}

mood-processor(){
readarray -t MOODS <mood-log


#Set up variable to run through counter
COUNTER=0
HAVERAGE=0

#Run through the loop, and add log entires to variable
while [ $COUNTER -lt ${#MOODS[@]} ];
do
	let HAVERAGE=$HAVERAGE+${MOODS[$COUNTER]}
	let COUNTER++
done

#Calculate average and add it to end of log
let FAVERAGE=$HAVERAGE/$COUNTER

#Pass the average through gauge function
GAUGE=$(mood-gauge $FAVERAGE)
echo " Average: $FAVERAGE  $GAUGE" >> mood-log
}


mood-gauge(){

#Set up variables
GAUGE=("{" "." "." "." "." "." "." "." "." "." "." "}")
VAR=1

#Fill the gauge with mood input
while [ $VAR -le $1 ];
do
	GAUGE[$VAR]="#"
	let VAR++
done

#Color code according to mood

if [ $MOOD -ge 8 ];
then
	echo -e  "${GREEN} ${GAUGE[@]} $RESET"

elif [ $MOOD -ge 4 -a $MOOD -lt 8 ];
then
	echo -e "${BLUE} ${GAUGE[@]} $RESET"

elif [ $MOOD -ge 1 -a $MOOD -lt 4 ];
then
	echo -e "${RED} ${GAUGE[@]} $RESET"

fi


}

chart(){
#Store variable for While loop
local X=0

#Create the arrays for graph
EUPHORIC=("-" "-" "-" "-" "-" "-" "-")
ELATED=( "-" "-" "-" "-" "-" "-" "-" )
SANGUINE=( "-" "-" "-" "-" "-" "-" "-" )
HAPPY=("-" "-" "-" "-" "-" "-" "-")
EASE=( "-" "-" "-" "-" "-" "-" "-" )
NORMAL=( "-" "-" "-" "-" "-" "-" "-" )
DOLDRUMS=("-" "-" "-" "-" "-" "-" "-")
LETHARGIC=( "-" "-" "-" "-" "-" "-" "-" )
DESPONDENT=( "-" "-" "-" "-" "-" "-" "-" )
VERYDEPRESS=("-" "-" "-" "-" "-" "-" "-")

#Create an array from the mood-log
readarray -t MOODS <mood-log

#GET rid of last entry of mood
unset MOODS[8]


#Filter out entries with case statment, and create chart

while [ $X -lt 7 ];
do
	case ${MOODS[$X]} in
		10) EUPHORIC[$X]="#" ;;
         	9) ELATED[$X]="#" ;;
         	8) SANGUINE[$X]="#" ;;
         	7) HAPPY[$X]="#" ;;
         	6) EASE[$X]="#" ;;
         	5) NORMAL[$X]="#" ;;
	 	4) DOLDRUMS[$X]="#" ;;
	 	3) LETHARGIC[$X]="#" ;;
	 	2) DESPONDENT[$X]="#" ;;
	 	1) VERYDEPRESS[$X]="#" ;;
	esac
	
	let X++	

done




echo -e "${GREEN}${EUPHORIC[@]}\n${ELATED[@]}\n${SANGUINE[@]}\n${HAPPY[@]}$RESET\n${BLUE}${EASE[@]}\n${NORMAL[@]}\n${DOLDRUMS[@]}$RESET" >> mood-log
echo -e "${RED}${LETHARGIC[@]}\n${DESPONDENT[@]}\n${VERYDEPRESS[@]}$RESET" >> mood-log

}




#Opening
figlet -c The Pyschatrist
sleep 2
echo "$USER sure to add a log every day, for program to function properly"
sleep 3

#Rotate Logs
if [ "$DAYS" == "7" ];
then
	echo "Log week old, rotating"
	
	#Get the average for Mood
	mood-processor

	#Get the chart for Mood
	chart
	
	mv mood-log "$( date | awk ' {print $2 "-" $3 "-" $4}')"
	sleep 1
fi

while :
do
	clear
	echo "  --------Mood"
	PIPE
	echo "  -----10 Euphoric"
	PIPE
	echo "  ------8 Sanguine"
	PIPE
	echo "  ------6 Functioning with ease"
	PIPE
	echo "  ------4 Lethargic"
	PIPE
	echo "  ------2 Despondent, unable to complete simple tasks"
	PIPE
	echo "  ------1 Very Depressed, unstable, in need of immediate care"

	read -p "Please enter your mood[1-10] " MOOD

	if [ $MOOD -le 10 ];
	then
		GAUGE=$(mood-gauge $MOOD)
		echo "$GAUGE"
		echo "$MOOD" >> mood-log
		
		#Add day to sobriety counter
		bash sobriety-other.sh

		exit 0
	
	#User Error
	else
		echo "Please enter a number [1-10]"
	fi


done

exit 0
