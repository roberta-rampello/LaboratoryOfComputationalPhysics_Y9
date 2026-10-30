
#! /bin/bash

##ho creato una cartella 'students' 
mkdir students 

##sono entrata nella cartella 'students'
cd students

##ho creato un file csv_file
touch csv_file 

##cerco se esiste il file da cui voglio scaricare i dati nella cartella, eventualmente lo creo e poi copio i suoi dati su csv_file

if [ -f "LCP_22-23_students.csv"]; then
    echo "File already exists locally."
    cp ../LCP_22-23_students.csv csv_file
else
    wget LCP_22-23_students.csv "https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&e=1"
    cp LCP_22-23_students.csv csv_file  
fi

#creato i file nuovi nella cartella
touch Physics_students
touch PoD_students

##copiato la riga di intestazione
head -n 1 csv_file > Physics_students
head -n 1 csv_file > PoD_students|

##aggiungo i corrispettivi studenti 
grep 'PoD' csv_file>>PoD_Students
grep 'Physics' csv_file >> Physics_Students

#For each letter of the alphabet, count the number of students whose surname starts with that letter.

mostcount=0
letter='a'

for i in {A..Z}; do
    count=$(tail -n +2 csv_file | awk '{print $2}' | grep -c "^$i")
    if [ "$count" -gt "$mostcount" ]; then
        mostcount=$count
        letter="$i"
    fi
    echo "Surnames starting with $i: $count"
done
echo "Surnames starting with $letter are the most numerous, they are $mostcount"

#creo 18 file con intestazione uguale a csv_file, ogni file è chiamato con il resto della divisione tra ilo numero dello studente e 18, quindi gli studenti (1,19,37,...)=gruppo1, (2,20,38,...)=gruppo2, (18,36,...)=gruppo0
for i in {0..17}; do
    head -n 1 csv_file > "group_$i.csv"
fi

student_num=1
tail -n +2 csv_file | while IFS= read -r line; do
    resto=$((student_num % 18))
    echo "$line" >> "group_$resto.csv"
    
    student_num=$((student_num + 1)
done
