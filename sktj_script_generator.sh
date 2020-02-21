#!/bin/bash

cd $HOME/Documents/Skrypt

# handle whitespace in file names with IFS variable
OLDIFS=$IFS
IFS=$'\n'

# remove duplicate images
echo -n "Removing unnecessary duplicates..."
#rm -f `ls *.gif`
rm -f Skrypt_201?.pdf && rm -f Skrypt_SKTJ_201*.pdf
#rm -f 05[0-4].jpg
rm -f 01[6-8].jpg
rm -f '045.docx' && rm -f 04[2-4].jpg && rm -f 04[6-8].jpg
echo "done"

# Convert all word files to pdf
###############################
docfiles=`ls *.{doc,docx}`
for docfile in $docfiles
do
	soffice --headless --convert-to pdf $docfile && rm -f $docfile
done

# Convert all images to grayscale pdf files
###########################################

imagefiles=`ls *.jpg`
for imagefile in $imagefiles
do
	echo -n "Converting $imagefile to ${imagefile%%.*}.pdf..."
	convert $imagefile -colorspace gray -quality 100 -density 300 ${imagefile%%.*}.pdf && rm -f $imagefile
	echo "done"
done

# Concatenate all pdf files into one
####################################
now=$(date +'%d-%m-%Y')
outputfile=$HOME/Documents/Skrypt_SKTJ_${now}.pdf
echo -n "Concatenating files..."
gs \
	-sDEVICE=pdfwrite \
	-sPAPERSIZE=a4 \
	-dFIXEDMEDIA \
	-dPDFFitPage \
	-dCompatibilityLevel=1.4 \
	-dPDFSETTINGS=/default \
	-dNOPAUSE \
	-dQUIET \
	-dBATCH \
	-dDetectDuplicateImages \
	-sProcessColorModel=DeviceGray \
    -sColorConversionStrategy=Gray \
    -dOverrideICC \
	-dCompressFonts=true \
	-r150 \
	-sOutputFile=$outputfile `ls -1v *.pdf`
echo " done"

# back to old way of handling whitespace
IFS=$OLDIFS
