# /bin/sh

DIRPATH=$1

find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:red/color:#C11C66/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color=\"red\"/color=\"\#C11C66\"/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:#FF0000/color:#C11C66/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:.*#ff0000/color:#C11C66/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:#A52A2A/color:#C11C66/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:#0000FF/color:#005564/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color=\"0000FF\"/color:#005564/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color=\"\#FF0000\"/color=\"\#C11C66\"/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color=\"\#ff0000\"/color=\"\#C11C66\"/g"
find $DIRPATH  -name "*.htm" | xargs sed -i "s/color:.*\#c00000/color:\#C11C66/g"
find $DIRPATH  -name "help.js" | xargs sed -i "s/color:\#FF0000/color:\#C11C66/g"
find $DIRPATH  -name "help.js" | xargs sed -i "s/color:.*\#ff0000/color:\#C11C66/g"

