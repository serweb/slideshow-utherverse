Get-ChildItem -Path "C:\Users\sdeleonardis\OneDrive - PROMINENTE S.A\Descargas" -File |
Where-Object { $_.Extension -in ".jpg",".jpeg",".png",".webp" } |
ForEach-Object { $_.Name } |
Set-Content -Encoding UTF8 "C:\Users\sdeleonardis\OneDrive - PROMINENTE S.A\Descargas\slides.txt"