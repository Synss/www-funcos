<?php

require_once("person-class.php");

function format($role, $firstname, $lastname, $id) {
	$p = new Person($firstname, $lastname, $id);

	$ar = array("<h3>".$role."</h3>");
	$ar[] = "<h4>".join(" ", array($p->title, $p->firstname, $p->lastname))."</h4>";
	$ar[] = "<p>";
	$ar[] = $p->orgunits[0]["orgunit"]."<br />";
	$ar[] = "tel: ".$p->tel."<br />";
	$ar[] = "fax: ".$p->fax."<br />";
	$url = @$p->url;
	if ($url) $ar[] = '<a href="'.$url.'">'.$url.'</a><br />';
	$ar[] = $p->email;
	$ar[] = "</p>";
	return $ar;
}

echo (join("\n", format($_GET["role"], $_GET["firstname"], $_GET["lastname"], $_GET["id"])));

?>
