if (!(test-path "h:\" ) )
{
$a = new-object -comobject wscript.shell
$b = $a.popup(" Warning no h drive. ",0)

}