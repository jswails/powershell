if((Test-Connection -Cn onesource -BufferSize 16 -Count 1 -ea 0 -quiet))

  {
  sleep 10
  if(!(Test-Connection -Cn onesource -BufferSize 16 -Count 1 -ea 0 -quiet))
  { sleep 20 }
  else { 
start iexplore.exe http://onesource
}
}