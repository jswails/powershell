#Count users in the Access domain
import-module activedirectory

Get-ADOrganizationalUnit -filter * -SearchBase 'OU=Windows XP Users (lightly managed),DC=corp,DC=name,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 1000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv


Get-ADOrganizationalUnit -filter * -SearchBase 'OU=Windows XP Developers,DC=corp,DC=name,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 1000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv

Get-ADOrganizationalUnit -filter * -SearchBase 'OU=Windows XP Users,DC=corp,DC=name,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 1000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv
Get-ADOrganizationalUnit -filter * -SearchBase 'OU=User Objects,DC=corp,DC=name,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 3000 -resultSetSize 5000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv


Get-ADOrganizationalUnit -filter * -SearchBase 'OU=Windows 7 Users,DC=corp,DC=name,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 1000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv
Get-ADOrganizationalUnit -filter * -SearchBase 'OU=Windows 7 Users (lightly managed),DC=corp,DC=ma,e,DC=com' |

foreach {

  $users=Get-ADUser -filter * -searchbase $_.distinguishedname -ResultPageSize 2000 -resultSetSize 1000 -searchscope Onelevel 

  $total=($users | measure-object).count

  New-Object psobject -Property @{

    OU=$_.Name;

    Users=$Total

    }

} | out-file -append e:\wamp\tmp\adou.csv
