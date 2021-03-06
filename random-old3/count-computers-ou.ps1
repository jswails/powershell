import-module activedirectory
foreach ($ou in  Get-ADOrganizationalUnit  -filter * -SearchScope 1){
    $computers = (get-adcomputer -filter * -searchbase $ou.distinguishedname).count 
    $ou | add-member -membertype noteproperty -name Computers -value $computers -force
    $ou | select name,computers
    }