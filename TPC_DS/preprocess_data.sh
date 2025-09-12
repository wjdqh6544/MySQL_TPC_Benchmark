#!/bin/bash
# Replace NULL values in the first field with 0 to convert ^| into 0|.
# Replace NULL values in the middle fields with 0 to convert || into |0|.

for s_f in `ls *dat`
do
    echo "$s_f"
    sed 's/^|/0|/g;s/||/|0|/g;s/|$/|/g' -i $s_f
    sed 's/^|/0|/g;s/||/|0|/g;s/|$/|/g' -i $s_f
done

for s_f in item.dat store.dat web_page.dat web_site.dat call_center.dat
do
# Process the first and second date fields whose values are NULL (represented by 0).
sed 's/^\([A-Za-z0-9]*|[A-Za-z0-9]*\)|0|0|\(.*\)/\1|1111-11-11|1111-11-11|\2/' -i $s_f

# Process the second date fields whose values are NULL (represented by 0).
sed 's/^\([0-9A-Za-z]*|[A-Za-z0-9]*|[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)|0|\(.*\)/\1|1111-11-11|\2/' -i $s_f

# Process the first date fields whose values are NULL (represented by 0).
sed 's/^\([0-9A-Za-z]*|[A-Za-z0-9]*\)|0|\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}|.*\)/\1|1111-11-11|\2/' -i $s_f


done
