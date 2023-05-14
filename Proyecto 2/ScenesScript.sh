# Define path to text file
file_path="oficcialRaffles/raffle0.txt"

# Read lines of text file
text_lines=$(cat "$file_path")
counter=0
saveAllLogs=false
if [ -f "timeTook.txt" ]; then
    > "timeTook.txt"
fi
    
# Print each line
for line in $text_lines; do
    if [ "$saveAllLogs" = true ]; then
        concatenated_string=".\\pbrt.exe '.\\$line' > testing$counter.txt 2>&1"
    else
        concatenated_string=".\\pbrt.exe '.\\$line'"
    fi
    
    echo "$line" >> timeTook.txt
    { time sh -c "$concatenated_string"; } 2>> timeTook.txt
    echo "$line"
    echo "$concatenated_string"
    counter=$((counter+1))
done