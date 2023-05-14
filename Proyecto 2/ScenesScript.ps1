﻿# Define path to text file
$file_path = "oficcialRaffles/raffle0.txt"

# Read lines of text file
$text_lines = Get-Content $file_path
$counter = 0
$saveAllLogs = $false
if(Test-Path "timeTook.txt"){
    Clear-Content "timeTook.txt"
}
    
# Print each line
foreach ($line in $text_lines) {
    if ($saveAllLogs -eq $true){
        $concatenated_string = ".\pbrt.exe '.\" + $line + "' > testing" + $counter + ".txt 2>&1"
    }
    else{
        $concatenated_string = ".\pbrt.exe '.\" + $line + "'"
    }
    
    $line | Out-File timeTook.txt -Append
    Measure-Command { Invoke-Expression $concatenated_string } | Out-File timeTook.txt -Append
    Write-Output $line
    Write-Output $concatenated_string
    $counter++
}




#.\pbrt.exe '.\fast test\killeroo-simple.pbrt' > killeroo-simple.txt 2>&1 #super fast test

#.\pbrt.exe '.\fast test\killeroo-simple-bvh.pbrt' > killeroo-simple-bvh.txt 2>&1 #super fast test

#.\pbrt.exe '.\fast test\killeroo-simple-kdtree.pbrt' > killeroo-simple-kdtree.txt 2>&1 #super fast test


#.\pbrt.exe '.\5 min avg scenes\cloud\smoke.pbrt' > smoke.txt 2>&1 #5 min

#.\pbrt.exe '.\5 min avg scenes\cloud\smoke-bvh.pbrt' > smoke-bvh.txt 2>&1 #5 min

#.\pbrt.exe '.\5 min avg scenes\cloud\smoke-kdtree.pbrt' > smoke-kdtree.txt 2>&1 #5 min


#.\pbrt.exe '.\5 min avg scenes\simple\spotfog.pbrt' > spotfog.txt 2>&1 #8 min

#.\pbrt.exe '.\5 min avg scenes\simple\spotfog-bvh.pbrt' > spotfog-bvh.txt 2>&1 #8 min

#.\pbrt.exe '.\5 min avg scenes\simple\spotfog-kdtree.pbrt' > spotfog-kdtree.txt 2>&1 #8 min


#.\pbrt.exe '.\10 min avg scenes\buddha-fractal\buddha-fractal.pbrt' > buddha-fractal.txt 2>&1 #9 min

#.\pbrt.exe '.\10 min avg scenes\buddha-fractal\buddha-fractal-bvh.pbrt' > buddha-fractal-bvh.txt 2>&1 #9 min

#.\pbrt.exe '.\10 min avg scenes\buddha-fractal\buddha-fractal-kdtree.pbrt' > buddha-fractal-kdtree.txt 2>&1 #9 min


#.\pbrt.exe '.\10 min avg scenes\glass\glass.pbrt' #9 min

#.\pbrt.exe '.\10 min avg scenes\glass\glass-bvh.pbrt' #9 min

#.\pbrt.exe '.\10 min avg scenes\glass\glass-kdtree.pbrt' #9 min


#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal.pbrt' #14 min

#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal-bvh.pbrt' #14 min

#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal-kdtree.pbrt' #14 min


#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal.pbrt' #14 min

#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal-bvh.pbrt' #14 min

#.\pbrt.exe '.\10 min avg scenes\simple\teapot-metal-kdtree.pbrt' #14 min


#.\pbrt.exe '.\20 min avg scenes\yeahright\yeahright.pbrt' #20 min

#.\pbrt.exe '.\20 min avg scenes\yeahright\yeahright-bvh.pbrt' #20 min

#.\pbrt.exe '.\20 min avg scenes\yeahright\yeahright-kdtree.pbrt' #20 min


#.\pbrt.exe '.\30 min avg scenes\simple\bidir.pbrt' > bidir.txt 2>&1 #30 min

#.\pbrt.exe '.\30 min avg scenes\simple\bidir-bvh.pbrt' > bidir-bvh.txt 2>&1 #30 min

#.\pbrt.exe '.\30 min avg scenes\simple\bidir-kdtree.pbrt' > bidir-kdtree.txt 2>&1 #30 min