# Create web service proxy
$catalogurl = "http://sccmserver/CMApplicationCatalog";
$url = $catalogurl+"/ApplicationViewService.asmx?WSDL";
$service = New-WebServiceProxy $url -UseDefaultCredential;
