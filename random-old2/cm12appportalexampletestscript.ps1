# Create web service proxy
$catalogurl = "http://sadc1sccmd1.corp.stateauto.com/CMApplicationCatalog";
$url = $catalogurl+"/ApplicationViewService.asmx?WSDL";
$service = New-WebServiceProxy $url -UseDefaultCredential;