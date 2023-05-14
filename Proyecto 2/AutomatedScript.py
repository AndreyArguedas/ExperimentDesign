import random
import sys

# Define array to shuffle
my_array = [
            "5 min avg scenes\cloud\smoke-bvh.pbrt", 
            "5 min avg scenes\cloud\smoke-kdtree.pbrt",
            "5 min avg scenes\cloud\smoke-path.pbrt",
            "5 min avg scenes\cloud\smoke-mlt.pbrt",
            "5 min avg scenes\simple\spotfog-path.pbrt",
            "5 min avg scenes\simple\spotfog-mlt.pbrt",
            "5 min avg scenes\simple\spotfog-bvh.pbrt", 
            "5 min avg scenes\simple\spotfog-kdtree.pbrt",
            r"10 min avg scenes\buddha-fractal\buddha-fractal-bvh.pbrt",
            r"10 min avg scenes\buddha-fractal\buddha-fractal-kdtree.pbrt",
            r"10 min avg scenes\buddha-fractal\buddha-fractal-path.pbrt",
            r"10 min avg scenes\buddha-fractal\buddha-fractal-mlt.pbrt",
            r"30 min avg scenes\veach-bidir\bidir-bvh.pbrt",
            r"30 min avg scenes\veach-bidir\bidir-kdtree.pbrt",
            r"30 min avg scenes\veach-bidir\bidir-path.pbrt",
            r"30 min avg scenes\veach-bidir\bidir-mlt.pbrt"
            ]

# A dummy just to debug the whole process with very simple images
dummy_array = ["fast test\killeroo-simple.pbrt",
            "fast test\killeroo-simple-bvh.pbrt", 
            "fast test\killeroo-simple-kdtree.pbrt",
            ]

#my_array = dummy_array
raffleAmounts = sys.argv[1]

# Shuffle array

for i in range(int(raffleAmounts)):
    random.shuffle(my_array)

    # Save shuffled array to file
    with open('oficcialRaffles/raffle' + str(i) + ".txt", 'w') as f:
        for item in my_array:
            f.write(str(item) + '\n')
        print('Shuffled array saved to', 'oficcialRaffles/raffle' + str(i) + ".txt")

print('Once the raffle is done lets start running pbrt...')

#Here will go the code that calls the powershell

""" import subprocess

# Execute command
command = ".\pbrt.exe '.\fast test\killeroo-simple.pbrt' > output.txt 2>&1"  # replace this with your command
# Execute command and capture output
completed_process = subprocess.run(command, shell=True, capture_output=True, text=True)

# Save output to file
with open('output.txt', 'w') as f:
    f.write(completed_process.stdout)

print('Command output saved to output.txt') """