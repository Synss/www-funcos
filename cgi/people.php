<?PHP

require_once("person-class.php");

function row($value) { return "<tr>".$value."</tr>"; }
function cell($value) { return "<td>".$value."</td>"; }
function ahref($name, $url) { return '<a href="'.$url.'">'.$name.'</a>'; }

function format($funcos, $firstname, $lastname, $id = null) {
	$p = new Person($firstname, $lastname, $id);
	$name = $p->firstname." ".$p->lastname;
	$url = @$p->url;
	if ($url) $name = ahref($name, $url);
	return row(cell($funcos).cell($name).cell($p->email).cell($p->tel))."\n";
}

echo ("<table><tbody>\n");
echo (join("\n",
 array(
	 format("1A", "Alexander", "Schneider"),
	 format("1B", "Sabine", "Maier", 41032317),
	 format("2A", "Hans-Peter", "Steinrück"),
	 format("2B", "Ole", "Lytken"),
	 format("2C", "Thomas", "Fauster"),
	 format("3A", "Jörg", "Libuda"),
	 format("3B", "Hans-Peter", "Steinrück"),
	 format("3C", "Mathias", "Laurin"),
	 format("4A", "Andreas", "Magerl"),
	 format("4B", "Rainer", "Fink"),
	 "<tr><td>5A</td> <td>Oliver Diwald</td> <td>oliver.diwald@sbg.ac.at</td> <td>+43-662-8044-5444</td> </tr>",
	 format("5B", "Patrik", "Schmuki"),
	 format("5C", "Hubertus", "Marbach"),
	 format("6A", "Andreas", "Görling"),
	 format("6B", "Michel", "Bockstedte"),
	 format("6C", "Bernd", "Meyer", 40704282),
	 )));
echo ("</tbody></table>\n")


?>

