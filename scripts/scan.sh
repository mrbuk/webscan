#!/bin/bash


OUTPUT_FILE_NAME=$1
if [ -z "${OUTPUT_FILE_NAME}" ]; then
	echo "ERROR: no output file name specified" 1>&2;
	exit 1
fi

mkdir /tmp/scan_data

OUTPUT_DIR=$(mktemp -d -p /tmp/scan_data/ XXXXXXXXX)

chmod +rx ${OUTPUT_DIR}

OUTPUT_FILE_PDF=${OUTPUT_DIR}/${OUTPUT_FILE_NAME}.pdf
OUTPUT_FILE_TIF=${OUTPUT_DIR}/${OUTPUT_FILE_NAME}.tif

#echo " scanning to fil '${OUTPUT_FILE_TIF}'"
# scan a4 image to tiff
scanimage -y 297 -x 210 --resolution=150 --format=tiff > ${OUTPUT_FILE_TIF}

# compress tiff
#echo " merging files '$(ls -1 ${OUTPUT_FILE_TIF}* | xargs)' to '${OUTPUT_FILE_TIF}.combined'"
tiffcp -c lzw ${OUTPUT_FILE_TIF} ${OUTPUT_FILE_TIF}.combined

# create pdf from compressed tiff
#echo " converting file '${OUTPUT_FILE_TIF}.combined' to '${OUTPUT_FILE_PDF}'"
tiff2pdf -p A4 -z ${OUTPUT_FILE_TIF}.combined> ${OUTPUT_FILE_PDF}

# delete output tiff files 
#echo " deleting files '$(ls -1 ${OUTPUT_FILE_TIF}* | xargs)'"
rm ${OUTPUT_FILE_TIF}*

echo ${OUTPUT_FILE_PDF}
